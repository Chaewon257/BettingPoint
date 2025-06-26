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
	@Autowired
	private GameRoomDAO gameroomDAO;
	@Autowired
	private GameRoomService gameRoomService;
    @Autowired
    private AuthService authService;

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
			// 중복 입장 검사
			for(TurtlePlayerDTO player : players) {
				if(player.getUser_uid().equals(userId)) {
					session.close(CloseStatus.BAD_DATA);
					return;
				}
			}
			// 최대 인원 초과 검사
			if(players.size() >= 8) {
				session.close(CloseStatus.BAD_DATA);
				return;
			}

			// 보유 포인트 검사
			// 최소 베팅 포인트 미만 입장 불가
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

		// 입장 메시지 방송
		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("enter", roomId, data);
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