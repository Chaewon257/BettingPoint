package com.bettopia.game.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.verification.VerificationService;

@RestController
@RequestMapping("/api/email")
public class VerificationRestController {

	@Autowired
	private VerificationService verificationService;

	@PostMapping(value = "/request", produces = "text/plain;charset=utf-8")
	public String requestVerification(@RequestBody Map<String, String> request) {
		String email = request.get("email");
		verificationService.requestVerification(email);
		return "인증번호가 이메일로 발송되었습니다.";
	}

	@PostMapping(value = "/verify", produces = "text/plain;charset=utf-8")
	public String verifyCode(@RequestBody Map<String, String> request) {
		String email = request.get("email");
		String code = request.get("code");
		verificationService.verifyCode(email, code);
		return "이메일 인증이 완료되었습니다.";
	}
}