package com.bettopia.game.model.board;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface BoardDAOInterface {
	// 카테고리별 글 목록 조회, 페이징
	List<BoardDTO> getBoardsByCategory(@Param("offset") int offset, @Param("limit") int limit,
			@Param("category") String category);

	int getTotalBoardCount(@Param("category") String category); // 카테고리별 글 개수 조회

	void insertBoard(BoardDTO dto); // 게시글 등록

	BoardDTO getBoardByUid(String uid); // 게시글 상세 조회

	void updateBoard(BoardDTO board); // 게시글 수정

	void deleteBoardByUid(String uid); // 게시글 삭제

}