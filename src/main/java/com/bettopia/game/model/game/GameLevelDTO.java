package com.bettopia.game.model.game;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GameLevelDTO {
	private String uid; 
	private String gameUid; 
	private String level;
	private double probability;
	private double reward;

}


