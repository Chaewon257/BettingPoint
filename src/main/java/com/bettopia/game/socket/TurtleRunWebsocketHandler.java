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

// ��ü �޽��� ó��
@Component
public class TurtleRunWebsocketHandler extends TextWebSocketHandler {

	// ������ �� ���
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

 // [1] �� �溰 �ֽ� positions ���� ��
    private final Map<String, List<Double>> latestPositions = new ConcurrentHashMap<>();
    // [2] �� �溰 ��ε�ĳ��Ʈ ������ Ÿ�̸�
    private final Map<String, ScheduledFuture<?>> broadcastTasks = new ConcurrentHashMap<>();
    // [3] Ÿ�̸� ���� ����
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(4);

    @Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// ����� ���� ����, �ʱ� ������ ���� ��
		String userId = (String) session.getAttributes().get("userId");
		String roomId = (String) session.getAttributes().get("roomId");

		if(roomId == null || userId == null) {
			session.close(CloseStatus.BAD_DATA);
			return;
		}

		// �÷��̾� ����Ʈ ��ȸ
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		if(players != null) {
			// �ߺ� ���� Ȯ��
			for(TurtlePlayerDTO player : players) {
				if(player.getUser_uid().equals(userId)) {
					session.close(CloseStatus.BAD_DATA);
					return;
				}
			}
			// �ִ� �ο� �ʰ� Ȯ��
			if(players.size() >= 8) {
				session.close(CloseStatus.BAD_DATA);
				return;
			}

			// ���� ����Ʈ Ȯ��
			// �ּ� ���� ����Ʈ ��ŭ ���� ����
			UserVO user = authService.findByUid(userId);
			GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
			if(user.getPoint_balance() < gameroom.getMin_bet()) {
				session.close(CloseStatus.BAD_DATA);
				return;
			}
		}

		// ���� ���
		sessionService.addSession(roomId, session);

		// �÷��̾� �߰�
		TurtlePlayerDTO player = TurtlePlayerDTO.builder()
			.user_uid(userId)
			.room_uid(roomId)
			.isReady(false)
			.turtle_id("1")
			.betting_point(0)
			.build();

		playerDAO.addPlayer(roomId, player);

		// ���� �޽��� ��ε�ĳ��Ʈ
		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("enter", roomId, data);
	}

	private void broadcastMessage(String type, String roomId) throws IOException {
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		if (sessions == null || sessions.isEmpty()) {
			// �� �̻� �޽��� ���� ������ ����
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
		// ��ü �޽��� ����
		List<WebSocketSession> sessions = sessionService.getSessions(roomId);
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		if (sessions == null || sessions.isEmpty()) {
			// �� �̻� �޽��� ���� ������ ����
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
		// Ŭ���̾�Ʈ�� ���� �޽����� �޾Ƽ� ó�� (��: ����, ����, ���� ��)

		// �޽��� �Ľ�
		String payload = message.getPayload();
		ObjectMapper mapper = new ObjectMapper();
		JsonNode json = mapper.readTree(payload);

		String type = json.get("type").asText();

		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");

		TurtlePlayerDTO player = playerDAO.getPlayer(roomId, userId);

		// �޽��� Ÿ�Կ� ���� �б�
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
                // [1] positions ���� ����
                List<Double> positions = new ArrayList<>();
                JsonNode posNode = json.get("positions");
                if (posNode != null && posNode.isArray()) {
                    for (JsonNode pos : posNode) {
                        positions.add(pos.asDouble());
                    }
                }
                latestPositions.put(roomId, positions);
                // [2] �ش� �濡 �̹� Ÿ�̸Ӱ� ������, 0.1�ʸ��� broadcast�ϴ� Ÿ�̸� ���
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
				
				 // 1. ��� ���� (Service ȣ��)
//			    turtleRunService.processGameResult(dto);

			    // 2. ��� �޽��� ���� (��޿� ������ ���� ��)
			    Map<String, Object> resultMsg = new HashMap<>();
			    resultMsg.put("type", "race_result");
			    resultMsg.put("winner", dto.getWinner());
			    resultMsg.put("points", dto.getPoints());
			    resultMsg.put("pointsChange", dto.getPointChange());
			    resultMsg.put("bet", dto.getBet());
			    resultMsg.put("userId", dto.getUser_uid());
			    resultMsg.put("roomId", dto.getRoomId());

			    // 3. �� ��ü�� ��� broadcast
			    broadcastMessage("race_result", roomId, resultMsg);
				break;
		}

		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);

		Map<String, Object> data = new HashMap<>();
		data.put("players", players);
		broadcastMessage("update", roomId, data);
	}

	 // [3] positions�� ��ü �����ڿ��� broadcast�ϴ� �Լ�
    private void broadcastRaceUpdate(String roomId) throws IOException {
        List<Double> positions = latestPositions.get(roomId);
        if (positions == null) return;
        Map<String, Object> data = new HashMap<>();
        data.put("positions", positions);
        broadcastMessage("race_update", roomId, data);
    }

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// ���� ����, ���� ó�� ��
		String roomId = (String) session.getAttributes().get("roomId");
		String userId = (String) session.getAttributes().get("userId");

		sessionService.removeSession(roomId, session);
		playerDAO.removePlayer(roomId, userId);
		
		List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
		if (players == null || players.isEmpty()) { // �÷��̾ ���� �� ���� �޽��� �߼� �ߴ�
	        ScheduledFuture<?> task = broadcastTasks.remove(roomId);
	        if (task != null) task.cancel(true);
	        latestPositions.remove(roomId);
	    }
		// �÷��̾ 0���� �� �� ����
		if (players == null || players.isEmpty()) {
			gameroomDAO.deleteRoom(roomId);
		}

		Map<String, Object> data = new HashMap<>();
		data.put("userId", userId);
		broadcastMessage("exit", roomId, data);
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		// ���� �α� Ȥ�� ó��
	}
}
