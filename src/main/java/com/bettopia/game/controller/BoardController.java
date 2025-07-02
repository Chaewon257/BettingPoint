package com.bettopia.game.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.bettopia.game.model.board.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	
	@GetMapping("/{category}")
    public String listPage(@PathVariable String category) {
        // 단순히 board/{category}.jsp 뷰만 반환
        return "board/" + category;
    }

	// 게시글 상세보기 페이지로 이동
	@GetMapping("/view/{boardId}")
	public String getBoardDetail(@PathVariable("boardId") String boardId, Model model) {
		model.addAttribute("boardId", boardId);
		return "board/view";
	}
	
	// 게시글 상세보기
	@GetMapping("/view")
	public String getBoardDetail() {
		return "board/view";
	}

	// 좋아요
	@PostMapping("/like/{boardId}")
	@ResponseBody
	public String likeBoard(@PathVariable String boardId) {
		boardService.incrementLikeCount(boardId);
		return "success";
	}

	// 게시글 페이지로 이동
	@GetMapping("")
	public String goBoardPage() {
		return "board/index";
	}
	
	// 게시글 작성 페이지로 이동
	@GetMapping("/write")
	public String goBoardWritePage() {
		return "board/write";
	}
	
	// 게시글 수정 페이지로 이동
	@GetMapping("/write/{boardId}")
	public String goBoardUpdatePage(@PathVariable("boardId") String boardId, Model model) {
		model.addAttribute("boardId", boardId);
		return "board/write";
	}
	
	
}
