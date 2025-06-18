package com.bettopia.game.model.player;

import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class PlayerService {

    @Autowired
    PlayerDAO playerDAO;
    @Autowired
    GameRoomService gameRoomService;

    // 게임방 플레이어 상세 조회
    public List<PlayerDTO> getPlayers(String roomId) {
        List<PlayerDTO> players = playerDAO.getAll(roomId);
        return players;
    }

    // 각 게임방 플레이어 수
    public Map<String, Integer> getAllPlayers() {
        Map<String, Integer> roomPlayers = new HashMap<>();
        List<String> roomIds = gameRoomService.selectAll().stream()
                .map(GameRoomResponseDTO::getUid)
                .collect(Collectors.toList());
        for (String roomId : roomIds) {
            int count = getPlayers(roomId).size();
            roomPlayers.put(roomId, count);
        }
        return roomPlayers;
    }
}
