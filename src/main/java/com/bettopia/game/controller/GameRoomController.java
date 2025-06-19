package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/gameroom")
public class GameRoomController {
    @GetMapping
    public String gameroom() {
        return "gameroom/gameroomlist";
    }

    @GetMapping("/detail/{roomId}")
    public String gameroomDetail(@PathVariable String roomId, Model model) {
        model.addAttribute("roomId", roomId);
        return "gameroom/gameroomdetail";
    }
}
