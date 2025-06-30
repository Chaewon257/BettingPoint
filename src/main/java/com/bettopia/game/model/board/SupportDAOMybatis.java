package com.bettopia.game.model.board;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("supportDAO")
public class SupportDAOMybatis {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.support.";

    public List<BoardDTO> selectByCategory (String category) {
    	return 	sqlSession.selectList(namespace + "selectByCategory", category);
    }
    
    public BoardDTO selectById(String boardId) {
        return sqlSession.selectOne(namespace + "selectById", boardId);
    }
    
	
}
