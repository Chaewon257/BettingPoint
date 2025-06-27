package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.SupportService;

@RestController
@RequestMapping("/api/support")
public class SupportRestController {
	
	@Autowired
	SupportService supportService;
	
	// 카테고리(FAQ, NOTICE)로 리스트 전체 출력하기
	@GetMapping("/list/{category}")
    public List<BoardDTO> getBoardsByCategory(@PathVariable String category) {
        return supportService.selectByCategory(category);
    }

    @GetMapping("/detail/{boardId}")
    public BoardDTO selectById(@PathVariable String boardId) {
        return supportService.selectById(boardId);
    }
    
}
