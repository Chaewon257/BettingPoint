package com.bettopia.game.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.BoardRequestDTO.InsertBoardRequestDTO;
import com.bettopia.game.model.board.BoardRequestDTO.UpdateBoardRequestDTO;
import com.bettopia.game.model.board.BoardService;

@RestController
@RequestMapping("/api/board")
public class BoardRestController {

	@Autowired
	private BoardService boardService;

	// 게시글 목록 조회, 페이징 (카테고리별)
	@GetMapping("/boardlist")
	public Map<String, Object> list(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "free") String category) {

		int size = 10; // 한 페이지에 보여줄 게시글 수
		int offset = (page - 1) * size;

		// 카테고리 기준으로 게시글 목록 조회
		List<BoardDTO> boards = boardService.getBoardsByCategory(offset, size, category);
		int totalCount = boardService.getCountByCategory(category);
		int totalPages = (int) Math.ceil((double) totalCount / size);

		Map<String, Object> response = new HashMap<>();
		response.put("boards", boards);
		response.put("currentPage", page);
		response.put("totalPages", totalPages);

		return response;
	}

	// 게시글 상세보기
	@GetMapping("/boarddetail/{boardId}")
	public BoardDTO getBoardDetail(@PathVariable String boardId) {
		return boardService.getBoardByUid(boardId);
	}

	// 게시글 등록 (로그인한 사용자만 가능)
	@PostMapping("/boardinsert")
	public void insertBoard(@RequestBody InsertBoardRequestDTO dto, HttpSession session) {
//        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            throw new RuntimeException("로그인이 필요합니다.");
//        }

//    	String userId = loginUser.getUser_uid();
		String userId = "0";

		boardService.insertBoard(dto, userId);
	}

	// 게시글 수정 (로그인 && 본인 글만 가능)
	@PutMapping("/boardupdate/{boardId}")
	public void updateBoard(@PathVariable String boardId, @RequestBody UpdateBoardRequestDTO dto, HttpSession session) {
//        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            throw new RuntimeException("로그인이 필요합니다.");
//        }
//
//        BoardDTO existingBoard = boardService.getBoardByUid(dto.getUid());
//        if (!loginUser.getUser_uid().equals(existingBoard.getUser_uid())) {
//            throw new RuntimeException("본인만 수정할 수 있습니다.");
//        }
//
//        dto.setUser_uid(loginUser.getUser_uid()); // 방어코드

//    	String userId = loginUser.getUser_uid();
		String userId = "0";
		boardService.updateBoard(boardId, dto, userId);
	}

	// 게시글 삭제 (로그인 && 본인 글만 가능)
	@DeleteMapping("/boarddelete/{boardId}")
	public void deleteBoard(@PathVariable String boardId, HttpSession session) {
//        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            throw new RuntimeException("로그인이 필요합니다.");
//        }
//
//        BoardDTO existingBoard = boardService.getBoardByUid(uid);
//        if (!loginUser.getUser_uid().equals(existingBoard.getUser_uid())) {
//            throw new RuntimeException("본인만 삭제할 수 있습니다.");
//        }
//        
//      String userId = loginUser.getUser_uid();
		String userId = "0";

		boardService.deleteBoard(boardId, userId);
	}

}
