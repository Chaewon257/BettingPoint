package com.bettopia.game.model.gameroom;

import lombok.Builder;
import lombok.Data;

public class GameRoomResponseDTO {
	@Data
	@Builder
	public static class InsertGameRoomResponseDTO {
		private String uid;
		private String title;
		private int min_bet;
		private String game_uid;
		private String host_uid;
	}

	@Data
	@Builder
	public static class UpdateGameRoomResponseDTO {
		private String uid;
		private String title;
		private String game_uid;
	}

	@Data
	@Builder
	public static class GameRoomDTO {
		private String uid;
		private String title;
		private int min_bet;
		private String status;
		private String created_at;
		private String start_at;
		private String game_uid;
		private String host_uid;
	}
}
