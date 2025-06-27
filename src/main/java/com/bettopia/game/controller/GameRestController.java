package com.bettopia.game.controller;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.LoginDAO;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.model.game.GameLevelDTO;
import com.bettopia.game.model.game.GameLevelService;
import com.bettopia.game.model.game.GameResponseDTO;
import com.bettopia.game.model.game.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;


@RestController
@RequestMapping("/api/game")
public class GameRestController {

	@Autowired
	private GameService gameService;

	@Autowired
	private GameLevelService gameLevelService;
	
	
	@Autowired
	private AuthService authService;
	
	@Autowired
	private LoginDAO loginDAO;
	
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
	@GetMapping("/list/type")
	public List<GameResponseDTO> selectByType(@RequestParam String type) {
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
	
	@PostMapping("/start")
	public ResponseEntity<?> startGame(@RequestHeader("Authorization") String authHeader,
	                                   @RequestBody Map<String, Object> requestBody) {
		
		System.out.println("🔥 받은 요청 바디: " + requestBody);

	    // 토큰에서 uid 꺼냄
	    String uid = authService.validateAndGetUserId(authHeader);

	    // uid로 유저 조회
	    UserVO user = loginDAO.findByUid(uid);
	    if (user == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                             .body(Map.of("message", "유저를 찾을 수 없습니다."));
	    }

	    // JSON에서 betAmount 추출
	    int betAmount = Integer.parseInt(requestBody.get("betAmount").toString());

	    // 포인트 차감
	    user.setPoint_balance(user.getPoint_balance() - betAmount);
	    loginDAO.updateUserPoint(user);

	    return ResponseEntity.ok(Map.of("newBalance", user.getPoint_balance()));
	}

	// 게임 난이도 상세 조회
	@GetMapping("/level/{levelId}")
	public GameLevelDTO selectLevelByRoom(@PathVariable String levelId) {
		return gameLevelService.selectByRoomUid(levelId);
	}
}
