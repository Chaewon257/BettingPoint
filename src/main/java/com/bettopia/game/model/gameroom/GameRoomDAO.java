package com.bettopia.game.model.gameroom;

import java.util.List;
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

	public List<GameRoomResponseDTO> selectAll() {
		List<GameRoomResponseDTO> roomlist = sqlSession.selectList(namespace + "selectAll");
		return roomlist;
	}

	public GameRoomResponseDTO selectById(String roomId) {
		GameRoomResponseDTO room = sqlSession.selectOne(namespace + "selectById", roomId);
		return room;
	}

	public int insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, String userId) {
		String uid = UUID.randomUUID().toString().replace("-", "");
		GameRoomResponseDTO roomResponse = GameRoomResponseDTO.builder()
						.uid(uid)
						.title(roomRequest.getTitle())
						.min_bet(roomRequest.getMin_bet())
						.host_uid(userId)
						.game_uid(roomRequest.getGame_uid())
						.build();
		int result = sqlSession.insert(namespace + "insert", roomResponse);

		// 생성자 정보를 플레이어로 추가
		TurtlePlayerDTO player = TurtlePlayerDTO.builder()
				.user_uid(userId)
				.room_uid(roomResponse.getUid())
				.isReady(false)
				.turtle_id("first")
				.betting_point(0)
				.build();

		playerDAO.addPlayer(roomResponse.getUid(), player);

		return result;
	}

	public int updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, String roomId) {
		GameRoomResponseDTO roomResponse = GameRoomResponseDTO.builder()
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
