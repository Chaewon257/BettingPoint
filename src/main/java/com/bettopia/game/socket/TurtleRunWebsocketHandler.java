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
import com.bettopia.game.model.multi.turtle.TurtleRunResultDTO;
import com.bettopia.game.model.multi.turtle.SessionService;
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
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

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

	private final Map<String, List<Double>> latestPositions = new ConcurrentHashMap<>();
	private final Map<String, ScheduledFuture<?>> broadcastTasks = new ConcurrentHashMap<>();
	private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(4);
	private final Map<String, List<TurtlePlayerDTO>> gameStartPlayersMap = new ConcurrentHashMap<>();

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		String roomId = (String) session.getAttributes().get("roomId");
		sessionService.addSession(roomId, session);
		onGameStart(roomId);
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

		for (WebSocketSession session : sessions) {
			if (session.isOpen()) {
				session.sendMessage(new TextMessage(jsonMessage));
			}
		}
	}

	public void onGameStart(String roomId) {
	    // 게임 시작 시점의 참가자 전체 정보 저장
	    List<TurtlePlayerDTO> startPlayers = playerDAO.getAll(roomId);
	    // null 방지
	    if (startPlayers != null) {
	        gameStartPlayersMap.put(roomId, new ArrayList<>(startPlayers));
	    }
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

		// 메시지 타입에 따라 분기
		switch(type) {
			case "race_update":
	            // positions를 받아와 전체 방에 실시간으로 브로드캐스트
	            // 1. positions를 파싱
				List<Double> positions = new ArrayList<>();
                JsonNode posNode = json.get("positions");
                if (posNode != null && posNode.isArray()) {
                    for (JsonNode pos : posNode) {
                        positions.add(pos.asDouble());
                    }
                }
                latestPositions.put(roomId, positions);
	            // 2. 전체 클라이언트에게 positions 전송
                broadcastTasks.computeIfAbsent(roomId, k -> {
                    return scheduler.scheduleAtFixedRate(() -> {
                        try {
                            broadcastRaceUpdate(roomId);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }, 0, 20, TimeUnit.MILLISECONDS);
                });
                break;
			case "race_finish":
			    ScheduledFuture<?> task = broadcastTasks.remove(roomId);
			    if (task != null) task.cancel(true);
			    latestPositions.remove(roomId);

			    TurtleRunResultDTO dto = new TurtleRunResultDTO();
			    dto.setUser_uid(userId);
			    dto.setRoomId(roomId);
			    dto.setWinner(json.get("winner").asInt());
			    dto.setDifficulty(json.get("difficulty").asText());

			    Map<String, Object> finishMsg = new HashMap<>();
			    finishMsg.put("type", "race_finish");
			    finishMsg.put("winner", dto.getWinner());
			    finishMsg.put("roomId", dto.getRoomId());
			    finishMsg.put("difficulty", dto.getDifficulty());			    
			    broadcastMessage("race_finish", roomId, finishMsg);
			    break;
			case "end":
				Map<String, Object> data = new HashMap<>();
				data.put("target",  "/gameroom/detail/" + roomId);
				broadcastMessage("end", roomId, data);
		}
	}
	
	// 방에 위치 정보를 스케쥴러로 보내주는 함수
	private void broadcastRaceUpdate(String roomId) throws IOException {
	    List<Double> positions = latestPositions.get(roomId);
	    if (positions == null) return;

	    Map<String, Object> data = new HashMap<>();
	    data.put("positions", positions);
	    broadcastMessage("race_update", roomId, data);
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	    String roomId = (String) session.getAttributes().get("roomId");
	    String userId = (String) session.getAttributes().get("userId");

	    sessionService.removeSession(roomId, session);

	    GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
	    String gameStatus = gameroom.getStatus();

	    if (!gameStatus.equals("WAITING")) {
	        //  나간사람 즉시 패배처리
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
	                        String gameUid = gameService.selectByName(gameName)
	                            .stream().findFirst()
	                            .orElseThrow(() -> new IllegalStateException("'" + gameName + "' 게임을 찾을 수 없습니다."))
	                            .getUid();
	                        GameHistoryDTO savedGame = historyService.insertGameHistory(
	                            gameUid, gameName, betAmount,
	                            Math.abs(winAmount - betAmount), gameResult, userId
	                        );
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
	        }

	        List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
	        if (userId.equals(gameroom.getHost_uid())) {
	            // 방장 퇴장 시 host 위임 또는 방 삭제
	            playerDAO.removePlayer(roomId, userId);
	            players = playerDAO.getAll(roomId); // 방장 제외하고 재조회

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
	                gameroomDAO.deleteRoom(roomId);
	                gameRoomListWebSocket.broadcastMessage("delete");
	                ScheduledFuture<?> task = broadcastTasks.remove(roomId);
	                if (task != null) task.cancel(true);
	                latestPositions.remove(roomId);
	            }
	        }

	        gameRoomListWebSocket.broadcastMessage("exit");
	    }

	    // 플레이어가 0명일 때 방 삭제
	    List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
	    if (players == null || players.isEmpty()) {
	       gameroomDAO.deleteRoom(roomId);
	       gameRoomListWebSocket.broadcastMessage("delete");
	    }
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 또는 복구 처리
	}
}