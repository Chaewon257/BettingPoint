package com.bettopia.game.model.board;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class BoardDAOMybatis implements BoardDAOInterface {

    private final SqlSessionTemplate sqlSession;
    private static final String NAMESPACE = "boardMapper.";

    @Autowired
    public BoardDAOMybatis(SqlSessionTemplate sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<BoardDTO> selectAll() {
        return sqlSession.selectList(NAMESPACE + "selectAll");
    }

    
}

