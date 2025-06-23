package com.bettopia.game.model.chatbot;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class ChatQAService {
	
	@Autowired
	@Qualifier("chatDAO")
	ChatDAOMybatis chatDAO;
	
	public List<ChatQADTO> selectAll() {
		return chatDAO.selectAll();
	}

	public String questiontByUid(String uid) {
		return chatDAO.questiontByUid(uid);
	}
	
	public List<ChatQADTO> selectByCate(String main_category) {
		return chatDAO.selectByCate(main_category);
	}
}
