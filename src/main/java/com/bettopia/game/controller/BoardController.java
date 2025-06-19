package com.bettopia.game.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/board")
public class BoardController {

    // 게시글 목록 페이지로 이동
    @GetMapping("/list")
    public String showBoardListPage() {
        return "board/boardList";
    }

    // 게시글 작성 페이지로 이동
    @GetMapping("/insert")
    public String showBoardInsertPage() {
        return "board/boardInsert";  
    }

    // 게시글 상세 페이지로 이동
    @GetMapping("/detail")
    public String showBoardDetailPage() {
        return "board/boardDetail";  
    }
}
