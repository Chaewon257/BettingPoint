package com.bettopia.game.model.multi.turtle;

import org.springframework.stereotype.Service;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
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

    public void removeSession(String roomId, String userId) {
        List<WebSocketSession> sessions = roomSessions.get(roomId);
        if(sessions != null) {
            sessions.removeIf(session -> {
                String sessionUserId = (String) session.getAttributes().get("userId");
                if (userId.equals(sessionUserId)) {
                    if (session.isOpen()) {
                        try {
                            session.close(CloseStatus.NORMAL);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    return true;  // userId가 같은 세션만 삭제
                }
                return false;  // 나머지는 삭제하지 않음
            });
            if(sessions.isEmpty()) {
                roomSessions.remove(roomId);
            }
        }
    }

    public WebSocketSession getSession(String roomId, String userId) {
        List<WebSocketSession> sessions = roomSessions.get(roomId);
        if(sessions != null) {
            for(WebSocketSession session : sessions) {
                String sessionUserId = (String) session.getAttributes().get("userId");
                if(userId.equals(sessionUserId)) {
                    return session;
                }
            }
        }
        return null;
    }

    // 현재 게임방의 세션 리스트
    // 웹소켓 메시지 전송용
    public List<WebSocketSession> getSessions(String roomId) {
        return roomSessions.get(roomId);
    }
}