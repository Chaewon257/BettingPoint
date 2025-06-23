package com.bettopia.game.controller;

import java.util.List;

import com.bettopia.game.model.auth.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bettopia.game.model.gameroom.GameRoomRequestDTO;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/gameroom")
public class GameRoomRestController {

	@Autowired
	GameRoomService gameRoomService;
	@Autowired
	AuthService authService;

	// 게임방 리스트 조회
	@GetMapping("/list")
	public List<GameRoomResponseDTO> selectAll() {
		return gameRoomService.selectAll();
	}

	// 게임방 상세 조회
	@GetMapping("/detail/{roomId}")
	public GameRoomResponseDTO selectById(@PathVariable String roomId) {
		return gameRoomService.selectById(roomId);
	}

	// 게임방 생성
	@PostMapping(value = "/insert", produces = "text/plain;charset=utf-8")
	public String insertRoom(@RequestBody GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest,
							 @RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);
		return gameRoomService.insertRoom(roomRequest, userId);
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
	public void deleteRoom(@PathVariable String roomId, @RequestHeader("Authorization") String authHeader) {
		String userId = authService.validateAndGetUserId(authHeader);
		gameRoomService.deleteRoom(roomId, userId);
	}
}