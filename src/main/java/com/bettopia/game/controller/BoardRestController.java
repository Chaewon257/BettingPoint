package com.bettopia.game.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.BoardRequestDTO.InsertBoardRequestDTO;
import com.bettopia.game.model.board.BoardRequestDTO.UpdateBoardRequestDTO;
import com.bettopia.game.model.board.BoardService;

@RestController
@RequestMapping("/api/board")
public class BoardRestController {

	@Autowired
	private BoardService boardService;
	@Autowired
	private AuthService authService;

	// 게시글 목록 조회, 페이징 (카테고리별)
	@GetMapping("/boardlist")
	public Map<String, Object> list(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "free") String category, @RequestParam(defaultValue = "created_at") String sort) {

		int size = 10; // 한 페이지에 보여줄 게시글 수
		int offset = (page - 1) * size;

		// 카테고리 기준으로 게시글 목록 조회
		List<BoardDTO> boards = boardService.getBoards(offset, size, category, sort);
		int totalCount = boardService.getCountByCategory(category);
		int totalPages = (int) Math.ceil((double) totalCount / size);

		Map<String, Object> response = new HashMap<>();
		response.put("boards", boards);
		response.put("currentPage", page);
		response.put("totalPages", totalPages);
		
		

		return response;
	}

	// 게시글 상세보기 시 조회수 증가
	@GetMapping("/boarddetail/{boardId}")
	public ResponseEntity<BoardDTO> getBoardDetail2(@PathVariable String boardId) {
		boardService.incrementViewCount(boardId); // 조회수 증가
		BoardDTO board = boardService.getBoardByUid(boardId);
		return ResponseEntity.ok(board);
	}

	// 게시글 등록 (로그인한 사용자만 가능)
	@PostMapping("/boardinsert")
	public void insertBoard(@RequestBody InsertBoardRequestDTO dto, @RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);

		boardService.insertBoard(dto, userId);
	}

	// 게시글 수정 (로그인 && 본인 글만 가능)
	@PutMapping("/boardupdate/{boardId}")
	public void updateBoard(@PathVariable String boardId, @RequestBody UpdateBoardRequestDTO dto,
			@RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);

		boardService.updateBoard(boardId, dto, userId);
	}

	// 게시글 삭제 (로그인 && 본인 글만 가능)
	@DeleteMapping("/boarddelete/{boardId}")
	public void deleteBoard(@PathVariable String boardId, @RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);

		boardService.deleteBoard(boardId, userId);
	}

	// 좋아요 버튼 누를 시 호출
	@PostMapping("/like/{boardId}")
	public ResponseEntity<Void> incrementLike(@PathVariable String boardId) {
		boardService.incrementLikeCount(boardId);
		return ResponseEntity.ok().build();
	}

}
