package com.bettopia.game.model.gameroom;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.bettopia.game.model.multi.turtle.PlayerDAO;
import com.bettopia.game.model.multi.turtle.TurtlePlayerDTO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("gameRoomMybatis")
public class GameRoomDAO {

	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private PlayerDAO playerDAO;

	String namespace = "com.bpoint.gameroom.";

	public List<GameRoomResponseDTO> selectAll(int offset, int size) {
		Map<String, Integer> params = new HashMap<>();
		params.put("offset", offset);
		params.put("size", size);
		List<GameRoomResponseDTO> roomlist = sqlSession.selectList(namespace + "selectAllWithPaging", params);
		return roomlist;
	}

	public List<GameRoomResponseDTO> selectAll() {
		List<GameRoomResponseDTO> roomlist = sqlSession.selectList(namespace + "selectAll");
		return roomlist;
	}

	public GameRoomResponseDTO selectById(String roomId) {
		GameRoomResponseDTO room = sqlSession.selectOne(namespace + "selectById", roomId);
		return room;
	}

	public String insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, String userId) {
		String uid = UUID.randomUUID().toString().replace("-", "");
		GameRoomResponseDTO roomResponse = GameRoomResponseDTO.builder()
						.uid(uid)
						.title(roomRequest.getTitle())
						.min_bet(roomRequest.getMin_bet())
						.host_uid(userId)
						.game_uid(roomRequest.getGame_uid())
						.build();
		sqlSession.insert(namespace + "insert", roomResponse);
		return uid;
	}

	public String updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, String roomId) {
		GameRoomResponseDTO roomResponse = GameRoomResponseDTO.builder()
				.uid(roomId)
				.title(roomRequest.getTitle())
				.game_uid(roomRequest.getGame_uid())
				.build();
		sqlSession.update(namespace + "update", roomResponse);
		return roomId;
	}

	public void deleteRoom(String roomId) {
		sqlSession.delete(namespace + "delete", roomId);
	}
}
