package com.bettopia.game.model.multi.turtle;

import java.util.List;

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
	private String difficulty;
	private List<Integer> turtleBets;
}
