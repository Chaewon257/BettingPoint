package com.bettopia.game.socket;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.LoginDAO;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.model.game.GameService;
import com.bettopia.game.model.gameroom.GameRoomDAO;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;
import com.bettopia.game.model.history.GameHistoryDTO;
import com.bettopia.game.model.history.HistoryService;
import com.bettopia.game.model.history.PointHistoryDTO;
import com.bettopia.game.model.multi.turtle.PlayerDAO;
import com.bettopia.game.model.multi.turtle.TurtlePlayerDTO;
import com.bettopia.game.model.multi.turtle.SessionService;
import com.bettopia.game.model.multi.turtle.TurtleGameService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledFuture;

//웹소켓 메시지 처리
@Component
public class TurtleRunWebsocketHandler extends TextWebSocketHandler {

	// 스프링 빈 사용
	@Autowired
	private PlayerDAO playerDAO;
	@Autowired
	private SessionService sessionService;
	@Autowired
	private GameRoomDAO gameroomDAO;
	@Autowired
	private GameRoomService gameRoomService;
	@Autowired
	private AuthService authService;
	@Autowired
	private HistoryService historyService;
	@Autowired
	private GameRoomListWebSocket gameRoomListWebSocket;
	@Autowired
	private GameService gameService;
	@Autowired
	private LoginDAO loginDAO;
	@Autowired
	private TurtleGameService turtleGameService;

	private final Map<String, List<Double>> latestPositions = new ConcurrentHashMap<>();
	private final Map<String, ScheduledFuture<?>> broadcastTasks = new ConcurrentHashMap<>();
	private final Map<String, List<TurtlePlayerDTO>> gameStartPlayersMap = new ConcurrentHashMap<>();
	private final Map<String, Boolean> gameFinishMap = new ConcurrentHashMap<>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");

		sessionService.addSession(roomId, session);
	    // (1) 게임 시작 전이면 검증 건너뛰고, 그냥 세션 등록
	    List<TurtlePlayerDTO> startPlayers = gameStartPlayersMap.get(roomId);
	    if (startPlayers == null) {
	        return;
	    }
	    // (2) 게임 시작 후에는 userId가 freeze 목록에 없으면 강제퇴장
	    boolean inGame = false;
	    for (TurtlePlayerDTO player : startPlayers) {
	        if (player.getUser_uid().equals(userId)) {
	            inGame = true;
	            break;
	        }
	    }
	    if (!inGame) {
	        Map<String, Object> msg = new HashMap<>();
	        msg.put("type", "force_exit");
	        msg.put("reason", "no_player_info");
	        msg.put("targetUrl", "/gameroom");
	        ObjectMapper mapper = new ObjectMapper();
	        String jsonMsg = mapper.writeValueAsString(msg);
	        session.sendMessage(new TextMessage(jsonMsg));
	        try { Thread.sleep(50); } catch (InterruptedException ignored) {}
	        return;
	    }
	}

	private void broadcastMessage(String type, String roomId, Map<String, Object> data) throws IOException {
		// 웹소켓 메시지 전송
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		if (sessions == null || sessions.isEmpty()) {
			// 더 이상 메시지 보낼 대상이 없음
			return;
		}

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> messageMap = new HashMap<>();
		messageMap.put("type", type);

		if (data != null) {
			messageMap.putAll(data);
		}

		String jsonMessage = mapper.writeValueAsString(messageMap);
		
		// 비정상 세션 감지 시 패배처리 하고 게임룸 리스트로 보냄
		List<WebSocketSession> sessionsCopy = new ArrayList<>(sessions);
		for (WebSocketSession session : sessionsCopy) {
		    try {
		    	synchronized(session) {
			        if (session.isOpen()) {
			            session.sendMessage(new TextMessage(jsonMessage));
			        }
		    	}
		    } catch (Exception e) {
		    	// 강제퇴장 메시지 전송 시도
		        try {
		            Map<String, Object> msg = new HashMap<>();
		            msg.put("type", "force_exit");
		            msg.put("reason", "connection_error");
		            msg.put("targetUrl", "/gameroom");
		            String jsonMsg = mapper.writeValueAsString(msg);
		            session.sendMessage(new TextMessage(jsonMsg));
		        } catch (Exception ignored) {}
		        // 세션 목록에서 제거
		        sessionService.removeSession(roomId, session);
		        if(!Boolean.TRUE.equals(gameFinishMap.get(roomId))) {
			        // 유저 아이디가 있으면 패배 처리도 같이!
			        String userId = (String) session.getAttributes().get("userId");
			        if (userId != null) {
			            processUserLose(roomId, userId);
			        }
		        }
		    }
		}
	}

	public void onGameStart(String roomId) throws IOException {
		// 게임 시작 시점의 참가자 전체 정보 저장
		List<TurtlePlayerDTO> startPlayers = playerDAO.getAll(roomId);
		// null 방지
		if (startPlayers != null) {
			gameStartPlayersMap.put(roomId, new ArrayList<>(startPlayers));
		}
		int totalBet = startPlayers.stream().mapToInt(TurtlePlayerDTO :: getBetting_point).sum();
		Map<String, Object> data = new HashMap<>();
		data.put("totalBet", totalBet);
		broadcastMessage("game_start", roomId, data);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// 클라이언트가 보낸 메시지를 받아서 처리 (예: 채팅, 입장, 베팅 등)
		// 메시지 파싱
		String payload = message.getPayload();
		ObjectMapper mapper = new ObjectMapper();
		JsonNode json = mapper.readTree(payload);

		String type = json.get("type").asText();

		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");
		GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
	    String difficulty = gameroom.getLevel();
		// 메시지 타입에 따라 분기
		switch (type) {
		case "game_start":
			int turtleCount = 6;
			switch (difficulty) {
		    case "EASY": turtleCount = 4; break;
		    case "NORMAL": turtleCount = 6; break;
		    case "HARD": turtleCount = 8; break;
		}
			turtleGameService.startGame(roomId, turtleCount, new TurtleGameService.RaceUpdateCallback() {
				@Override
				public void onRaceUpdate(String roomId, double[] positions) {
					try {
						broadcastRaceUpdate(roomId, positions);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
				@Override
				public void onRaceFinish(String roomId, int winner, List<Map<String, Object>> results) {
					try {
						broadcastRaceFinish(roomId, winner, results);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			});
			broadcastMessage("game_start", roomId, null);
            // 방의 host_uid 조회 (DB 또는 room info에서)
            String roomHostUid = gameroom.getHost_uid();
            if (userId.equals(roomHostUid)) {
                onGameStart(roomId); // 참가자 freeze
            }
            break;
		case "end":
			List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
			for (TurtlePlayerDTO player : players) {
				player.setTurtle_id(null);
				player.setReady(false);
				player.setBetting_point(gameroomDAO.selectById(roomId).getMin_bet());
			}
			gameStartPlayersMap.remove(roomId);
			Map<String, Object> data = new HashMap<>();
			data.put("target", "/gameroom/detail/" + roomId);
			broadcastMessage("end", roomId, data);
			break;
		}
	}

	// 방에 위치 정보를 스케쥴러로 보내주는 함수
	private void broadcastRaceUpdate(String roomId, double[] positions) throws IOException {
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		if (sessions == null)
			return;

		Map<String, Object> msg = new HashMap<>();
		msg.put("type", "race_update");
		List<Double> posList = new ArrayList<>();
		for(double p : positions) posList.add(p);
		msg.put("positions", posList);
		broadcastMessage("race_update", roomId, msg);
	}

	private void broadcastRaceFinish(String roomId, int winner, List<Map<String, Object>> results) throws IOException {
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		if(sessions == null) 
			return;
		
		Map<String, Object> msg = new HashMap<>();
		msg.put("type",  "race_finish");
		msg.put("winner", winner);
		msg.put("results",  results);
		broadcastMessage("race_finish", roomId, msg);
		
		// 게임 종료 상태
		gameFinishMap.put(roomId, true);
	}
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");
		sessionService.removeSession(roomId, session);
		
		GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
		String gameStatus = gameroom.getStatus();
		if (!gameStatus.equals("WAITING")) {
			processUserLose(roomId, userId);

			playerDAO.removePlayer(roomId, userId);

			if (userId.equals(gameroom.getHost_uid())) {
				// 방장 퇴장 시 host 위임 또는 방 삭제
				List<TurtlePlayerDTO> players = playerDAO.getAll(roomId); // 방장 제외하고 재조회
			
				if (players != null && !players.isEmpty()) {
					String newHostUid = players.get(0).getUser_uid();
					gameroomDAO.updateHost(roomId, newHostUid);
				
					// host_changed 메시지 브로드캐스트
					Map<String, Object> msg = new HashMap<>();
					msg.put("type", "host_changed");
					msg.put("newHostUid", newHostUid);
					msg.put("positions", latestPositions.get(roomId));
					broadcastMessage("host_changed", roomId, msg);
				} else {
					// 플레이어가 0명일 때 방 삭제
					gameStartPlayersMap.remove(roomId);
					gameFinishMap.remove(roomId);
					gameroomDAO.deleteRoom(roomId);
					gameRoomListWebSocket.broadcastMessage("delete");
					ScheduledFuture<?> task = broadcastTasks.remove(roomId);
					
					if (task != null)
						task.cancel(true);
					latestPositions.remove(roomId);
				}
			}
			gameRoomListWebSocket.broadcastMessage("exit");
		}
	}

	public void processUserLose(String roomId, String userId) {
		// 나간사람  패배처리
		List<TurtlePlayerDTO> startPlayers = gameStartPlayersMap.get(roomId);
		if (startPlayers != null) {
			for (TurtlePlayerDTO player : startPlayers) {
				if (player.getUser_uid().equals(userId)) {
					int betAmount = player.getBetting_point();
					String gameName = "Turtle Run";
					String gameResult = "LOSE";
					int winAmount = 0;
					// 1) 유저 정보 조회
					UserVO user = authService.findByUid(userId);
					if (user != null) {
						user.setPoint_balance(user.getPoint_balance() - betAmount);
						loginDAO.updateUserPoint(user);
						String gameUid = gameService.selectByName(gameName).stream().findFirst()
								.orElseThrow(() -> new IllegalStateException("'" + gameName + "' 게임을 찾을 수 없습니다."))
								.getUid();
						GameHistoryDTO savedGame = historyService.insertGameHistory(gameUid, gameName, betAmount,
								Math.abs(winAmount - betAmount), gameResult, userId);
						PointHistoryDTO pointHistory = new PointHistoryDTO();
						pointHistory.setGh_uid(savedGame.getUid());
						pointHistory.setType(gameResult);
						pointHistory.setAmount(Math.abs(winAmount - betAmount));
						pointHistory.setBalance_after(user.getPoint_balance());
						historyService.insertPointHistory(pointHistory, userId);
					}
					break;
				}
			}
			// 2. startPlayers에서 userId 제거
	        startPlayers.removeIf(p -> p.getUser_uid().equals(userId));
		}
	}
	
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 또는 복구 처리
	}
}