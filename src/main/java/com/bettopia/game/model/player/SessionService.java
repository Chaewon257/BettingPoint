package com.bettopia.game.model.player;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.WebSocketSession;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SessionService {
    private final Map<String, List<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();

    public void addSession(String roomId, WebSocketSession session) {
        roomSessions.computeIfAbsent(roomId, k -> new ArrayList<>()).add(session);
    }

    public void removeSession(String roomId, WebSocketSession session) {
        List<WebSocketSession> sessions = roomSessions.get(roomId);
        if(sessions != null) {
            sessions.remove(session);
            if(sessions.isEmpty()) { // 세션이 존재하지 않으면 방 삭제
                roomSessions.remove(roomId);
            }
        }
    }

    // 현재 게임방의 세션 리스트
    // 웹소켓 메시지 전송용
    public List<WebSocketSession> getSessions(String roomId) {
        return roomSessions.get(roomId);
    }
}