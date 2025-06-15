package com.bettopia.game.model.chatbot;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("chatDAO")
public class ChatDAOMybatis implements ChatDAOInterface {
	
	@Autowired
	SqlSession sqlSession;
	String namespace = "com.bpoint.chat.";
	
	@Override
	public List<ChatQADTO> selectAll() {
		List<ChatQADTO> chatlist = sqlSession.selectList(namespace + "selectAll");
		System.out.println(chatlist!=null?chatlist.toString():"" + "Á¶È¸µÊ(Mybatis)");
		return chatlist;
	}

	@Override
	public ChatQADTO selectByQuestion(String uid) {
		// TODO Auto-generated method stub 
		return null;
	}

	@Override
	public ChatQADTO selectByCate(String category) {
		// TODO Auto-generated method stub
		return null;
	}

}
