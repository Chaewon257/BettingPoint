package com.bettopia.game.model.game;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameLevelService {
	
	@Autowired
	private GameLevelDAO gameLevelDAO;
	
	public List<GameLevelDTO> selectByGameUid(String gameUid){
		return gameLevelDAO.selectByGameUid(gameUid);
	}
}
