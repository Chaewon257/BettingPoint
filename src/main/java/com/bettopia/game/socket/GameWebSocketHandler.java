package com.bettopia.game.socket;

import com.bettopia.game.model.player.PlayerDAO;
import com.bettopia.game.model.player.PlayerDTO;
import com.bettopia.game.model.player.SessionDAO;
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
public class GameWebSocketHandler extends TextWebSocketHandler {

	// 스프링 빈 사용
	@Autowired
	private PlayerDAO playerDAO;
	@Autowired
	private SessionDAO sessionDAO;

//	@Autowired
//	private ServletContext servletContext;
	// 어플리케이션 스코프에서 게임방 플레이어 리스트 가져오기
//	Map<String, List<PlayerDTO>> roomPlayers =
//			(Map<String, List<PlayerDTO>>) servletContext.getAttribute("roomPlayers");

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// 연결된 세션 저장, 초기 데이터 전송 등
		String userId = (String) session.getAttributes().get("loginUser");
		String roomId = (String) session.getAttributes().get("roomId");

		if (roomId == null || userId == null) {
			session.close(CloseStatus.BAD_DATA); // 필수값 없으면 연결 끊기
			return;
		}

		sessionDAO.addSession(roomId, session);

		// 게임방 플레이어 리스트가 없다면 새로 생성 후 어플리케이션 스코프에 저장
//		if(roomPlayers == null) {
//			roomPlayers = new ConcurrentHashMap<>();
//			servletContext.setAttribute("roomPlayers", roomPlayers);
//		}

		// 게임방에 플레이어 추가
		PlayerDTO player = PlayerDTO.builder()
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

		// 기존 방에 유저 추가, 없으면 새로 리스트 생성 후 추가
//		roomPlayers.computeIfAbsent(roomId, k -> new ArrayList<>()).add(player);
	}

	private void broadcastMessage(String type, String roomId, Map<String, Object> data) throws IOException {
		List<WebSocketSession> sessions = sessionDAO.getSessions(roomId);

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
		String userId = (String) session.getAttributes().get("loginUser");

		PlayerDTO player = playerDAO.getPlayer(roomId, userId);

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

		sessionDAO.removeSession(roomId, session);
		playerDAO.removePlayer(roomId, userId);

		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("exit", roomId, data);

//		List<PlayerDTO> players = roomPlayers.get(roomId);
//		if(players != null) {
//			players.removeIf(p -> p.getUser_uid().equals(userId));
//			if(players.isEmpty()) { // 플레이어가 없으면 방 삭제
//				roomPlayers.remove(roomId);
//			}
//		}
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// 예외 로깅 또는 복구 처리
	}
}
