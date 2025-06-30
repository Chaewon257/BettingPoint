package com.bettopia.game.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import com.bettopia.game.model.game.GameResponseDTO;
import com.bettopia.game.model.game.GameService;


@Controller
@RequestMapping("/solo")
public class SoloGameController {
		
	@GetMapping("")
	public String soloGameList() {
		return "gameroom/sologamelist";
	}
	
}
