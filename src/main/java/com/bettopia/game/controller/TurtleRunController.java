package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/multi")  
public class TurtleRunController {

    @GetMapping("/{roomId}/turtlerun")
    public String showTurtleRunPage(@PathVariable String roomId, Model model) {
    	model.addAttribute("roomId", roomId);
        return "game/turtlerun"; // = /WEB-INF/views/game/turtlerun.jsp
    }
    
    // 게임 끝나고 게임방으로 다시 이동
    @GetMapping("/gameroom/detail/{roomId}")
    public String gameroomDetail(@PathVariable String roomId, Model model) {
        model.addAttribute("roomId", roomId);
        return "gameroom/turtleroomdetail";
    }
}