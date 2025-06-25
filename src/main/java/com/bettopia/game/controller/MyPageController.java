package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
	@GetMapping("")
	public String goLoginPage() {
		return "/mypage/view";
	}
	
	@GetMapping("/info")
	public String myPageInfo() {
		return "/mypage/info";
	}
	
	@GetMapping("/points")
	public String myPoints() {
		return "/mypage/points";
	}
	
	@GetMapping("/games")
	public String myGames() {
		return "/mypage/games";
	}
	
	@GetMapping("/questions")
	public String myQuestions() {
		return "/mypage/questions";
	}
}
