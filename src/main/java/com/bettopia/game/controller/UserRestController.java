package com.bettopia.game.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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
		String userId = authService.validateAndGetUserId(authHeader);
		UserVO user = authService.findByUid(userId); // 또는 getUserByUid(userId)

		return ResponseEntity.ok(Map.of(
									"user_name", user.getUser_name(),
									"nickname", user.getNickname(),
									"email", user.getEmail(),
									"birth_date", user.getBirth_date(),
									"phone_number", user.getPhone_number(),
									"point_balance", user.getPoint_balance(),
									"profile_img", user.getProfile_img()
								));
	}
}