package com.bettopia.game.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.verification.VerificationService;

@RestController
@RequestMapping("/api/email")
public class VerificationRestController {
	@Autowired
	private AuthService authService;

	@Autowired
	private VerificationService verificationService;

	@PostMapping(value = "/request", produces = "text/plain;charset=utf-8")
	public String requestVerification(@RequestBody Map<String, String> request) {
		String email = request.get("email");
		
		if(!authService.isEmailExists(email)) {
			verificationService.requestVerification(email);
			return "인증번호가 이메일로 발송되었습니다.";
		}
		
		return "이미 가입된 이메일입니다.";
	}

	@PostMapping(value = "/find/request", produces = "text/plain;charset=utf-8")
	public String findVerification(@RequestBody Map<String, String> request) {
		String email = request.get("email");

		if(!authService.isEmailExists(email)) {
			return "해당 이메일이 존재하지 않습니다.";
		} else {
			verificationService.requestVerification(email);
			return "인증번호가 이메일로 발송되었습니다.";
		}
	}

	@PostMapping(value = "/verify", produces = "text/plain;charset=utf-8")
	public String verifyCode(@RequestBody Map<String, String> request) {
		String email = request.get("email");
		String code = request.get("code");
		verificationService.verifyCode(email, code);
		return "이메일 인증이 완료되었습니다.";
	}

	@PostMapping(value = "/password", produces = "text/plain;charset=utf-8")
	public String updatePassword(@RequestBody Map<String, String> request) {
		String email = request.get("email");
		String userId = authService.findByEmail(email).getUid();
		verificationService.updatePassword(email, userId);
		return "임시 비밀번호가 이메일로 발송되었습니다.";
	}
}