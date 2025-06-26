package com.bettopia.game.controller;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.chatlog.ChatLogDTO;
import com.bettopia.game.model.chatlog.ChatLogService;

@RestController
@RequestMapping("/api/chatlog")
public class ChatLogRestController {

	@Autowired
	ChatLogService chatLogService;
	@Autowired
	AuthService authService;
	
	// ✅ 사용자 UID로 채팅 로그 전체 조회
    @GetMapping("")
    public List<ChatLogDTO> getLogsByUser(@RequestHeader("Authorization") String authHeader) {
    	String userId = authService.validateAndGetUserId(authHeader);
        return chatLogService.selectByUser(userId);
    }
    
    // ✅ UID로 채팅 로그 상세 조회
    @GetMapping("/{chatlog_uid}")
    public ChatLogDTO getLogByUid(@PathVariable String chatlog_uid) {
        return chatLogService.selectByUid(chatlog_uid);
    }

    // ✅ 채팅 로그 등록
    @PostMapping(value = "/insertChatlog", produces = "text/plain;charset=utf-8", 
			consumes = MediaType.APPLICATION_JSON_VALUE)
    public String insertChatLog(@RequestBody ChatLogDTO chatlog,
    							@RequestHeader("Authorization") String authHeader) throws IOException {
    	chatlog.setUid(UUID.randomUUID().toString().replace("-", ""));
    	String userId = authService.validateAndGetUserId(authHeader);
		chatlog.setUser_uid(userId);
		
		chatlog.setResponse(null);
		chatlog.setResponse_date(null);
		
        int result = chatLogService.insertChatLog(chatlog);
        return result > 0 ? "문의 내역 등록 성공" : "문의 내역 등록 실패";
    }

    // ✅ 로그 삭제
    @DeleteMapping("/deleteChatlog/{chatlog_uid}")
    public String deleteLog(@PathVariable String chatlog_uid) {
        int result = chatLogService.deleteLog(chatlog_uid);
        return result > 0 ? "문의 내역 삭제 성공" : "문의 내역 삭제 실패";
    }
	
}
