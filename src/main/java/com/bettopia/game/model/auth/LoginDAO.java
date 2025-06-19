package com.bettopia.game.model.auth;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("loginMybatis")
public class LoginDAO {
	@Autowired
	private SqlSession sqlSession;
	private static final String NAMESPACE = "com.bpoint.auth.";
	
	public UserVO findByEmail(String email) {
		return sqlSession.selectOne(NAMESPACE + "findByEmail", email);
	}
}
