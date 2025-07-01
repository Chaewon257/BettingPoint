package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {
	private static final int PAGE_SIZE = 10;
	@Autowired
	private BoardService boardService;
	
	@GetMapping("/{category}")
	  public String listByCategory(
	      @PathVariable("category") String category,
	      @RequestParam(defaultValue = "1") int page,
	      @RequestParam(defaultValue = "created_at") String sort,
	      Model model ) {
	 
	    int offset = (page - 1) * PAGE_SIZE;
	    // 서비스에서 카테고리+정렬+페이징 처리된 리스트와 전체 카운트를 리턴
	    List<BoardDTO> boards = boardService.getBoards(offset, PAGE_SIZE, category, sort);
	    int totalCount   = boardService.getCountByCategory(category);
	    int totalPages   = (int)Math.ceil((double)totalCount / PAGE_SIZE);

	    model.addAttribute("boards", boards);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("sort", sort);

	    // /WEB-INF/views/board/free.jsp, info.jsp, idea.jsp 중 하나
	    return "board/" + category;
	  }

	// 게시글 상세보기 페이지로 이동
	@GetMapping("/view/{boardId}")
	public String getBoardDetail(@PathVariable("boardId") String boardId, Model model) {
		model.addAttribute("boardId", boardId);
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
