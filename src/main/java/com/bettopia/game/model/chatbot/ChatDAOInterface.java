package com.bettopia.game.model.chatbot;

import java.util.List;

public interface ChatDAOInterface {
	
	// 전체 Q&A 목록 
	public List<ChatQADTO> selectAll();
	
	// 메인 카테고리에 딸린 서브 카테고리 목록 조회
	public List<String> subCatesByMainCate(String main_category);
	
	// 메인 & 서브 카테고리로 질문 목록 가져오기
	public List<ChatQADTO> selectByMainSubCate(String main_category, String sub_category); // 답변 출력
	
	// uid로 답변 가져오기
	public String answerByUid(String uid);
	
	// 카테고리별 질문 목록 가져오기
	public List<ChatQADTO> selectByMainCate(String main_category); // 질문 출력
		
}
