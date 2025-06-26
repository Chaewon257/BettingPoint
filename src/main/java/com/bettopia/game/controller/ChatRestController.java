package com.bettopia.game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bettopia.game.model.chatbot.ChatQADTO;
import com.bettopia.game.model.chatbot.ChatQAService;

@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

	@Autowired
	ChatQAService chatService;
		
	// ✅ 전체 Q&A 목록 반환
    @GetMapping("/allQuestion")
    public List<ChatQADTO> getAllQuestions() {
        return chatService.selectAll();
    }

    // ✅ 메인 카테고리에 따른 서브 카테고리 목록 반환
    @GetMapping(value = "/subcategories/{main_category}", produces = "application/json;charset=UTF-8")
    public List<String> getSubCategoriesByMain(@PathVariable("main_category") String main_category) {
        return chatService.subCatesByMainCate(main_category.trim());
    }

    // ✅ 메인+서브 카테고리에 따른 질문 목록 반환
    @GetMapping(value = "/questions/{main_category}/{sub_category}", produces = "application/json;charset=UTF-8")
    public List<ChatQADTO> getQuestionsByMainAndSub(
    		@PathVariable("main_category") String main_category,
    		@PathVariable("sub_category") String sub_category) {
        return chatService.selectByMainSubCate(main_category.trim(), sub_category.trim());
    }

    // ✅ UID로 답변만 조회
    @GetMapping(value = "/answer/{uid}", produces = "text/plain;charset=UTF-8")
    public String getAnswerByUid(@PathVariable("uid") String uid) {
        return chatService.answerByUid(uid);
    }

    // ✅ 메인 카테고리로 질문 목록 조회 (서브 구분 없음)
    @GetMapping(value = "/questionsByMain/{main_category}", produces = "application/json;charset=UTF-8")
    public List<ChatQADTO> getQuestionsByMainCategory(@PathVariable("main_category") String main_category) {
        return chatService.selectByMainCate(main_category.trim());
    }
	
}
