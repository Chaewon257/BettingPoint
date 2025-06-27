package com.bettopia.game.model.gameroom;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GameRoomResponseDTO {
	private String uid;
	private String title;
	private int min_bet;
	private String status;
	private Date created_at;
	private Date start_at;
	private String host_uid;
	private String level;
	private String game_name;
	private int count;
}
