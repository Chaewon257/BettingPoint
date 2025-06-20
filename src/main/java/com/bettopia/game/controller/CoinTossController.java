package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/solo")  
public class CoinTossController {

    @GetMapping("/cointoss")
    public String showCoinTossPage() {
        return "game/cointoss"; // = /WEB-INF/views/game/cointoss.jsp
    }
}