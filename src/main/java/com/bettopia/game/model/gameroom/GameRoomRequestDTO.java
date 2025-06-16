package com.bettopia.game.model.gameroom;

import lombok.Builder;
import lombok.Data;

public class GameRoomRequestDTO {

	@Data
	@Builder
	public static class InsertGameRoomRequestDTO {
		private String title;
		private int min_bet;
		private String game_uid;
		private String host_uid;
	}

	@Data
	@Builder
	public static class UpdateGameRoomRequestDTO {
		private String title;
		private String game_uid;
	}
}
