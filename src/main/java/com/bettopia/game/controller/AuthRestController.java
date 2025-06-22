package com.bettopia.game.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.Exception.AuthException;
import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.LoginRequestDTO;

@RestController
@RequestMapping("/api/auth")
public class AuthRestController {

	@Autowired
	private AuthService authService;

	// 로그인 API
	@PostMapping("/login")
	public ResponseEntity<?> login(@RequestBody LoginRequestDTO loginRequest) {
		try {
			Map<String, String> responseToken = authService.login(loginRequest);
			String accessToken = responseToken.get("accessToken");
			String refreshToken = responseToken.get("refreshToken");

			// HttpOnly 쿠키 생성
			ResponseCookie cookie = ResponseCookie.from("refreshToken", refreshToken)
					.httpOnly(true) 
					.secure(false) // HTTPS 사용하는 경우 true
					.path("/") // 모든 경로에 대해 쿠키 적용
					.maxAge(14 * 24 * 60 * 60) // 14일 (초 단위)
					.sameSite("Strict") // 또는 "Lax" / "None" (크로스 도메인 필요 시)
					.build();

			return ResponseEntity.ok().header("Set-Cookie", cookie.toString()).body(new LoginResponse(accessToken, "로그인 성공"));
		} catch (AuthException error) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error.getMessage());
		}
	}
	
	@GetMapping("/check-email")
  public ResponseEntity<?> checkEmailDuplicate(@RequestParam("email") String email) {
		return ResponseEntity.ok(Map.of("duplicate", false));
	}
	

	// 리프레시 토큰을 통한 액세스 토큰 재발급 API
	@PostMapping("/reissue")
	public ResponseEntity<?> reissue(@RequestHeader("Authorization") String authHeader) {
		try {
			if (authHeader == null || !authHeader.startsWith("Bearer ")) {
				ResponseCookie cookie = ResponseCookie.from("refreshToken", "")
		        .path("/")
		        .httpOnly(true)
		        .maxAge(0) // 삭제
		        .build();
				
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).header("Set-Cookie", cookie.toString()).body("토큰이 없습니다.");
			}

			String refreshToken = authHeader.substring(7);
			String accessToken = authService.reissue(refreshToken);

			return ResponseEntity.status(HttpStatus.OK).body(new LoginResponse(accessToken, "토큰 재발급"));
		} catch (AuthException error) {
			return ResponseEntity.status(401).body(error.getMessage());
		}
	}

	// 응답 DTO
	static class LoginResponse {
		private String accessToken;
		private String message;

		public LoginResponse(String accessToken, String message) {
			this.accessToken = accessToken;
			this.message = message;
		}

		public String getAccessToken() {
			return accessToken;
		}

		public String getMessage() {
			return message;
		}
	}
}
