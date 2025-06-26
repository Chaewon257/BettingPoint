package com.bettopia.game.controller;

import java.io.IOException;
import java.util.List;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.socket.GameRoomListWebSocket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bettopia.game.model.gameroom.GameRoomRequestDTO;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;

@RestController
@RequestMapping("/api/gameroom")
public class GameRoomRestController {

	@Autowired
	GameRoomService gameRoomService;
	@Autowired
	AuthService authService;
	@Autowired
	private GameRoomListWebSocket gameRoomListWebSocket;

	// 게임방 리스트 조회
	@GetMapping("/list")
	public List<GameRoomResponseDTO> selectAll(@RequestParam(defaultValue = "1") int page) {
		return gameRoomService.selectAll(page);
	}

	// 게임방 상세 조회
	@GetMapping("/detail/{roomId}")
	public GameRoomResponseDTO selectById(@PathVariable String roomId) {
		return gameRoomService.selectById(roomId);
	}

	// 게임방 생성
	@PostMapping(value = "/insert", produces = "text/plain;charset=utf-8")
	public String insertRoom(@RequestBody GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest,
							 @RequestHeader("Authorization") String authHeader) throws IOException {
		String userId = authService.validateAndGetUserId(authHeader);
		String roomId = gameRoomService.insertRoom(roomRequest, userId);
		gameRoomListWebSocket.broadcastMessage("insert");
		return roomId;
	}

	// 게임방 수정
	@PutMapping(value = "/update/{roomId}", produces = "text/plain;charset=utf-8")
	public String updateRoom(@RequestBody GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest,
							 @RequestHeader("Authorization") String authHeader, @PathVariable String roomId) {
		String userId = authService.validateAndGetUserId(authHeader);
		return gameRoomService.updateRoom(roomRequest, userId, roomId);
	}

	// 게임방 삭제
	@DeleteMapping(value = "/delete/{roomId}", produces = "text/plain;charset=utf-8")
	public void deleteRoom(@PathVariable String roomId, @RequestHeader("Authorization") String authHeader) throws IOException {
		String userId = authService.validateAndGetUserId(authHeader);
		gameRoomService.deleteRoom(roomId, userId);
		gameRoomListWebSocket.broadcastMessage("delete");
	}
}