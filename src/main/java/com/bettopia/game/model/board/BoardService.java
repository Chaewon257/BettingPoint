package com.bettopia.game.model.board;

import java.util.List;
import java.util.UUID;

import com.bettopia.game.Exception.UserNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bettopia.game.model.board.BoardRequestDTO.InsertBoardRequestDTO;
import com.bettopia.game.model.board.BoardRequestDTO.UpdateBoardRequestDTO;

@Service
public class BoardService {

	@Autowired
	private BoardDAOInterface boardDAO;

	// 게시글 리스트 조회, 페이징 (카테고리별)
	public List<BoardDTO> getBoards(int offset, int limit, String category, String sort) {
		return boardDAO.getBoards(offset, limit, category, sort);
	}

	public int getCountByCategory(String category) {
		return boardDAO.getTotalBoardCount(category);
	}

	// 게시글 등록
	public void insertBoard(InsertBoardRequestDTO dto, String user_uid) {
		// UUID 생성
		String uid = UUID.randomUUID().toString().replace("-", "");

		BoardDTO board = BoardDTO.builder().uid(uid).title(dto.getTitle()).content(dto.getContent())
				.category(dto.getCategory()).board_img(dto.getBoard_img()).user_uid(user_uid).build();
		boardDAO.insertBoard(board);
	}

	// 게시글 상세 조회
	public BoardDTO getBoardByUid(String uid) {
		return boardDAO.getBoardByUid(uid);
	}

	// 게시글 수정 - 로그인한 본인만 수정 가능
	public void updateBoard(String uid, UpdateBoardRequestDTO dto, String user_uid) {
	    // 1. 기존 게시글 조회
	    BoardDTO existing = boardDAO.getBoardByUid(uid);
	    if (existing == null) {
	        throw new RuntimeException("게시글이 존재하지 않습니다.");
	    }
	    // 2. 작성자 검증
	    if (!existing.getUser_uid().equals(user_uid)) {
	        throw new UserNotFoundException();
	    }
	    // 3. 수정할 내용으로 객체 생성
	    BoardDTO board = BoardDTO.builder()
	        .uid(uid)
	        .title(dto.getTitle())
	        .content(dto.getContent())
	        .category(dto.getCategory())
	        .user_uid(user_uid) // 그대로 유지
	        .build();
	    // 4. DB 수정
	    boardDAO.updateBoard(board);
	}

	// 게시글 삭제 - 로그인한 본인만 삭제 가능
	public void deleteBoard(String boardId, String user_uid) {
	    // 1. 기존 게시글 조회
	    BoardDTO existing = boardDAO.getBoardByUid(boardId);
	    if (existing == null) {
	        throw new RuntimeException("게시글이 존재하지 않습니다.");
	    }
	    // 2. 작성자 검증
	    if (!existing.getUser_uid().equals(user_uid)) {
	        throw new UserNotFoundException();
	    }
	    // 3. DB 삭제
	    boardDAO.deleteBoardByUid(boardId);
	}

	// 조회수
	public void incrementViewCount(String boardId) {
		boardDAO.incrementViewCount(boardId);
	}

	// 좋아요 수
	public void incrementLikeCount(String boardId) {
	    boardDAO.incrementLikeCount(boardId);
	}
}
