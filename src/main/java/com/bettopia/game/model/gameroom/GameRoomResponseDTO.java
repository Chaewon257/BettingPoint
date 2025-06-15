package com.bettopia.game.model.gameroom;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GameRoomResponseDTO {
	private String uid;
	private String title;
	private int min_bet;
	private String status;
	private Date created_at;
	private Date started_at;
	private String game_uid;
	private String host_uid;
}
