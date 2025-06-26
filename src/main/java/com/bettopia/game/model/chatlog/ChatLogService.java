package com.bettopia.game.model.chatlog;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class ChatLogService {

	@Autowired
	@Qualifier("chatlogDAO")
	ChatLogDAOMybatis chatLogDAO;
	
	public List<ChatLogDTO> selectByUser(String user_uid) {
		return chatLogDAO.selectByUser(user_uid);
	}
	
	public ChatLogDTO selectByUid(String uid) {
		return chatLogDAO.selectByUid(uid);
	}
	
	public int insertChatLog(ChatLogDTO chatlog) {
		return chatLogDAO.insertChatLog(chatlog);
	}
	
	public int deleteLog(String uid) {
		return chatLogDAO.deleteLog(uid);
	}
	
}
