package com.bettopia.game.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bettopia.game.model.board.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	private BoardService boardService;

	// 게시글 목록 페이지로 이동, 페이징 (카테고리별)
	@GetMapping("/list")
	public String list(@RequestParam(defaultValue = "free") String category, @RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "created_at") String sort, // 정렬 기준 추가
			Model model) {

		int size = 10;
		int offset = (page - 1) * size;
		int totalCount = boardService.getCountByCategory(category);
		int totalPages = (int) Math.ceil((double) totalCount / size);

		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("category", category);
		model.addAttribute("sort", sort);

		return "board/boardList"; 
	}

	// 게시글 상세 페이지로 이동
	@GetMapping("/detail/{boardId}")
	public String getBoardDetail(@PathVariable("boardId") String boardId, Model model) {
		model.addAttribute("boardId", boardId);
		return "board/boardDetail";
	}

	// 게시글 작성 페이지로 이동
	@GetMapping("/insert")
	public String showBoardInsertPage() {
		return "board/boardInsert";
	}

	// 좋아요
	@PostMapping("/like/{boardId}")
	@ResponseBody
	public String likeBoard(@PathVariable String boardId) {
		boardService.incrementLikeCount(boardId);
		return "success";
	}

	// 게시글 수정 페이지로 이동
	@GetMapping("/update/{boardId}")
	public String showUpdatePage(@PathVariable("boardId") String boardId, Model model) {
	    model.addAttribute("boardId", boardId);
	    return "board/boardUpdate";
	}
}
