package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {
	
	@GetMapping("/login")
	public String goLoginPage() {
		return "/auth/login";
	}
	
	@GetMapping("/register")
	public String goRegisterPage() {
		return "/auth/register";
	}
}
