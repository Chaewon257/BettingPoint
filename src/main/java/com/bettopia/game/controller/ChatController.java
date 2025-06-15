package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bettopia.game.model.chatbot.ChatQADTO;
import com.bettopia.game.model.chatbot.ChatQAService;

@Controller
@RequestMapping("/chat")
public class ChatController {

	@Autowired
	ChatQAService chatService;
	
	@GetMapping
    public String chatbotView(Model model) {
        model.addAttribute("message", "반갑습니다. 아래 질문을 선택해주세요.");
        model.addAttribute("questions", chatService.selectAll());
        return "chatbot/chatView";
    }
	
	@GetMapping("/chatlist.do")
	public List<ChatQADTO> chatListAll(){
		return chatService.selectAll();
	}
	
}
