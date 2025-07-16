package com.bettopia.game.controller;

import java.util.Map;

import com.bettopia.game.Exception.EmailNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.UserUpdateRequestDTO;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.util.JWTUtil;

@RestController
@RequestMapping("/api/user")
public class UserRestController {
	@Autowired
	JWTUtil jwtUtil;

	@Autowired
	private AuthService authService;

	@GetMapping("/me")
	public ResponseEntity<?> getMyInfo(@RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);
		UserVO user = authService.findByUid(userId); // 또는 getUserByUid(userId)

		String baseUrl = "https://bettopia-s3-bucket.s3.ap-northeast-2.amazonaws.com/";
		String profileFullUrl = (user.getProfile_img() != null && !user.getProfile_img().isBlank())
		                        ? baseUrl + user.getProfile_img()
		                        : "";
		
		return ResponseEntity.ok(Map.of(
									"uid", user.getUid(),
									"user_name", user.getUser_name(),
									"nickname", user.getNickname(),
									"email", user.getEmail(),
									"birth_date", user.getBirth_date(),
									"phone_number", user.getPhone_number(),
									"point_balance", user.getPoint_balance(),
									"profile_img", profileFullUrl 
								));
	}

	// 회원정보 수정
	@PostMapping("/update")
	public ResponseEntity<?> updateMyInfo(@ModelAttribute UserUpdateRequestDTO userRequest,
							 			  @RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);
		authService.updateUser(userRequest, userId);
	    return ResponseEntity.ok().build();
	}

	// 포인트 충전
	@PutMapping("/get")
	public void addPoint(@RequestHeader("Authorization") String authHeader,
							@RequestBody Map<String, Integer> request) {
		int point = request.get("point");
		String userId = authService.validateAndGetUserId(authHeader);
		authService.addPoint(point, userId);
	}

	// 포인트 차감
	@PutMapping("/lose")
	public void losePoint(@RequestHeader("Authorization") String authHeader,
								@RequestBody Map<String, Integer> request) {
		int point = request.get("point");
		String userId = authService.validateAndGetUserId(authHeader);
		authService.losePoint(point, userId);
	}

	// 이메일 찾기
	@GetMapping("/findEmail")
	public String findEmail(@RequestParam("user_name") String userName,
		@RequestParam("phone_number") String phoneNumber) {
		String email = authService.getUserEmail(userName, phoneNumber);

		if(email != null) {
			return email;
		} else {
			throw new EmailNotFoundException();
		}
	}
}