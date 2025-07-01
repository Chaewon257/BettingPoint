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
public class GameController {
	
	
	@Autowired
	private GameService gameService;
	
	@GetMapping("/cointoss")
	public String renderCointossPage(Model model) {
	    GameResponseDTO game = gameService.selectByName("cointoss")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'cointoss' 게임이 존재하지 않습니다."));
	    
	    model.addAttribute("gameUid", game.getUid());
	    return "game/cointoss";
	}
	
	
	@GetMapping("/minesweeper")
	public String renderMineSweeperPage(Model model) {
	    GameResponseDTO game = gameService.selectByName("minesweeper")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'minesweeper' 게임이 존재하지 않습니다."));
	    
	    model.addAttribute("gameUid", game.getUid());
	    return "game/minesweeper";
	}
}
