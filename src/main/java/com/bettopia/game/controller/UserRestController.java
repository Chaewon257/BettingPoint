package com.bettopia.game.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.util.JWTUtil;

@RestController
@RequestMapping("/api/user/")
public class UserRestController {
	@Autowired
	JWTUtil jwtUtil;

	@Autowired
	private AuthService authService;

	@GetMapping("/me")
	public ResponseEntity<?> getMyInfo(@RequestHeader("Authorization") String authHeader) {
		if (authHeader == null || !authHeader.startsWith("Bearer ")) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("토큰이 없습니다.");
		}

		String token = authHeader.substring(7);
		if (!jwtUtil.validateToken(token)) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("유효하지 않은 토큰입니다.");
		}

		String userId = jwtUtil.getUserIdFromToken(token);
		UserVO user = authService.findByUid(userId); // 또는 getUserByUid(userId)

		return ResponseEntity.ok(Map.of("username", user.getUser_name()));
	}
}