package com.bettopia.game.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.io.File; 

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.UserVO;
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

	// 게시글 리스트 조회, 페이징 (카테고리별)
	@GetMapping("/boardlist")
	public List<BoardDTO> list(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "free") String category, @RequestParam(defaultValue = "created_at") String sort) {

		int size = 10; // 한 페이지에 보여줄 게시글 수
		int offset = (page - 1) * size;

		// 카테고리 기준으로 게시글 목록 조회
		List<BoardDTO> boards = boardService.getBoards(offset, size, category, sort);
		
		return boards;
	}

	// 게시글 상세보기 시 조회수 증가
	@GetMapping("/boarddetail/{boardId}")
	public BoardDTO getBoardDetail2(@PathVariable String boardId, @RequestHeader("Authorization") String authHeader) {
		boardService.incrementViewCount(boardId); // 조회수 증가
		BoardDTO board = boardService.getBoardByUid(boardId);
		
		String userId = authService.validateAndGetUserId(authHeader);
		if(!userId.equals(board.getUser_uid())) {
			board.setOner(false);
		}else {
			board.setOner(true);
		}
		
		return board;
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
	
	//summernote 이미지 업로드
	@PostMapping(value = "/image-upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestPart("image") MultipartFile file, HttpServletRequest request) {
	    Map<String, Object> response = new HashMap<>();

	    try {
	        // 실행 중인 톰캣의 실제 경로에 저장해야 브라우저 접근 가능
	        String uploadDir = request.getServletContext().getRealPath("/resources/upload/");
	        File dir = new File(uploadDir);
	        if (!dir.exists()) dir.mkdirs();

	        String originalFilename = file.getOriginalFilename();
	        String filename = UUID.randomUUID() + "_" + originalFilename;
	        File dest = new File(uploadDir + File.separator + filename);
	        file.transferTo(dest);

	        String imageUrl = "/resources/upload/" + filename;
	        response.put("url", imageUrl);
	    } catch (IOException e) {
	        e.printStackTrace();
	        response.put("error", "이미지 업로드 실패");
	    }

	    return response;
	}

}
