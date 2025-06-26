package com.bettopia.game.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.multi.turtle.TurtleRunResultDTO;
//import com.bettopia.game.model.multi.turtle.TurtleRunService;

@RestController
@RequestMapping("/api/multi")
public class TurtleRunRestController {

	@Autowired
	AuthService authService;
	
	// 웹소켓 연결을 위한 정보 받기
	@GetMapping("/gameroom/detail/{roomId}/info")
	public Map<String, Object> getRoomInfo(@PathVariable String roomId, @RequestHeader("Authorization") String authHeader) {
		Map<String, Object> map = new HashMap<>();
		String userId = authService.validateAndGetUserId(authHeader);
		
		map.put("roomId", roomId);
		map.put("userId", userId);
		
		return map;
	}
}
