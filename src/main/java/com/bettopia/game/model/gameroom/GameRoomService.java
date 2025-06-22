package com.bettopia.game.model.gameroom;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class GameRoomService {

	@Autowired
	private GameRoomDAO gameRoomDAO;

	public List<GameRoomResponseDTO> selectAll() {
		List<GameRoomResponseDTO> roomlist = gameRoomDAO.selectAll();
		return roomlist;
	}

	public GameRoomResponseDTO selectById(String roomId) {
		GameRoomResponseDTO room = gameRoomDAO.selectById(roomId);
		return room;
	}

	public String insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, String userId) {
		return gameRoomDAO.insertRoom(roomRequest, userId);
	}

	public String updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, String userId, String roomId) {
		GameRoomResponseDTO room = gameRoomDAO.selectById(roomId);
		// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
		if(room != null && room.getHost_uid().equals(userId)) {
			return gameRoomDAO.updateRoom(roomRequest, roomId);
		}
		return null;
	}

	public void deleteRoom(String roomId, String userId) {
		GameRoomResponseDTO room = gameRoomDAO.selectById(roomId);
		// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
		if (room != null && room.getHost_uid().equals(userId)) {
			gameRoomDAO.deleteRoom(roomId);
		}
	}
}
