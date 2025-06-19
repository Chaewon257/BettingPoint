package com.bettopia.game.model.board;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BoardDAOMybatis implements BoardDAOInterface {

	@Autowired
    SqlSession sqlSession;
    private static final String NAMESPACE = "com.bpoint.board.";
    //목록보기
    @Override
    public List<BoardDTO> selectAll() {
        return sqlSession.selectList(NAMESPACE + "selectAll");
    }
    //등록
    @Override
    public void insertBoard(BoardDTO board) {
        sqlSession.insert(NAMESPACE + "insertBoard", board);
    }
    //상세보기
    @Override
    public BoardDTO getBoardByUid(String uid) {
        return sqlSession.selectOne(NAMESPACE +"getBoardByUid", uid);
    }
    //수정
    @Override
    public void updateBoard(BoardDTO board) {
        sqlSession.update(NAMESPACE + "updateBoard", board);
    }
    //삭제
	@Override
    public void deleteBoardByUid(String uid) {
        sqlSession.delete(NAMESPACE + "deleteBoardByUid", uid);
    }

    

    
}

