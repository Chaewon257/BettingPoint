package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CoinTossController {

    @GetMapping("/cointoss")
    public String showCoinTossPage() {
        return "game/cointoss"; // = /WEB-INF/views/cointoss.jsp
    }
}