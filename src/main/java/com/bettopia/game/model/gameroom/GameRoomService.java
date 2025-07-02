package com.bettopia.game.model.gameroom;

import java.util.ArrayList;
import java.util.List;

import com.bettopia.game.model.game.GameDAO;
import com.bettopia.game.model.game.GameLevelDAO;
import com.bettopia.game.model.game.GameLevelDTO;
import com.bettopia.game.model.game.GameResponseDTO;
import com.bettopia.game.model.multi.turtle.PlayerDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GameRoomService {

	@Autowired
	private GameRoomDAO gameRoomDAO;
	@Autowired
	private GameLevelDAO gameLevelDAO;
	@Autowired
	private GameDAO gameDAO;
	@Autowired
	private PlayerDAO playerDAO;

	public List<GameRoomResponseDTO> selectAll(int page) {
		int size = 6;
		int offset = (page-1) * size;
		List<GameRoomDTO> roomlist = gameRoomDAO.selectAll(offset, size);
		List<GameRoomResponseDTO> responseList = new ArrayList<>();

		if (roomlist != null) {
			for (GameRoomDTO room : roomlist) {
				GameLevelDTO level = gameLevelDAO.selectByRoomUid(room.getGame_level_uid());
				if (level != null) {
					GameResponseDTO game = gameDAO.selectById(level.getGame_uid());
					if (game != null) {
						int count = playerDAO.getAll(room.getUid()) != null
								? playerDAO.getAll(room.getUid()).size()
								: 0;

						GameRoomResponseDTO roomResponse = GameRoomResponseDTO.builder()
								.uid(room.getUid())
								.title(room.getTitle())
								.level(level.getLevel())
								.game_name(game.getName())
								.count(count)
								.min_bet(room.getMin_bet())
								.host_uid(room.getHost_uid())
								.created_at(room.getCreated_at())
								.status(room.getStatus())
								.build();

						responseList.add(roomResponse);
					}
				}
			}
		}
		return responseList;
	}

	public List<GameRoomResponseDTO> selectAll() {
		List<GameRoomDTO> roomlist = gameRoomDAO.selectAll();
		List<GameRoomResponseDTO> responseList = new ArrayList<>();

		if (roomlist != null) {
			for (GameRoomDTO room : roomlist) {
				GameLevelDTO level = gameLevelDAO.selectByRoomUid(room.getGame_level_uid());
				if (level != null) {
					GameResponseDTO game = gameDAO.selectById(level.getGame_uid());
					if (game != null) {
						int count = playerDAO.getAll(room.getUid()) != null
								? playerDAO.getAll(room.getUid()).size()
								: 0;

						GameRoomResponseDTO roomResponse = GameRoomResponseDTO.builder()
								.uid(room.getUid())
								.title(room.getTitle())
								.level(level.getLevel())
								.game_name(game.getName())
								.count(count)
								.min_bet(room.getMin_bet())
								.host_uid(room.getHost_uid())
								.created_at(room.getCreated_at())
								.status(room.getStatus())
								.build();

						responseList.add(roomResponse);
					}
				}
			}
		}
		return responseList;
	}

	public GameRoomResponseDTO selectById(String roomId) {
		GameRoomDTO room = gameRoomDAO.selectById(roomId);

		if (room != null) {
			GameLevelDTO level = gameLevelDAO.selectByRoomUid(room.getGame_level_uid());
			if (level != null) {
				GameResponseDTO game = gameDAO.selectById(level.getGame_uid());
				if (game != null) {
					int count = playerDAO.getAll(room.getUid()) != null
							? playerDAO.getAll(room.getUid()).size()
							: 0;

					return GameRoomResponseDTO.builder()
							.uid(room.getUid())
							.title(room.getTitle())
							.level(level.getLevel())
							.game_name(game.getName())
							.count(count)
							.min_bet(room.getMin_bet())
							.host_uid(room.getHost_uid())
							.created_at(room.getCreated_at())
							.status(room.getStatus())
							.build();
				}
			}
		}
		return null;
	}

	public String insertRoom(GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest, String userId) {
		return gameRoomDAO.insertRoom(roomRequest, userId);
	}

	public String updateRoom(GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest, String userId, String roomId) {
		GameRoomDTO room = gameRoomDAO.selectById(roomId);
		// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
		if(room != null && room.getHost_uid().equals(userId)) {
			return gameRoomDAO.updateRoom(roomRequest, roomId);
		}
		return null;
	}

	public void deleteRoom(String roomId, String userId) {
		GameRoomDTO room = gameRoomDAO.selectById(roomId);
		// 게임방 존재 여부 && 현재 유저와 방장이 같은지 확인
		if (room != null && room.getHost_uid().equals(userId)) {
			gameRoomDAO.deleteRoom(roomId);
		}
	}

	public void updateStatus(String roomId, String status) {
		gameRoomDAO.updateStatus(roomId, status);
	}
}
