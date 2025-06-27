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
}