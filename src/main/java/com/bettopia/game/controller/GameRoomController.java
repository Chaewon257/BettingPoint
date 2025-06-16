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
@RequestMapping("/gameroom")
public class GameRoomController {

	@Autowired
	GameRoomService gameRoomService;

	@GetMapping("/list")
	public List<GameRoomResponseDTO.GameRoomDTO> selectAll() {
		return gameRoomService.selectAll();
	}

	@GetMapping("/{roomId}")
	public GameRoomResponseDTO.GameRoomDTO selectById(@PathVariable String roomId) {
		return gameRoomService.selectById(roomId);
	}

	@PostMapping("/insert/{gameId}")
	public String insertRoom(@RequestBody GameRoomRequestDTO.InsertGameRoomRequestDTO roomRequest,
							 HttpSession loginUser) {
		return gameRoomService.insertRoom(roomRequest, loginUser)>0?"방이 생성되었습니다.":"다시 시도해주세요.";
	}

	@PutMapping("/update/{roomId}")
	public String updateRoom(@RequestBody GameRoomRequestDTO.UpdateGameRoomRequestDTO roomRequest,
							 HttpSession loginUser, @PathVariable String roomId) {
		return gameRoomService.updateRoom(roomRequest, loginUser, roomId)>0?"방이 수정되었습니다.":"다시 시도해주세요.";
	}

	@DeleteMapping("/delete/{roomId}")
	public String deleteRoom(@PathVariable String roomId, HttpSession loginUser) {
		return gameRoomService.deleteRoom(roomId, loginUser)>0?"방이 삭제되었습니다.":"다시 시도해주세요.";
	}
}
