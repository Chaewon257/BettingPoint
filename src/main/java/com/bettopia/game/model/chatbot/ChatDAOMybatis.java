package com.bettopia.game.model.chatbot;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("chatDAO")
public class ChatDAOMybatis implements ChatDAOInterface {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.chat.";
	
	@Override // 모든 질문 조회
	public List<ChatQADTO> selectAll() {
		List<ChatQADTO> chatlist = sqlSession.selectList(namespace + "selectAll");
		return chatlist;
	}
	
	@Override // 메인 카테고리에 딸린 하위 카테고리 조회 
	public List<String> subCatesByMainCate(String main_category) {
		List<String> subCategories = sqlSession.selectList(namespace + "subCatesByMainCate", main_category);
		return subCategories;
	}
		
	@Override // 메인 & 서브 카테고리로 질문 목록 가져오기
	public List<ChatQADTO> selectByMainSubCate(String main_category, String sub_category) {
		Map<String, String> cateMap = new HashMap<>();
		cateMap.put("main_category", main_category);
		cateMap.put("sub_category", sub_category);
		List<ChatQADTO> qlist = sqlSession.selectList(namespace + "questionsByMainAndSub", cateMap);
		return qlist;
	}
	
	@Override // 질문 uid로 답변 가져오기
	public String answerByUid(String uid) {
		String answerText = sqlSession.selectOne(namespace + "answerByUid", uid);
		return answerText;
	}
	
	@Override // 메인 카테고리에 딸린 모든 질문 조회 
	public List<ChatQADTO> selectByMainCate(String main_category) {
		List<ChatQADTO> qlist = sqlSession.selectList(namespace + "questiontByMainCate", main_category);
		return qlist;
	}
	

}
