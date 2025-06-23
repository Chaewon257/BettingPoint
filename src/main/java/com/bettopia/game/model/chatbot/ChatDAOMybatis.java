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
		System.out.println(chatlist!=null?chatlist.toString():"" + "조회됨");
		return chatlist;
	}

	public String questiontByUid(String uid) {
		String answerText = sqlSession.selectOne(namespace + "questiontByUid", uid);
		System.out.println(answerText);
		return answerText;
	}

	@Override
	public List<ChatQADTO> selectByCate(String main_category) {
		List<ChatQADTO> qlist = sqlSession.selectList(namespace + "questiontByMainCate", main_category);
		System.out.println(qlist.toString() + "조회됨");
		return qlist;
	}

	@Override
	public ChatQADTO selectByQuestion(String uid) {
		
		return null;
	}



}
