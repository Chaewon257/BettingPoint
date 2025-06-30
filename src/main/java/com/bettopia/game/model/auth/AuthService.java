package com.bettopia.game.model.auth;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.bettopia.game.Exception.SessionExpiredException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.bettopia.game.Exception.InvalidPasswordException;
import com.bettopia.game.Exception.InvalidTokenException;
import com.bettopia.game.Exception.UserNotFoundException;
import com.bettopia.game.util.JWTUtil;

@Service
public class AuthService {

	@Autowired
	private LoginDAO loginDAO;

	@Autowired
	private JWTUtil jwtUtil;

	@Autowired
	private UserDAO userDAO;

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
				.build();
		
		loginDAO.insertUser(user);
	}

	public void updateUser(UserVO userRequest, String userId) {
		userDAO.updateUser(userRequest, userId);
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
}
