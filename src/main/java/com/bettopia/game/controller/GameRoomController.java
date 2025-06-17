package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.gameroom.GameRoomRequestDTO;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/gameroom")
public class GameRoomController {

	@Autowired
	GameRoomService gameRoomService;

	// 게임방 리스트 조회
	@GetMapping
	public List<GameRoomResponseDTO.GameRoomDTO> selectAll() {
		return gameRoomService.selectAll();
	}

	// 게임방 상세 조회
	@GetMapping("/{roomId}")
	public GameRoomResponseDTO.GameRoomDTO selectById(@PathVariable String roomId) {
		return gameRoomService.selectById(roomId);
	}

	// 게임방 생성
	@PostMapping(value = "/insert", produces = "text/plain;charset=utf-8")
	public String insertRoom(@RequestBody GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest,
							 HttpSession session) {
		return gameRoomService.insertRoom(roomRequest, session)>0?"방이 생성되었습니다.":"다시 시도해주세요.";
	}

	// 게임방 수정
	@PutMapping(value = "/update/{roomId}", produces = "text/plain;charset=utf-8")
	public String updateRoom(@RequestBody GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest,
							 HttpSession session, @PathVariable String roomId) {
		return gameRoomService.updateRoom(roomRequest, session, roomId)>0?"방이 수정되었습니다.":"다시 시도해주세요.";
	}

	// 게임방 삭제
	@DeleteMapping(value = "/delete/{roomId}", produces = "text/plain;charset=utf-8")
	public String deleteRoom(@PathVariable String roomId, HttpSession session) {
		return gameRoomService.deleteRoom(roomId, session) > 0 ? "방이 삭제되었습니다." : "다시 시도해주세요.";
	}
}
