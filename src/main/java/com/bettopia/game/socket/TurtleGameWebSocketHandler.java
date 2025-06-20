package com.bettopia.game.socket;

import com.bettopia.game.model.multi.turtle.PlayerDAO;
import com.bettopia.game.model.multi.turtle.TurtlePlayerDTO;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// 웹소켓 메시지 처리
@Component
public class TurtleGameWebSocketHandler extends TextWebSocketHandler {

	// 스프링 빈 사용
	@Autowired
	private PlayerDAO playerDAO;
	@Autowired
	private SessionService sessionService;

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// 연결된 세션 저장, 초기 데이터 전송 등
		String userId = (String) session.getAttributes().get("loginUser");
		String roomId = (String) session.getAttributes().get("roomId");

		if (roomId == null || userId == null) {
			session.close(CloseStatus.BAD_DATA); // 필수값 없으면 연결 끊기
			return;
		}

		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
		if(players != null) {
			// 동일 유저 중복 입장 불가 처리
			for(TurtlePlayerDTO player : players) {
				if(player.getUser_uid().equals(userId)) {
					session.close(CloseStatus.BAD_DATA);
					return;
				}
			}
		}

		// 인원 초과 시 입장 불가
		if(players.size() >= 8) {
			session.close(CloseStatus.BAD_DATA);
			return;
		}

		sessionService.addSession(roomId, session);

		// 게임방에 플레이어 추가
		TurtlePlayerDTO player = TurtlePlayerDTO.builder()
				.user_uid(userId)
				.room_uid(roomId)
				// 기본값 설정
				.isReady(false)
				.turtle_id("first")
				.betting_point(0)
				.build();

		playerDAO.addPlayer(roomId, player);

		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("enter", roomId, data);
	}

	private void broadcastMessage(String type, String roomId, Map<String, Object> data) throws IOException {
		// 웹소켓 메시지 전송
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

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
		String userId = (String) session.getAttributes().get("loginUser");

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
		}

		Map<String, Object> data = new HashMap<>();
		data.put("player", player);
		broadcastMessage("update", roomId, data);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// 세션 제거, 퇴장 처리 등
		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("loginUser");

		sessionService.removeSession(roomId, session);
		playerDAO.removePlayer(roomId, userId);

		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("exit", roomId, data);
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 또는 복구 처리
	}
}