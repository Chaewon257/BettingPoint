package com.bettopia.game.model.auth;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
public class UserDAO {

    @Autowired
    private SqlSession sqlSession;

    String namespace = "com.bpoint.auth.";

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public void updateUser(UserVO userRequest, String userId) {
        UserVO user = UserVO.builder()
                .uid(userId)
                .password(passwordEncoder.encode(userRequest.getPassword()))
                .phone_number(userRequest.getPhone_number())
                .nickname(userRequest.getNickname())
                .profile_img(userRequest.getProfile_img())
                .build();
        sqlSession.update(namespace + "update", user);
    }

    public void addPoint(int point, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("point", point);
        params.put("uid", userId);
        sqlSession.update(namespace + "addPoint", params);
    }

    public void losePoint(int point, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("point", point);
        params.put("uid", userId);
        sqlSession.update(namespace + "losePoint", params);
    }

    public void logout(String userId) {
        sqlSession.delete(namespace + "logout", userId);
    }

    public String getUserEmail(String userName, String phoneNumber) {
        Map<String, Object> params = new HashMap<>();
        params.put("user_name", userName);
        params.put("phone_number", phoneNumber);
        return sqlSession.selectOne(namespace + "findEmail", params);
    }

    public void updatePassword(String password, String userId) {
        Map<String, Object> params = new HashMap<>();
        params.put("password", passwordEncoder.encode(password));
        params.put("uid", userId);
        sqlSession.update(namespace + "updatePassword", params);
    }

    public UserVO findByEmail(String email) {
        return sqlSession.selectOne(namespace + "findByEmail", email);
    }
}