package com.bettopia.game.model.chatlog;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("chatlogDAO")
public class ChatLogDAOMybatis implements ChatLogDAOInterface {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.chatlog.";
	
	@Override
	public List<ChatLogDTO> selectByUser(String user_uid) {
		List<ChatLogDTO> chatlogList = sqlSession.selectList(namespace + "selectByUser", user_uid);
        return chatlogList;
	}
	
	@Override
	public ChatLogDTO selectByUid(String uid) {
		ChatLogDTO chatlog = sqlSession.selectOne(namespace + "selectByUid", uid);
        return chatlog;
	}
	
	@Override
	public int insertChatLog(ChatLogDTO chatlog) {
		int result = sqlSession.insert(namespace + "insertChatLog", chatlog);
        return result;
	}
	
	@Override
	public int deleteLog(String uid) {
		int result = sqlSession.delete(namespace + "deleteChatlog", uid);
        return result;
	}

}
