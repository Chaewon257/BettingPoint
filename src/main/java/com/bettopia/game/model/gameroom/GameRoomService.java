package com.bettopia.game.model.gameroom;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class GameRoomService {

	@Autowired
	private GameRoomDAO gameRoomDAO;

	public List<GameRoomResponseDTO.GameRoomDTO> selectAll() {
		return gameRoomDAO.selectAll();
	}

	public GameRoomResponseDTO.GameRoomDTO selectById(String roomId) {
		return gameRoomDAO.selectById(roomId);
	}

	public int insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, HttpSession loginUser) {
		if(loginUser != null) { // 유저 세션 존재 여부
			String userId = (String)loginUser.getAttribute("userId");
			return gameRoomDAO.insertRoom(roomRequest, userId);
		}
		return 0;
	}

	public int updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, HttpSession loginUser, String roomId) {
		if(loginUser != null) { // 유저 세션 존재 여부
			String userId = (String)loginUser.getAttribute("userId");
			GameRoomResponseDTO.GameRoomDTO room = gameRoomDAO.selectById(roomId);
			// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
			if(room != null && room.getHost_uid().equals(userId)) {
				return gameRoomDAO.updateRoom(roomRequest, roomId);
			}
		}
		return 0;
	}

	public int deleteRoom(String roomId, HttpSession loginUser) {
		if (loginUser != null) {
			String userId = (String) loginUser.getAttribute("userId");
			GameRoomResponseDTO.GameRoomDTO room = gameRoomDAO.selectById(roomId);
			if (room != null && room.getHost_uid().equals(userId)) {
				return gameRoomDAO.deleteRoom(roomId);
			}
		}
		return 0;
	}
}
