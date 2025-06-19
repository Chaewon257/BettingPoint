package com.bettopia.game.model.game;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameService {

    @Autowired
    private GameDAO gameDAO;

    // 게임 리스트 조회
    public List<GameResponseDTO> selectAll() {
        return gameDAO.selectAll();
    }

    // 타입별 게임 조회
    public List<GameResponseDTO> selectByType(String type) {
        return gameDAO.selectByType(type);
    }

    // 게임 상세 조회
    public GameResponseDTO selectById(String gameId) {
        return gameDAO.selectById(gameId);
    }
}
