package com.bettopia.game.model.chatbot;

import java.util.List;

public interface ChatDAOInterface {
	
	// 전체 Q&A 목록 
	public List<ChatQADTO> selectAll();
	
	// uid로 답변 가져오기
	public String questiontByUid(String uid);

	// 카테고리별 질문 목록 가져오기
	public List<ChatQADTO> selectByCate(String category); // 질문 출력
	
	// 질문 텍스트로 답변 가져오기
	public ChatQADTO selectByQuestion(String uid); // 답변 출력
	
	
	
}
