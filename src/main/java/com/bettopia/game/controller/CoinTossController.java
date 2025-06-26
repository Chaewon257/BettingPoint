package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequestMapping("/solo")
public class CoinTossController {

	@PostMapping("/cointoss")
	public String renderCointossPage(@RequestParam String gameId, Model model) {
	    model.addAttribute("gameUid", gameId);
	    return "game/cointoss";
	}
}
