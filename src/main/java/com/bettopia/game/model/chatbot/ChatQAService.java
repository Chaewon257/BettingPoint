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
	
	public List<String> subCatesByMainCate(String main_category) {
		return chatDAO.subCatesByMainCate(main_category);
	}
		
	public List<ChatQADTO> selectByMainSubCate(String main_category, String sub_category) {
		return chatDAO.selectByMainSubCate(main_category, sub_category);
	}

	public String answerByUid(String uid) {
		return chatDAO.answerByUid(uid);
	}
	
	public List<ChatQADTO> selectByMainCate(String main_category) {
		return chatDAO.selectByMainCate(main_category);
	}

}
