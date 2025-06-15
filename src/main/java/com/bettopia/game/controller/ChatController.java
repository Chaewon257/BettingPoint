package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.chatbot.ChatQADTO;
import com.bettopia.game.model.chatbot.ChatQAService;

@RestController
@RequestMapping("/chat")
public class ChatController {

	@Autowired
	ChatQAService chatService;
	
	@GetMapping("/chatlist.do")
	public List<ChatQADTO> chatListAll(){
		return chatService.selectAll();
	}
	
}
