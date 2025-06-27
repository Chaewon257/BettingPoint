package com.bettopia.game.model.gameroom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("gameRoomMybatis")
public class GameRoomDAO {

	@Autowired
	private SqlSession sqlSession;

    String namespace = "com.bpoint.gameroom.";

    public List<GameRoomDTO> selectAll(int offset, int size) {
        Map<String, Integer> params = new HashMap<>();
        params.put("offset", offset);
        params.put("size", size);
        List<GameRoomDTO> roomlist = sqlSession.selectList(namespace + "selectAllWithPaging", params);
        return roomlist;
    }

	public List<GameRoomDTO> selectAll() {
		List<GameRoomDTO> roomlist = sqlSession.selectList(namespace + "selectAll");
		return roomlist;
	}

	public GameRoomDTO selectById(String roomId) {
		GameRoomDTO room = sqlSession.selectOne(namespace + "selectById", roomId);
		return room;
	}

	public String insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, String userId) {
		String uid = UUID.randomUUID().toString().replace("-", "");
		GameRoomDTO room = GameRoomDTO.builder()
                		.uid(uid)
						.title(roomRequest.getTitle())
						.min_bet(roomRequest.getMin_bet())
						.host_uid(userId)
                		.game_level_uid(roomRequest.getGame_level_uid())
                		.build();
        sqlSession.insert(namespace + "insert", room);
		return uid;
	}

	public String updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, String roomId) {
		GameRoomDTO room = GameRoomDTO.builder()
				.uid(roomId)
				.title(roomRequest.getTitle())
                .game_level_uid(roomRequest.getGame_level_uid())
				.build();
		sqlSession.update(namespace + "update", room);
		return roomId;
	}

	public void deleteRoom(String roomId) {
		sqlSession.delete(namespace + "delete", roomId);
	}

	public void updateStatus(String roomId, String status) {
		Map<String, String> params = new HashMap<>();
		params.put("uid", roomId);
		params.put("status", status);
		sqlSession.update(namespace + "updateStatus", params);
	}
}
