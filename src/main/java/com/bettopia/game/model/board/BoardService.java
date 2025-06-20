package com.bettopia.game.model.board;

import java.util.List;
import java.util.UUID;

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

	// 게시글 수정
	public void updateBoard(String uid, UpdateBoardRequestDTO dto, String user_uid) {
		// user_uid와 게시글 작성자가 같은지 확인
		BoardDTO board = BoardDTO.builder().uid(uid).title(dto.getTitle()).content(dto.getContent())
				.category(dto.getCategory()).user_uid(user_uid) // 수정 방어코드
				.build();
		boardDAO.updateBoard(board);
	}

	// 게시글 삭제
	public void deleteBoard(String boardId, String user_uid) {
		// user_uid와 게시글 작성자가 같은지 확인 
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
