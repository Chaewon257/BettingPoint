package com.bettopia.game.controller;

import com.bettopia.game.model.gameroom.GameRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/gameroom")
public class GameRoomController {
    @Autowired
    private GameRoomService gameRoomService;

    @GetMapping
    public String gameroom(@RequestParam(defaultValue = "1") int page, Model model) {
        int size = 6;
        int totalCount = gameRoomService.selectAll().size();
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", page);

        return "gameroom/gameroomlist";
    }

    @GetMapping("/detail/{roomId}")
    public String gameroomDetail(@PathVariable String roomId, Model model) {
        model.addAttribute("roomId", roomId);
        return "gameroom/turtleroomdetail";
    }

    @GetMapping("/insert")
    public String gameroomInsert() {
        return "gameroom/gameinsert";
    }
}
