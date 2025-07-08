package com.bettopia.game.model.auth;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.bettopia.game.Exception.InvalidPasswordException;
import com.bettopia.game.Exception.InvalidTokenException;
import com.bettopia.game.Exception.InvalidUpdatePasswordException;
import com.bettopia.game.Exception.SessionExpiredException;
import com.bettopia.game.Exception.UserNotFoundException;
import com.bettopia.game.model.aws.S3FileServiceReturnKey;
import com.bettopia.game.util.JWTUtil;

@Service
public class AuthService {

	@Autowired
	private LoginDAO loginDAO;

	@Autowired
	private JWTUtil jwtUtil;

	@Autowired
	private UserDAO userDAO;
	
	@Autowired
	private S3FileServiceReturnKey s3FileService;

	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	
	// 로그인 요청 검증
	public Map<String, String> login(LoginRequestDTO request) {
		Map<String, String> responseToken = new HashMap<String, String>();
		
		UserVO user = loginDAO.findByEmail(request.getEmail());

		if (user == null) {
			throw new UserNotFoundException();
		} else if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
			throw new InvalidPasswordException();
		}

		String accessToken = jwtUtil.generateAccessToken(user.getUid());
		String refreshToken = jwtUtil.generateRefreshToken(user.getUid());

		loginDAO.updateRefreshToken(user.getUid(), refreshToken);
		loginDAO.updateLastLoginAt(user.getUid());
		
		responseToken.put("accessToken", accessToken);
		responseToken.put("refreshToken", refreshToken);
		
		return responseToken;
	}

	public String reissue(String refreshToken) {
		if (!jwtUtil.validateToken(refreshToken)) {
			throw new InvalidTokenException();
		}

		String userId = jwtUtil.getUserIdFromToken(refreshToken);
		return jwtUtil.generateAccessToken(userId);
	}

	public UserVO findByUid(String uid) {
		return loginDAO.findByUid(uid);
	}

	public String validateAndGetUserId(String authHeader) {
		if (authHeader == null || !authHeader.startsWith("Bearer ")) {
			throw new InvalidTokenException();
		}
		String token = authHeader.substring(7);
		if (!jwtUtil.validateToken(token)) {
			throw new SessionExpiredException();
		}
		return jwtUtil.getUserIdFromToken(token);
	}
	
	// 이메일 중복 검사
	public boolean isEmailExists(String email) {
		return loginDAO.countByEmail(email) > 0;
	}
	
	// 닉네임 중복 검사
	public boolean isNicknameExists(String nickname) {
		return loginDAO.countByNickname(nickname) > 0;
	}

	public boolean isPhoneNumberExists(String phone_number) {
		return loginDAO.countByPhoneNumber(phone_number) > 0;
	}

	public void register(UserRegisterDTO dto) {
	// String → java.sql.Date 변환
    Date birthDate = null;
    try {
        java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(dto.getBirth_date());
        birthDate = new Date(utilDate.getTime());
    } catch (ParseException e) {
        throw new IllegalArgumentException("생년월일 형식이 올바르지 않습니다. (yyyy-MM-dd)", e);
    }
    
		UserVO user = UserVO.builder()
				.uid(UUID.randomUUID().toString().replace("-", ""))
				.user_name(dto.getUser_name())
				.password(passwordEncoder.encode(dto.getPassword()))
				.nickname(dto.getNickname())
				.email(dto.getEmail())
				.birth_date(birthDate)
				.phone_number(dto.getPhone_number())
				.agree_privacy(dto.isAgree_privacy())
				.point_balance(0)
				.build();
		
		loginDAO.insertUser(user);
	}

	public void updateUser(UserUpdateRequestDTO userRequest, String userId) {
		// 기존 정보 조회
		UserVO existingUser = loginDAO.findByUid(userId);
	    if (existingUser == null) {
	        throw new RuntimeException("사용자를 찾을 수 없습니다.");
	    }
	    
	    // 🔐 현재 비밀번호 확인
	    if (!passwordEncoder.matches(userRequest.getPassword(), existingUser.getPassword())) {
	        throw new InvalidUpdatePasswordException();
	    }
	    
	    // 🔒 새 비밀번호가 들어온 경우 암호화 후 저장
	    if (userRequest.getNew_password() != null && !userRequest.getNew_password().isBlank()) {
	        String encodedNewPassword = passwordEncoder.encode(userRequest.getNew_password());
	        existingUser.setPassword(encodedNewPassword);
	    } else {
	    	// 새 비밀번호를 입력하지 않았다면 기존 비밀번호를 유지
	        existingUser.setPassword(existingUser.getPassword());
	    }
		
	    // 📱 전화번호: 무조건 수정 (빈 문자열이면 그대로 저장됨)
	    existingUser.setPhone_number(userRequest.getPhone_number());
	    
	    // 🎂 생년월일: null이 아니면 수정
	    if (userRequest.getBirth_date() != null) {
	        existingUser.setBirth_date(userRequest.getBirth_date());
	    }
	    
	    // ✅ 프로필 이미지 처리
	    MultipartFile newImage = userRequest.getProfile_image();
	    String oldUrl = userRequest.getProfile_img_url();
	    if (newImage != null && !newImage.isEmpty()) {
	        if (oldUrl != null && !oldUrl.isBlank()) {
		        // 기존 이미지가 있다면 S3에서 삭제
	            String key = extractObjectKeyFromUrl(oldUrl);
	            s3FileService.deleteObject(key);
	        }

	        // 새 이미지 업로드
	        String newUrl = s3FileService.uploadFile(newImage);
	        existingUser.setProfile_img(newUrl);
	    } else {
	    	// 이미지 변경 안 했다면
	    	oldUrl = extractObjectKeyFromUrl(oldUrl);
	    	existingUser.setProfile_img(oldUrl != null ? oldUrl : "");
	    }
		userDAO.updateUser(existingUser, userId);
	}
	
	private String extractObjectKeyFromUrl(String url) {
	    if (url == null || url.isBlank()) return null;

	    // https://your-bucket.s3.amazonaws.com/images/folder/file.png
	    int index = url.indexOf(".amazonaws.com/");
	    if (index == -1) return null;

	    // object key 부분만 추출
	    return url.substring(index + ".amazonaws.com/".length());
	}

	public void addPoint(int point, String userId) {
		userDAO.addPoint(point, userId);
	}

	public void losePoint(int point, String userId) {
		userDAO.losePoint(point, userId);
	}

	public void logout(String userId) {
		userDAO.logout(userId);
	}

	public String getUserEmail(String userName, String phoneNumber) {
		return userDAO.getUserEmail(userName, phoneNumber);
	}

	public void updatePassword(String userId, String password) {
		userDAO.updatePassword(userId, password);
	}

	public UserVO findByEmail(String email) {
		return userDAO.findByEmail(email);
	}
}
