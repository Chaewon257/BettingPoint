package com.bettopia.game.controller;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.LoginDAO;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.model.game.GameLevelDTO;
import com.bettopia.game.model.game.GameLevelService;
import com.bettopia.game.model.game.GameResponseDTO;
import com.bettopia.game.model.game.GameService;
import com.bettopia.game.model.history.GameHistoryDTO;
import com.bettopia.game.model.history.HistoryService;
import com.bettopia.game.model.history.PointHistoryDTO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;


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
	
	
	@Autowired
	private HistoryService historyService;

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
		
		System.out.println("빠진금액: " + requestBody);

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
		
	//win
	@PostMapping("/stop")
	public ResponseEntity<?> stopGame(@RequestHeader("Authorization") String authHeader,
	                                  @RequestBody Map<String, Object> requestBody) {

	    String uid = authService.validateAndGetUserId(authHeader);
	    UserVO user = loginDAO.findByUid(uid);
	    if (user == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                             .body(Map.of("message", "유저를 찾을 수 없습니다."));
	    }

	    int winAmount = Integer.parseInt(requestBody.get("winAmount").toString());
	    int betAmount = Integer.parseInt(requestBody.get("betAmount").toString());
	    String gameResult = requestBody.get("gameResult").toString();

	    // 포인트 적립
	    user.setPoint_balance(user.getPoint_balance() + winAmount);
	    loginDAO.updateUserPoint(user);

	    // 게임 UID 조회
	    String gameUid = gameService.selectByName("cointoss")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'cointoss' 게임을 찾을 수 없습니다."))
	        .getUid();

	    // 게임 히스토리 저장 (DTO 조립은 서비스 내부)
	    GameHistoryDTO savedGame = historyService.insertGameHistory(
	        gameUid,
	        betAmount,
	        winAmount - betAmount,
	        gameResult,
	        uid
	    );

	    // 포인트 히스토리 저장
	    PointHistoryDTO pointHistory = new PointHistoryDTO();
	    pointHistory.setGh_uid(savedGame.getUid());  // 포인트 내역이 어떤 게임 히스토리에서 발생했는지를 연결해주는 필드
	    pointHistory.setType(gameResult);
	    pointHistory.setAmount(winAmount - betAmount);
	    pointHistory.setBalance_after(user.getPoint_balance());

	    historyService.insertPointHistory(pointHistory, uid);

	    return ResponseEntity.ok(Map.of("newBalance", user.getPoint_balance()));
	}
	
	//lose
	@PostMapping("/lose")
	public ResponseEntity<?> loseGame(@RequestHeader("Authorization") String authHeader,
	                                  @RequestBody Map<String, Object> requestBody) {

	    String uid = authService.validateAndGetUserId(authHeader);
	    UserVO user = loginDAO.findByUid(uid);
	    if (user == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
	                             .body(Map.of("message", "유저를 찾을 수 없습니다."));
	    }

	    int betAmount = Integer.parseInt(requestBody.get("betAmount").toString());
	    String gameResult = requestBody.get("gameResult").toString(); 

	    String gameUid = gameService.selectByName("cointoss")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'cointoss' 게임을 찾을 수 없습니다."))
	        .getUid();

	    // 게임 히스토리 insert (서비스에서 DTO 조립)
	    GameHistoryDTO savedGame = historyService.insertGameHistory(
	        gameUid,
	        betAmount,
	        betAmount, 
	        gameResult,
	        uid
	    );

	    // 포인트 히스토리 insert
	    PointHistoryDTO pointHistory = new PointHistoryDTO();
	    pointHistory.setGh_uid(savedGame.getUid());
	    pointHistory.setType(gameResult);
	    pointHistory.setAmount(betAmount);
	    pointHistory.setBalance_after(user.getPoint_balance()); 

	    historyService.insertPointHistory(pointHistory, uid);

	    return ResponseEntity.ok(Map.of("newBalance", user.getPoint_balance()));
	}
	
	// 게임 난이도 상세 조회
	@GetMapping("/level/{levelId}")
	public GameLevelDTO selectLevelByRoom(@PathVariable String levelId) {
		return gameLevelService.selectByRoomUid(levelId);
	}
}