package com.bettopia.game.model.gameroom;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class GameRoomRequestDTO {

	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class InsertGameRoomRequestDTO {
		private String title;
		private int min_bet;
		private String game_uid;
		private String host_uid;
	}

	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class UpdateGameRoomRequestDTO {
		private String title;
		private String game_uid;
	}
}
