package com.bettopia.game.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.bettopia.game.Exception.SessionExpiredException;
import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.aws.S3FileService;
import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.BoardRequestDTO.InsertBoardRequestDTO;
import com.bettopia.game.model.board.BoardRequestDTO.UpdateBoardRequestDTO;
import com.bettopia.game.model.board.BoardResponseDTO;
import com.bettopia.game.model.board.BoardService;

@RestController
@RequestMapping("/api/board")
public class BoardRestController {

	@Autowired
	private BoardService boardService;
	@Autowired
	private AuthService authService;
	@Autowired
	private S3FileService s3FileService;
	
	private static final int PAGE_SIZE = 10;
	// 게시글 리스트 조회, 페이징 (카테고리별)
	@GetMapping("/boardlist")
	public BoardResponseDTO list(@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "free") String category,
			@RequestParam(defaultValue = "created_at") String sort) {

		int offset     = (page - 1) * PAGE_SIZE;
        List<BoardDTO> boards      = boardService.getBoards(offset, PAGE_SIZE, category, sort);
        long totalCount            = boardService.getCountByCategory(category);
        int totalPages             = (int)Math.ceil((double) totalCount / PAGE_SIZE);

        return BoardResponseDTO.builder()
            .boards(boards)
            .currentPage(page)
            .pageSize(PAGE_SIZE)
            .totalCount(totalCount)
            .totalPages(totalPages)
            .category(category)
            .build();
	}

	// 게시글 상세보기 시 조회수 증가
	@GetMapping("/boarddetail/{boardId}")
	public BoardDTO getBoardDetail2(@PathVariable String boardId,
			@RequestHeader(value = "Authorization", required = false) String authHeader) {

		// 조회수 증가
		boardService.incrementViewCount(boardId);

		// 게시글 조회
		BoardDTO board = boardService.getBoardByUid(boardId);

		// 로그인 사용자라면 작성자 여부 확인
		if (authHeader != null && authHeader.startsWith("Bearer ")) {
			try {
				String userId = authService.validateAndGetUserId(authHeader);
				board.setOner(userId.equals(board.getUser_uid()));
			} catch (SessionExpiredException e) {
				// 토큰 만료 등 예외 발생 시에도 비로그인 상태로 간주
				board.setOner(false);
			}
		} else {
			// 비로그인 사용자
			board.setOner(false);
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

	// summernote 이미지 업로드 (S3 연동)
	@PostMapping(value = "/image-upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
	@ResponseBody
	public Map<String, Object> uploadImage(@RequestPart("image") MultipartFile file) {
		Map<String, Object> response = new HashMap<>();

		try {
			String imageUrl = s3FileService.uploadFile(file); // URL을 바로 받음

			response.put("url", imageUrl);
			response.put("success", 1);
			response.put("message", "업로드 성공");
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", 0);
			response.put("message", "업로드 실패");
		}

		return response;
	}
	
	// summernote에서 이미지 삭제시 
	@DeleteMapping("/image-delete")
	public String deleteImage(@RequestBody Map<String,String> body) {
	    s3FileService.deleteFileByUrl(body.get("url"));
	    return "이미지 삭제가 처리되었습니다.";
	}
}


	
	


