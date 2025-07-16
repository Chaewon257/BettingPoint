package com.bettopia.game.model.multi.turtle;

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

    // 거북이 게임방 플레이어 상세 조회
    public List<TurtlePlayerDTO> getPlayers(String roomId) {
        List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
        return players;
    }

    // 각 게임방 플레이어 수
    public Map<String, Integer> getAllPlayers() {
        Map<String, Integer> roomPlayers = new HashMap<>();
        List<String> roomIds = gameRoomService.selectAll().stream()
                .map(GameRoomResponseDTO::getUid)
                .collect(Collectors.toList());
        for (String roomId : roomIds) {
            List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
            // 플레이어가 없으면 0 처리
            int count = (players != null) ? players.size() : 0;
            roomPlayers.put(roomId, count);
        }
        return roomPlayers;
    }
}
