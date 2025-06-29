package com.bettopia.game.model.multi.turtle;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TurtleRunResultDTO {
	private String user_uid;
	private String game_uid;	
	private String roomId;
	private int winner;
	private int selectedTurtle;
	private int userBet;
	private int pointChange;
	private String difficulty;
	private int positions[];
	private int turtleBets[];
}
