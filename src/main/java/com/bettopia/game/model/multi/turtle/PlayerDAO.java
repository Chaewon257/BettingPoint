package com.bettopia.game.model.multi.turtle;

import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class PlayerDAO {

    private final Map<String, List<TurtlePlayerDTO>> roomPlayers = new ConcurrentHashMap<>();

    public void addPlayer(String roomId, TurtlePlayerDTO player) {
        roomPlayers.computeIfAbsent(roomId, k -> Collections.synchronizedList(new ArrayList<>())).add(player);
    }

    public void removePlayer(String roomId, String userId) {
        List<TurtlePlayerDTO> players = roomPlayers.get(roomId);
        if (players != null) {
            synchronized (players) {
                players.removeIf(p -> p.getUser_uid().equals(userId));
                if(players.isEmpty()) { // 플레이어가 없으면 방 삭제
                    roomPlayers.remove(roomId);
                }
            }
        }
    }

    // 현재 게임방 플레이어 리스트
    public List<TurtlePlayerDTO> getAll(String roomId) {
        return roomPlayers.get(roomId);
    }

    // 현재 로그인한 사용자의 플레이어 정보
    public TurtlePlayerDTO getPlayer(String roomId, String userId) {
        List<TurtlePlayerDTO> players = roomPlayers.get(roomId);
        if (players != null) {
            synchronized (players) {
                for (TurtlePlayerDTO player : players) {
                    if (player.getUser_uid().equals(userId)) {
                        return player;
                    }
                }
            }
        }
        return null;
    }
}
