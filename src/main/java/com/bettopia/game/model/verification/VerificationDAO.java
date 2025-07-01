package com.bettopia.game.model.verification;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VerificationDAO {

	@Autowired
	private SqlSession sqlSession;

	String namespace = "com.bpoint.verification.";

	public void saveOrUpdate(VerificationDTO emailVerification) {
		sqlSession.insert(namespace + "insert", emailVerification);
	}

	public VerificationDTO findByEmail(String email) {
		return sqlSession.selectOne(namespace + "findByEmail", email);
	}

	public void markVerified(String email) {
		sqlSession.update(namespace + "markVerified", email);
	}
}
