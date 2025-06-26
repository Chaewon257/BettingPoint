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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.multi.turtle.TurtleRunResultDTO;
//import com.bettopia.game.model.multi.turtle.TurtleRunService;

@RestController
@RequestMapping("/api/multi")
public class TurtleRunRestController {

	// �� ���� ���� ��������
	@GetMapping("/{roomId}/info")
	public Map<String, Object> getRoomInfo(@PathVariable String roomId, HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		map.put("roomId", roomId);
		map.put("token", session.getAttribute("token"));
		return map;
	}
    @PostMapping("/turtlerun/result")
    public ResponseEntity<?> saveTurtleRunResult(@RequestBody TurtleRunResultDTO dto) {
//        turtleRunService.processGameResult(dto); // DTO�� ��� ����
        return ResponseEntity.ok().build(); // �Ǵ� ����� ���� ��ȯ
    }
}
