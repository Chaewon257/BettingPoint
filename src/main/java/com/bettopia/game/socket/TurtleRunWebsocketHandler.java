package com.bettopia.game.socket;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.model.gameroom.GameRoomDAO;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;
import com.bettopia.game.model.multi.turtle.PlayerDAO;
import com.bettopia.game.model.multi.turtle.TurtlePlayerDTO;
import com.bettopia.game.model.multi.turtle.TurtleRunResultDTO;
//import com.bettopia.game.model.multi.turtle.TurtleRunService;
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

// 전체 메시지 처리
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
//    @Autowired
//    private TurtleRunService turtleRunService; 

 // [1] 각 방별 최신 positions 저장 맵
    private final Map<String, List<Double>> latestPositions = new ConcurrentHashMap<>();
    // [2] 각 방별 브로드캐스트 스케줄 타이머
    private final Map<String, ScheduledFuture<?>> broadcastTasks = new ConcurrentHashMap<>();
    // [3] 타이머 실행 서비스
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(4);

    @Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// 연결된 세션 저장, 초기 데이터 전송 등
		String userId = (String) session.getAttributes().get("userId");
		String roomId = (String) session.getAttributes().get("roomId");

		if(roomId == null || userId == null) {
			session.close(CloseStatus.BAD_DATA);
			return;
		}

		// 플레이어 리스트 조회
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		if(players != null) {
			// 중복 입장 확인
			for(TurtlePlayerDTO player : players) {
				if(player.getUser_uid().equals(userId)) {
					session.close(CloseStatus.BAD_DATA);
					return;
				}
			}
			// 최대 인원 초과 확인
			if(players.size() >= 8) {
				session.close(CloseStatus.BAD_DATA);
				return;
			}

			// 배팅 포인트 확인
			// 최소 배팅 포인트 만큼 입장 제한
			UserVO user = authService.findByUid(userId);
			GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
			if(user.getPoint_balance() < gameroom.getMin_bet()) {
				session.close(CloseStatus.BAD_DATA);
				return;
			}
		}

		// 세션 등록
		sessionService.addSession(roomId, session);

		// 플레이어 추가
		TurtlePlayerDTO player = TurtlePlayerDTO.builder()
			.user_uid(userId)
			.room_uid(roomId)
			.isReady(false)
			.turtle_id("1")
			.betting_point(0)
			.build();

		playerDAO.addPlayer(roomId, player);

		// 입장 메시지 브로드캐스트
		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("enter", roomId, data);
	}

	private void broadcastMessage(String type, String roomId) throws IOException {
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		if (sessions == null || sessions.isEmpty()) {
			// 더 이상 메시지 보낼 세션이 없음
			return;
		}
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> messageMap = new HashMap<>();
		messageMap.put("type", "race_update");
		
		String jsonMessage = mapper.writeValueAsString(messageMap);
		
		for (WebSocketSession session : sessions) {
			if (session.isOpen()) {
				session.sendMessage(new TextMessage(jsonMessage));
			}
		}
	}
	
	private void broadcastMessage(String type, String roomId, Map<String, Object> data) throws IOException {
		// 전체 메시지 전송
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		if (sessions == null || sessions.isEmpty()) {
			// 더 이상 메시지 보낼 세션이 없음
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
		// 클라이언트가 보낸 메시지를 받아서 처리 (예: 선택, 입장, 배팅 등)

		// 메시지 파싱
		String payload = message.getPayload();
		ObjectMapper mapper = new ObjectMapper();
		JsonNode json = mapper.readTree(payload);

		String type = json.get("type").asText();

		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");

		TurtlePlayerDTO player = playerDAO.getPlayer(roomId, userId);

		// 메시지 타입에 따라 분기
		switch(type) {
			case "choice":
				String turtleId = json.get("turtle_id").asText();
				player.setTurtle_id(turtleId);
				break;
			case "betting":
				int bettingPoint = json.get("betting_point").asInt();
				player.setBetting_point(bettingPoint);
				break;
			case "ready":
				Boolean isReady = json.get("isReady").asBoolean();
				player.setReady(isReady);
				break;
			case "race_update":
                // [1] positions 정보 저장
                List<Double> positions = new ArrayList<>();
                JsonNode posNode = json.get("positions");
                if (posNode != null && posNode.isArray()) {
                    for (JsonNode pos : posNode) {
                        positions.add(pos.asDouble());
                    }
                }
                latestPositions.put(roomId, positions);
                // [2] 해당 방에 이미 타이머가 없으면, 0.1초마다 broadcast하는 타이머 등록
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
				
				 // 1. 결과 저장 (Service 호출)
//			    turtleRunService.processGameResult(dto);

			    // 2. 결과 메시지 생성 (모달에 보여줄 정보 등)
			    Map<String, Object> resultMsg = new HashMap<>();
			    resultMsg.put("type", "race_result");
			    resultMsg.put("winner", dto.getWinner());
			    resultMsg.put("points", dto.getPoints());
			    resultMsg.put("pointsChange", dto.getPointChange());
			    resultMsg.put("bet", dto.getBet());
			    resultMsg.put("userId", dto.getUser_uid());
			    resultMsg.put("roomId", dto.getRoomId());

			    // 3. 방 전체에 결과 broadcast
			    broadcastMessage("race_result", roomId, resultMsg);
				break;
		}

		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		Map<String, Object> data = new HashMap<>();
		data.put("players", players);
		broadcastMessage("update", roomId, data);
	}

	 // [3] positions를 전체 참가자에게 broadcast하는 함수
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
		
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
		if (players == null || players.isEmpty()) { // 플레이어가 없을 때 소켓 메시지 발송 중단
	        ScheduledFuture<?> task = broadcastTasks.remove(roomId);
	        if (task != null) task.cancel(true);
	        latestPositions.remove(roomId);
	    }
		// 플레이어가 0명일 때 방 삭제
		if (players == null || players.isEmpty()) {
			gameroomDAO.deleteRoom(roomId);
		}

		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("exit", roomId, data);
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 혹은 처리
	}
}
