package com.bettopia.game.model.auth;

import java.util.HashMap;
import java.util.Map;

import com.bettopia.game.Exception.SessionExpiredException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.bettopia.game.Exception.InvalidPasswordException;
import com.bettopia.game.Exception.InvalidTokenException;
import com.bettopia.game.Exception.UserNotFoundEception;
import com.bettopia.game.util.JWTUtil;

@Service
public class AuthService {

	@Autowired
	private LoginDAO loginDAO;

	@Autowired
	private JWTUtil jwtUtil;

	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	
	// 로그인 요청 검증
	public Map<String, String> login(LoginRequestDTO request) {
		Map<String, String> responseToken = new HashMap<String, String>();
		
		UserVO user = loginDAO.findByEmail(request.getEmail());

		if (user == null) {
			throw new UserNotFoundEception();
		} else if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
			throw new InvalidPasswordException();
		}

		String accessToken = jwtUtil.generateAccessToken(user.getUid());
		String refreshToken = jwtUtil.generateRefreshToken(user.getUid());

		loginDAO.updateRefreshToken(user.getUid(), refreshToken);
		
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
}
