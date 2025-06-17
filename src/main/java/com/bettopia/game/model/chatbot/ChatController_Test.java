package com.bettopia.game.model.chatbot;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/chat")
public class ChatController_Test {
	@GetMapping
    public String moveToChatView() {
        return "chatbot/chatView"; // ¡æ /WEB-INF/views/chat/chatView.jsp
    }

}
