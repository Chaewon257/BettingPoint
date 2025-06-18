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

    @Override
    public List<BoardResponseDTO> selectAll() {
        return sqlSession.selectList(NAMESPACE + "selectAll");
    }
    
    @Override
    public void insertBoard(BoardResponseDTO board) {
        sqlSession.insert(NAMESPACE + "insertBoard", board);
    }
    
    @Override
    public BoardResponseDTO getBoardByUid(String uid) {
        return sqlSession.selectOne("board.getBoardByUid", uid);
    }
    
    

    

    
}

