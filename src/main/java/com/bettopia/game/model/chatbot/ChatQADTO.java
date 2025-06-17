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
	private String question_text;
	private String answer_text;
	private String category;
	
}
