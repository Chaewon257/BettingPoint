package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/solo")
public class SoloGameController {
		
	@GetMapping("")
	public String soloGameList() {
		return "gameroom/sologamelist";
	}
	
}
