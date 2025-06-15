package com.bettopia.game.model.gameroom;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("gameRoomMybatis")
public class GameRoomDAO {

	@Autowired
	private SqlSession sqlSession;
	String namespace = "com.bpoint.gameroom.";

	public List<GameRoomResponseDTO> selectAll() {
		List<GameRoomResponseDTO> roomlist = sqlSession.selectList(namespace + "selectAll");
		return roomlist;
	}

	public GameRoomResponseDTO selectById(String roomId) {
		GameRoomResponseDTO room = sqlSession.selectOne(namespace + "selectById", roomId);
		return room;
	}

	public int insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO room) {
		int result = sqlSession.insert(namespace + "insert", room);
		return result;
	}

	public int updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO room) {
		int result = sqlSession.update(namespace + "update", room);
		return result;
	}

	public int deleteRoom(String roomId) {
		int result = sqlSession.delete(namespace + "delete", roomId);
		return result;
	}
}
