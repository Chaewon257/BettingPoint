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

@RestController
@RequestMapping("/gameroom")
public class GameRoomController {

	@Autowired
	GameRoomService gameRoomService;

	@GetMapping("/list")
	public List<GameRoomResponseDTO> selectAll() {
		return gameRoomService.selectAll();
	}

	@GetMapping("/{roomId}")
	public GameRoomResponseDTO selectById(@PathVariable String roomId) {
		return gameRoomService.selectById(roomId);
	}

	@PostMapping("/insert")
	public String insertRoom(@RequestBody GameRoomRequestDTO.InsertGameRoomRequestDTO room) {
		return gameRoomService.insertRoom(room)>0?"방이 생성되었습니다.":"다시 시도해주세요.";
	}

	@PutMapping("/update")
	public String updateRoom(@RequestBody GameRoomRequestDTO.UpdateGameRoomRequestDTO room) {
		return gameRoomService.updateRoom(room)>0?"방이 수정되었습니다.":"다시 시도해주세요.";
	}

	@DeleteMapping("/delete")
	public String deleteRoom(@PathVariable String roomId) {
		return gameRoomService.deleteRoom(roomId)>0?"방이 삭제되었습니다.":"다시 시도해주세요.";
	}
}
