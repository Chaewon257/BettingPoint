package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.chatbot.ChatQADTO;
import com.bettopia.game.model.chatbot.ChatQAService;

@RestController
@RequestMapping("/chat")
public class ChatController {

	@Autowired
	ChatQAService chatService;
	
	@GetMapping(value = "/chat.do", produces = "text/plain;charset=UTF-8")
	public String f1() {
		return "test";
	}
	
	// 질문 전체 리스트 반환
    @GetMapping("/quesiton.do")
    public List<ChatQADTO> getAllQuestions() {
        return chatService.selectAll();
    }

    // uid로 질문-답변 1개 조회
    @GetMapping(value= "/answer.do", produces = "text/plain;charset=UTF-8")
    public String getAnswerByUid(String uid) {
        return chatService.questiontByUid(uid);
    }
    
//    @GetMapping(value="/questionByCate.do", produces = "application/json;charset=UTF-8")
//    public List<ChatQADTO> getQuestionByCate(@RequestParam("category") String category){
//    	System.out.println("카테고리로 받은 값: " + category);  // 디버깅용
//    	return chatService.selectByCate(category.trim());
//    }
    
    @GetMapping(value="/questionByCate.do", produces = "application/json;charset=UTF-8")
    public List<ChatQADTO> getQuestionByCate(@RequestParam("category") String category){
    	System.out.println("💡 전달받은 카테고리: [" + category + "]");
        List<ChatQADTO> list = chatService.selectByCate(category.trim());
        System.out.println("💬 결과 개수: " + list.size());

    	return list;
    }
	
}
