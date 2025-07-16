package com.bettopia.game.socket;

import com.bettopia.game.model.gameroom.GameRoomService;
import com.bettopia.game.model.multi.turtle.PlayerService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class GameRoomListWebSocket extends TextWebSocketHandler {
    private static final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();

    @Autowired
    private GameRoomService gameRoomService;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
    }

    public void broadcastMessage(String type) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> messageMap = new HashMap<>();
        messageMap.put("type", type);
        messageMap.put("gamerooms", gameRoomService.selectAll());

        String jsonMessage = mapper.writeValueAsString(messageMap);

        for(WebSocketSession session : sessions) {
            if(session.isOpen()) {
                synchronized (session) {
                    session.sendMessage(new TextMessage(jsonMessage));
                }
            }
        }
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

    }
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
    }

    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {

    }
}