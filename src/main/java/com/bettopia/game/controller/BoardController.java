package com.bettopia.game.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.BoardService;

@RestController
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
    BoardService boardService;

   
    @GetMapping("/list")
    public List<BoardDTO> list() {
        return boardService.getAllBoards();
    }

   
}