package com.bettopia.game.model.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class BoardDAOMybatis implements BoardDAOInterface {

	@Autowired
	SqlSession sqlSession;

	private static final String NAMESPACE = "com.bpoint.board.";

	// 게시글 리스트 조회, 페이징 (카테고리별)
	@Override
	public List<BoardDTO> getBoards(int offset, int limit, String category, String sort) {
		Map<String, Object> params = new HashMap<>();
		params.put("offset", offset);
		params.put("limit", limit);
		params.put("category", category);
		params.put("sort", sort);
		

		return sqlSession.selectList(NAMESPACE + "getBoards", params);
	}

	// 카테고리별 게시글 수 조회 (총 페이지 수 계산용)
	@Override
	public int getTotalBoardCount(String category) {
		return sqlSession.selectOne(NAMESPACE + "getTotalBoardCountByCategory", category);
	}

	// 글 등록
	@Override
	public void insertBoard(BoardDTO board) {
		sqlSession.insert(NAMESPACE + "insertBoard", board);
	}

	// 글 상세보기
	@Override
	public BoardDTO getBoardByUid(String uid) {
		return sqlSession.selectOne(NAMESPACE + "getBoardByUid", uid);
	}

	// 글 수정
	@Override
	public void updateBoard(BoardDTO board) {
		sqlSession.update(NAMESPACE + "updateBoard", board);
	}

	// 글 삭제
	@Override
	public void deleteBoardByUid(String uid) {
		sqlSession.delete(NAMESPACE + "deleteBoardByUid", uid);
	}
	
	// 조회수
	@Override
	public void incrementViewCount(String uid) {
	    sqlSession.update(NAMESPACE + "incrementViewCount", uid);
	}
	
	// 좋아요
	@Override
	public void incrementLikeCount(String uid) {
	    sqlSession.update(NAMESPACE + "incrementLikeCount", uid);
	}
	

}
