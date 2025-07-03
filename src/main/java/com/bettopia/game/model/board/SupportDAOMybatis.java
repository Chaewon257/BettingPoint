package com.bettopia.game.model.board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
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

	public List<BoardDTO> selectByCategoryWithPaging(@Param("category") String upperCategory, 
			 										 @Param("offset") int offset, 
			 										 @Param("size") int size) {
		Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("size", size);
        params.put("category", upperCategory);
		return sqlSession.selectList(namespace + "selectByCategoryWithPaging", params);
	}
	
    public int countByCategory(String category) {
    	return sqlSession.selectOne(namespace + "countByCategory", category);
    }
	
}
