package com.bettopia.game.model.chatlog;

import java.util.List;

public interface ChatLogDAOInterface {
	
	List<ChatLogDTO> selectByUser(String user_uid);
	
	ChatLogDTO selectByUid(String uid);
	
    int insertChatLog(ChatLogDTO chatlog);
    
    int deleteLog(String uid);
}
