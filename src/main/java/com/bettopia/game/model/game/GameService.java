package com.bettopia.game.model.game;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameService {

    @Autowired
    private GameDAO gameDAO;

    // 寃뚯엫 由ъ뒪�듃 議고쉶
    public List<GameResponseDTO> selectAll() {
        return gameDAO.selectAll();
    }

    // ���엯蹂� 寃뚯엫 議고쉶
    public List<GameResponseDTO> selectByType(String type) {
        return gameDAO.selectByType(type);
    }

    // 寃뚯엫 �긽�꽭 議고쉶
    public GameResponseDTO selectById(String gameId) {
        return gameDAO.selectById(gameId);
    }
    
    // 寃뚯엫 �씠由꾩쑝濡� 議고쉶

	  public List<GameResponseDTO> selectByName(String name) { 
		  return gameDAO.selectByName(name);
	  }
}
	 

