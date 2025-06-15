package com.bettopia.game.model.gameroom;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameRoomService {

	@Autowired
	private GameRoomDAO gameRoomDAO;

	public List<GameRoomResponseDTO> selectAll() {
		return gameRoomDAO.selectAll();
	}

	public GameRoomResponseDTO selectById(String roomId) {
		return gameRoomDAO.selectById(roomId);
	}

	public int insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO room) {
		return gameRoomDAO.insertRoom(room);
	}

	public int updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO room) {
		return gameRoomDAO.updateRoom(room);
	}

	public int deleteRoom(String roomId) {return gameRoomDAO.deleteRoom(roomId);}
}
