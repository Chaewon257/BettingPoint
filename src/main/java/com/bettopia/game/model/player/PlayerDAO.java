package com.bettopia.game.model.player;

import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class PlayerDAO {

    private final Map<String, List<PlayerDTO>> roomPlayers = new ConcurrentHashMap<>();

    public void addPlayer(String roomId, PlayerDTO player) {
        roomPlayers.computeIfAbsent(roomId, k -> new ArrayList<>()).add(player);
    }

    public void removePlayer(String roomId, String userId) {
        List<PlayerDTO> players = roomPlayers.get(roomId);
        if (players != null) {
            players.removeIf(p -> p.getUser_uid().equals(userId));
            if(players.isEmpty()) { // 플레이어가 없으면 방 삭제
                roomPlayers.remove(roomId);
            }
        }
    }

    // 현재 게임방 플레이어 리스트
    public List<PlayerDTO> getAll(String roomId) {
        return roomPlayers.get(roomId);
    }

    // 현재 로그인한 사용자의 플레이어 정보
    public PlayerDTO getPlayer(String roomId, String userId) {
        List<PlayerDTO> players = roomPlayers.get(roomId);
        if (players != null) {
            for (PlayerDTO player : players) {
                if (player.getUser_uid().equals(userId)) {
                    return player;
                }
            }
        }
        return null;
    }
}
