package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SupportController {
	@GetMapping("/support")
	public String goLoginPage() {
		return "/support/index";
	}
}
