package com.bettopia.game.controller;

import com.bettopia.game.model.game.GameLevelDTO;
import com.bettopia.game.model.game.GameLevelService;
import com.bettopia.game.model.game.GameResponseDTO;
import com.bettopia.game.model.game.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/game")
public class GameRestController {

	@Autowired
	private GameService gameService;

	
	@Autowired
	private GameLevelService gameLevelService;
	
	// 게임 리스트 조회
	@GetMapping("/list")
	public List<GameResponseDTO> selectAll() {
		return gameService.selectAll();
	}

	// 게임 상세 조회
	@GetMapping("/detail/{gameId}")
	public GameResponseDTO selectById(@PathVariable String gameId) {
		return gameService.selectById(gameId);
	}

	// 타입별 게임 조회
	@GetMapping("/list/{type}")
	public List<GameResponseDTO> selectByType(@PathVariable String type) {
		return gameService.selectByType(type);
	}

	// 이름으로 게임 조회
	@GetMapping("/by-name/{name}")
	public List<GameResponseDTO> selectByName(@PathVariable String name) {
		return gameService.selectByName(name);
	}
	
	@GetMapping("/levels/by-game/{uid}")
	public List<GameLevelDTO> selectLevelsByGame(@PathVariable String uid) {
	    return gameLevelService.selectByGameUid(uid);
	}

}
