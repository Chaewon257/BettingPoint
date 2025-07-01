package com.bettopia.game.model.auth;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.Map;

@Repository
public class UserDAO {

    @Autowired
    private SqlSession sqlSession;

    String namespace = "com.bpoint.auth.";

    public void updateUser(UserVO userRequest, String userId) {
        UserVO user = UserVO.builder()
                .uid(userId)
                .password(userRequest.getPassword())
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
}
