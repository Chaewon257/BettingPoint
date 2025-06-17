package com.bettopia.game.model.gameroom;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("gameRoomMybatis")
public class GameRoomDAO {

	@Autowired
	private SqlSession sqlSession;
	String namespace = "com.bpoint.gameroom.";

	public List<GameRoomResponseDTO.GameRoomDTO> selectAll() {
		List<GameRoomResponseDTO.GameRoomDTO> roomlist = sqlSession.selectList(namespace + "selectAll");
		return roomlist;
	}

	public GameRoomResponseDTO.GameRoomDTO selectById(String roomId) {
		GameRoomResponseDTO.GameRoomDTO room = sqlSession.selectOne(namespace + "selectById", roomId);
		return room;
	}

	public int insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, String userId) {
		String uid = UUID.randomUUID().toString().replace("-", "");
		GameRoomResponseDTO.InsertGameRoomResponseDTO roomResponse = GameRoomResponseDTO.InsertGameRoomResponseDTO.builder()
						.uid(uid)
						.title(roomRequest.getTitle())
						.min_bet(roomRequest.getMin_bet())
						.host_uid(userId)
						.game_uid(roomRequest.getGame_uid())
						.build();
		int result = sqlSession.insert(namespace + "insert", roomResponse);
		return result;
	}

	public int updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, String roomId) {
		GameRoomResponseDTO.UpdateGameRoomResponseDTO roomResponse = GameRoomResponseDTO.UpdateGameRoomResponseDTO.builder()
				.uid(roomId)
				.title(roomRequest.getTitle())
				.game_uid(roomRequest.getGame_uid())
				.build();
		int result = sqlSession.update(namespace + "update", roomResponse);
		return result;
	}

	public int deleteRoom(String roomId) {
		int result = sqlSession.delete(namespace + "delete", roomId);
		return result;
	}
}
