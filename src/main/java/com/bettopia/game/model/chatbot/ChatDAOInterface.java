package com.bettopia.game.model.chatbot;

import java.util.List;

public interface ChatDAOInterface {
	
	// ��ü Q&A ��� 
	public List<ChatQADTO> selectAll();
	
	// uid�� �亯 ��������
	public String questiontByUid(String uid);

	// ī�װ��� ���� ��� ��������
	public List<ChatQADTO> selectByCate(String category); // ���� ���
	
	// ���� �ؽ�Ʈ�� �亯 ��������
	public ChatQADTO selectByQuestion(String uid); // �亯 ���
	
	
	
}
