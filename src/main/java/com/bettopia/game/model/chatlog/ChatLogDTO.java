package com.bettopia.game.model.chatlog;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class ChatLogDTO {
	private String uid;
	private String user_uid;
	private String title;	
	private String question;
	private String response;
	private Date chat_date;
	private Date response_date;
}
