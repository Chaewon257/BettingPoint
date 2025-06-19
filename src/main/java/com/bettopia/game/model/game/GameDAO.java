package com.bettopia.game.model.game;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("gameMybatis")
public class GameDAO {

    @Autowired
    private SqlSession sqlSession;
    String namespace = "com.bpoint.game.";

    // 게임 리스트 조회
    public List<GameResponseDTO> selectAll() {
        List<GameResponseDTO> gamelist = sqlSession.selectList(namespace + "selectAll");
        return gamelist;
    }

    // 타입별 게임 조회
    public List<GameResponseDTO> selectByType(String type) {
        List<GameResponseDTO> gamelist = sqlSession.selectList(namespace + "selectByType", type);
        return gamelist;
    }

    // 게임 상세 조회
    public GameResponseDTO selectById(String gameId) {
        GameResponseDTO game = sqlSession.selectOne(namespace + "selectById", gameId);
        return game;
    }
}
