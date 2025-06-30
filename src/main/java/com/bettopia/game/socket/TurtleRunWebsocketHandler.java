package com.bettopia.game.socket;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.gameroom.GameRoomDAO;
import com.bettopia.game.model.gameroom.GameRoomService;
import com.bettopia.game.model.history.HistoryService;
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
				TurtleRunResultDTO dto = new TurtleRunResultDTO();
			    dto.setUser_uid(userId);
			    dto.setRoomId(roomId);
			    dto.setWinner(json.get("winner").asInt());
			    dto.setUserBet(json.get("userBet").asInt());
			    dto.setPointChange(json.get("pointChange").asInt());
			    
			    // 3. 결과 브로드캐스트 (모달 노출용)
			    Map<String, Object> resultMsg = new HashMap<>();
			    resultMsg.put("type", "race_result");
			    resultMsg.put("winner", dto.getWinner());
			    resultMsg.put("pointChange", dto.getPointChange());
			    resultMsg.put("bet", dto.getUserBet());
			    resultMsg.put("userId", dto.getUser_uid());
			    resultMsg.put("roomId", dto.getRoomId());
			    broadcastMessage("race_result", roomId, resultMsg);
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
	    // 세션 제거, 퇴장 처리 등
	    String roomId = (String) session.getAttributes().get("roomId");
	    String userId = (String) session.getAttributes().get("userId");

	    sessionService.removeSession(roomId, session);

	    String gameStatus = gameRoomService.selectById(roomId).getStatus();
	    if(!gameStatus.equals("WAITING")) {
	       playerDAO.removePlayer(roomId, userId);
	       gameRoomListWebSocket.broadcastMessage("exit");

	       Map<String, Object> data = new HashMap<>();
	       data.put("userId", userId);
	       broadcastMessage("exit", roomId, data);
	    }

	    // 플레이어가 0명일 때 방 삭제
	    List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
	    if (players == null || players.isEmpty()) {
	       gameroomDAO.deleteRoom(roomId);
	       // 스케줄러도 종료
	       ScheduledFuture<?> task = broadcastTasks.remove(roomId);
	        if (task != null) task.cancel(true);
	        latestPositions.remove(roomId);
	    }
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 또는 복구 처리
	}
}