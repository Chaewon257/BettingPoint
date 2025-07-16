package com.bettopia.game.model.chatlog;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	public List<ChatLogDTO> selectByUser(String user_uid, int offset, int size) {
		Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("size", size);
        params.put("user_uid", user_uid);
		List<ChatLogDTO> chatlogList = sqlSession.selectList(namespace + "chatLogWithPaging", params);
		return chatlogList;
	}
	
	public int countChatLog(String user_uid) {
		return sqlSession.selectOne(namespace + "countChatLog", user_uid);
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
