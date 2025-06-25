package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/multi")  
public class TurtleRunController {

    @GetMapping("/turtlerun")
    public String showTurtleRunPage() {
        return "game/turtlerun"; // = /WEB-INF/views/game/turtlerun.jsp
    }
}