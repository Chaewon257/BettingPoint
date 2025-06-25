package com.bettopia.game.model.game;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("gameLevelMybatis")
public class GameLevelDAO {

    @Autowired
    private SqlSession sqlSession;

    private final String namespace = "com.bpoint.gameLevel."; 

    public List<GameLevelDTO> selectByGameUid(String gameUid) {
        return sqlSession.selectList(namespace + "selectByGameUid", gameUid);
    }

    public GameLevelDTO selectByRoomUid(String levelId) {
        return sqlSession.selectOne(namespace + "selectByRoomUid", levelId);
    }
}