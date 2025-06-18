package com.bettopia.game.model.board;

import java.util.List;

import com.bettopia.game.model.board.BoardResponseDTO.BoardDTO;

public interface BoardDAOInterface {
    List<BoardResponseDTO> selectAll();        //게시글 목록 조회
	void insertBoard(BoardDTO dto); 			//게시글 등록
	BoardResponseDTO getBoardByUid(String uid);  //게시글 상세 조회
	void updateBoard(BoardDTO board); 			//게시글 수정
	void deleteBoard(String uid);  				//게시글 삭제
   
	
}