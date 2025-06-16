package com.bettopia.game.model.gameroom;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

public class GameRoomResponseDTO {
	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class InsertGameRoomResponseDTO {
		private String uid;
		private String title;
		private int min_bet;
		private String game_uid;
		private String host_uid;
	}

	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class UpdateGameRoomResponseDTO {
		private String uid;
		private String title;
		private String game_uid;
	}

	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class GameRoomDTO {
		private String uid;
		private String title;
		private int min_bet;
		private String status;
		private Date created_at;
		private Date start_at;
		private String game_uid;
		private String host_uid;
		private int players;
	}
}
