package com.bettopia.game.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.http.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.LoginDAO;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.model.game.GameService;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;
import com.bettopia.game.model.history.GameHistoryDTO;
import com.bettopia.game.model.history.HistoryService;
import com.bettopia.game.model.history.PointHistoryDTO;

@RestController
@RequestMapping("/api/multi")
public class TurtleRunRestController {

	@Autowired
	private AuthService authService;
	@Autowired
	private GameRoomService gameRoomService;
	@Autowired
	private GameService gameService;
	@Autowired
	private HistoryService historyService;
	@Autowired
	private LoginDAO loginDAO;
	
	// 웹소켓 연결을 위한 정보 받기
	@GetMapping("/gameroom/detail/{roomId}/info")
	public Map<String, Object> getRoomInfo(@PathVariable String roomId, @RequestHeader("Authorization") String authHeader) {
		Map<String, Object> map = new HashMap<>();
		String userId = authService.validateAndGetUserId(authHeader);
		
		map.put("roomId", roomId);
		map.put("userId", userId);
		
		return map;
	}
	
	@PostMapping("/turtleRun/history")
	public ResponseEntity<?> saveTurtleRunHistory(
	        @RequestHeader("Authorization") String authHeader,
	        @RequestBody Map<String, Object> requestBody) {

	    // 1. 인증 및 사용자 조회
	    String uid = authService.validateAndGetUserId(authHeader);
	    UserVO user = loginDAO.findByUid(uid);
	    if (user == null) {
	        return ResponseEntity.status(HttpStatus.SC_UNAUTHORIZED)
	            .body(Map.of("message", "유저를 찾을 수 없습니다."));
	    }

	    // 2. 파라미터 추출
	    int betAmount = Integer.parseInt(requestBody.get("betAmount").toString());
	    int winAmount = Integer.parseInt(requestBody.get("winAmount").toString());
	    String gameResult = requestBody.get("gameResult").toString();
	    
	    

	    // 3. 포인트 적립/차감
	    if ("WIN".equals(gameResult)) {
	        user.setPoint_balance(user.getPoint_balance() + winAmount);
	    } else {
	        // 이미 차감된 상태면 생략, 아니면 아래 라인 활성화
	         user.setPoint_balance(user.getPoint_balance() - betAmount);
	    }
	    loginDAO.updateUserPoint(user);

	    // 4. 게임 UID 조회 (거북이 달리기 게임으로)
	    String gameUid = gameService.selectByName("Turtle Run")
	        .stream()
	        .findFirst()
	        .orElseThrow(() -> new IllegalStateException("'Turtle Run' 게임을 찾을 수 없습니다."))
	        .getUid();

	    // 5. 게임 히스토리 저장 (서비스에서 DTO 조립)
	    GameHistoryDTO savedGame = historyService.insertGameHistory(
	        gameUid,
	        betAmount,
	        winAmount,
	        gameResult,
	        uid
	    );

	    // 6. 포인트 히스토리 저장
	    PointHistoryDTO pointHistory = new PointHistoryDTO();
	    pointHistory.setGh_uid(savedGame.getUid());
	    pointHistory.setType(gameResult);
	    pointHistory.setAmount(winAmount);
	    pointHistory.setBalance_after(user.getPoint_balance());
	    historyService.insertPointHistory(pointHistory, uid);

	    // 추가적으로 selectedTurtle, winner 등의 값은 별도 DB 저장 필요시 추가!

	    return ResponseEntity.ok(Map.of("newBalance", user.getPoint_balance()));
	}

}

