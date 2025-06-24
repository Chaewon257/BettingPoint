package com.bettopia.game.model.chatbot;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class ChatQADTO {
	private String uid;
	private String main_category;
	private String sub_category;	
	private String question_text;
	private String answer_text;	
}
