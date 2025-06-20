package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	private BoardService boardService;

	// 게시글 목록 페이지로 이동, 페이징 (카테고리별)
	@GetMapping("/list")
	public String list(@RequestParam(defaultValue = "free") String category, @RequestParam(defaultValue = "1") int page,
			Model model) {

		int size = 10;
		int offset = (page - 1) * size;

		int totalCount = boardService.getCountByCategory(category);
		int totalPages = (int) Math.ceil((double) totalCount / size);

		// 카테고리 기준으로 게시글 목록 조회
		List<BoardDTO> boards = boardService.getBoardsByCategory(offset, size, category);

		model.addAttribute("boards", boards);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("category", category);

		return "board/boardList"; // JSP 경로
	}

	// 게시글 상세 페이지로 이동
	@GetMapping("/detail")
	public String getBoardDetail(@RequestParam("uid") String uid, Model model) {

		BoardDTO board = boardService.getBoardByUid(uid);
		model.addAttribute("board", board);
		return "board/boardDetail";
	}

	// 게시글 작성 페이지로 이동
	@GetMapping("/insert")
	public String showBoardInsertPage() {
		return "board/boardInsert";
	}

}
