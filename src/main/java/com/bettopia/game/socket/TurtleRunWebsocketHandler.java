package com.bettopia.game.socket;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.UserVO;
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

    private final Map<String, List<Double>> latestPositions = new ConcurrentHashMap<>();
    private final Map<String, ScheduledFuture<?>> broadcastTasks = new ConcurrentHashMap<>();
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(4);
    
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		String roomId = (String) session.getAttributes().get("roomId");
		sessionService.addSession(roomId, session);
		}
	
	private void broadcastMessage(String type, String roomId, Map<String, Object> data) throws IOException {
		// 웹소켓 메시지 전송
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		if (sessions == null || sessions.isEmpty()) {
			// 더 이상 메시지 보낼 대상이 없음
			return;
		}

		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> messageMap = new HashMap<>();
		messageMap.put("type", type);
		messageMap.put("players", players);

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
			case "start":
				GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
				List<TurtlePlayerDTO> player = playerDAO.getAll(roomId);
				Map<String, Object> initMsg = new HashMap<>();
	            initMsg.put("type", "init");
	            initMsg.put("roomId", roomId);
	            // ------ 방 정보 ------
	            initMsg.put("difficulty", gameroom.getGame_level_uid());    // ex) "easy", "normal", "hard"
	            initMsg.put("minBet", gameroom.getMin_bet());           // int
	            initMsg.put("roomTitle", gameroom.getTitle());
	            // ------ 플레이어 정보 ------
	            List<Map<String, Object>> playerList = new ArrayList<>();
	            for(TurtlePlayerDTO player : players) {
	                Map<String, Object> playerMap = new HashMap<>();
	                playerMap.put("userId", player.getUser_uid());
	                playerMap.put("turtleId", player.getTurtle_id());
	                playerMap.put("bettingPoint", player.getBetting_point());
	                playerList.add(playerMap);
	            }
	            initMsg.put("players", playerList);
	
	            List<WebSocketSession> sessions = sessionService.getSessions(roomId);
	            String jsonMessage = mapper.writeValueAsString(initMsg);
	            for (WebSocketSession ws : sessions) {
	                if (ws.isOpen()) ws.sendMessage(new TextMessage(jsonMessage));
	            }
	            break;
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
                    }, 0, 100, TimeUnit.MILLISECONDS);
                });
                break;
			case "race_finish":
				TurtleRunResultDTO dto = new TurtleRunResultDTO();
			    dto.setUser_uid(userId);
			    dto.setRoomId(roomId);
			    dto.setWinner(json.get("winner").asInt());
			    dto.setPoints(json.get("points").asInt());
			    dto.setBet(json.get("bet").asInt());
			    dto.setPointChange(json.get("pointChange").asInt());
			    // 1. 게임 기록 저장
			    GameHistoryDTO gameHistory = GameHistoryDTO.builder()
			            .user_uid(dto.getUser_uid())
			            .game_uid(dto.getRoomId())
			            .betting_amount(dto.getBet())
			            .point_value(dto.getPoints())
			            .game_result(dto.getPointChange() > 0 ? "WIN" : "LOSE")
			            .build();
			    GameHistoryDTO savedGameHistory = historyService.insertGameHistory(gameHistory, dto.getUser_uid());
			    // 2. 포인트 기록 저장 (GameHistory UID 연동)
			    PointHistoryDTO pointHistory = PointHistoryDTO.builder()
			            .user_uid(dto.getUser_uid())
			            .gh_uid(savedGameHistory.getUid())
			            .type("GAME")
			            .amount(dto.getPointChange())
			            .balance_after(dto.getPoints()) // 혹은 실제 잔액 계산 결과
			            .build();
			    historyService.insertPointHistory(pointHistory, dto.getUser_uid());
			    // 3. 결과 브로드캐스트 (모달 노출용)
			    Map<String, Object> resultMsg = new HashMap<>();
			    resultMsg.put("type", "race_result");
			    resultMsg.put("winner", dto.getWinner());
			    resultMsg.put("points", dto.getPoints());
			    resultMsg.put("pointsChange", dto.getPointChange());
			    resultMsg.put("bet", dto.getBet());
			    resultMsg.put("userId", dto.getUser_uid());
			    resultMsg.put("roomId", dto.getRoomId());
			    broadcastMessage("race_result", roomId, resultMsg);
			    break;
		}

		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
		Map<String, Object> data = new HashMap<>();
		data.put("players", players);
		broadcastMessage("update", roomId, data);
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
		// 세션 제거, 퇴장 처리 등
		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");

		sessionService.removeSession(roomId, session);
		playerDAO.removePlayer(roomId, userId);

		// 플레이어가 0명일 때 방 삭제
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
		if (players == null || players.isEmpty()) {
			gameroomDAO.deleteRoom(roomId);
			// 스케줄러도 종료
			ScheduledFuture<?> task = broadcastTasks.remove(roomId);
	        if (task != null) task.cancel(true);
	        latestPositions.remove(roomId);
		}
		
		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("exit", roomId, data);
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 또는 복구 처리
	}
}