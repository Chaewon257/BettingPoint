package com.bettopia.game.model.gameroom;

import java.util.List;

import com.bettopia.game.model.player.PlayerDAO;
import com.bettopia.game.model.player.PlayerDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class GameRoomService {

	@Autowired
	private GameRoomDAO gameRoomDAO;
	@Autowired
	private PlayerDAO playerDAO;

	public List<GameRoomResponseDTO> selectAll() {
		List<GameRoomResponseDTO> roomlist = gameRoomDAO.selectAll();

		for(GameRoomResponseDTO room : roomlist) {
			List<PlayerDTO> players = playerDAO.getAll(room.getUid());
			room.setPlayers(players != null ? players.size():0);
		}
		return roomlist;
	}

	public GameRoomResponseDTO selectById(String roomId) {
		GameRoomResponseDTO room = gameRoomDAO.selectById(roomId);
		List<PlayerDTO> players = playerDAO.getAll(room.getUid());
		room.setPlayers(players != null ? players.size():0);
		return room;
	}

	public int insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, HttpSession session) {
		if(session != null) { // 유저 세션 존재 여부
			String userId = (String) session.getAttribute("loginUser");
			return gameRoomDAO.insertRoom(roomRequest, userId);
		}
		return 0;
	}

	public int updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, HttpSession session, String roomId) {
		if(session != null) { // 유저 세션 존재 여부
			String userId = (String) session.getAttribute("loginUser");
			GameRoomResponseDTO room = gameRoomDAO.selectById(roomId);
			// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
			if(room != null && room.getHost_uid().equals(userId)) {
				return gameRoomDAO.updateRoom(roomRequest, roomId);
			}
		}
		return 0;
	}

	public int deleteRoom(String roomId, HttpSession session) {
		if (session != null) { // 유저 세션 존재 여부
			String userId = (String) session.getAttribute("loginUser");
			GameRoomResponseDTO room = gameRoomDAO.selectById(roomId);
			// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
			if (room != null && room.getHost_uid().equals(userId)) {
				return gameRoomDAO.deleteRoom(roomId);
			}
		}
		return 0;
	}
}
