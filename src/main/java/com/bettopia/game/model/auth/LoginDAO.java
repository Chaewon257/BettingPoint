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
	
	public void updateRefreshToken(String uid, String refreshToken) {
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("uid", UUID.randomUUID().toString().replace("-", ""));
		param.put("userUid", uid);
		param.put("refreshToken", refreshToken);
		sqlSession.update(NAMESPACE + "updateRefreshToken", param);
	}

	public void updateLastLoginAt(String uid) {
		sqlSession.selectOne(NAMESPACE + "updateLastLoginAt", uid);		
	}

	public UserVO findByUid(String uid) {
		return sqlSession.selectOne(NAMESPACE + "findByUid", uid);
	}
}
