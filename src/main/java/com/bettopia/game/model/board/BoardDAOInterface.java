package com.bettopia.game.model.board;

import java.util.List;

public interface BoardDAOInterface {
    List<BoardDTO> selectAll();       			 //게시글 목록 조회
	void insertBoard(BoardDTO dto); 			//게시글 등록
	BoardDTO getBoardByUid(String uid);  		//게시글 상세 조회
	void updateBoard(BoardDTO board); 			//게시글 수정
	void deleteBoardByUid(String uid);			//게시글 삭제
	
   
	
}