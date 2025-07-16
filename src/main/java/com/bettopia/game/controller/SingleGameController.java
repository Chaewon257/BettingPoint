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
public class SingleGameController {
	
	
	@Autowired
	private GameService gameService;
	
	@GetMapping("/CoinToss")
	public String renderCointossPage(Model model) {
	    GameResponseDTO game = gameService.selectByName("CoinToss")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'cointoss' 게임이 존재하지 않습니다."));
	    
	    model.addAttribute("gameUid", game.getUid());
	    return "game/cointoss";
	}
	
	
	@GetMapping("/TreasureHunt")
	public String renderMineSweeperPage(Model model) {
	    GameResponseDTO game = gameService.selectByName("TreasureHunt")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'TreasureHunt' 게임이 존재하지 않습니다."));
	    
	    model.addAttribute("gameUid", game.getUid());
	    return "game/treasurehunt";
	}
}
