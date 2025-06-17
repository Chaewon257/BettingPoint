package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/gameroom")
public class GameRoomController {
    @GetMapping
    public String gameroom() {
        return "gameroom/gamelist";
    }
}
