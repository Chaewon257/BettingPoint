package com.bettopia.game.model.chatbot;

import java.util.List;

public interface ChatDAOInterface {
	
	// ��ü Q&A ��� 
	public List<ChatQADTO> selectAll();
	
	// ���� �ؽ�Ʈ�� �亯 ��������
	public ChatQADTO selectByQuestion(String uid); // �亯 ���
	
	// ī�װ��� ���� ��� ��������
	public ChatQADTO selectByCate(String category); // ���� ���
	
	
}
