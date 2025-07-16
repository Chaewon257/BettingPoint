package com.bettopia.game.model.history;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class HistoryResponseDTO {
	
	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class GameHistoryResponseDTO {
		private List<GameHistoryDTO> histories;
	    private int total;
	}
	
	@Data
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	public static class PointHistoryResponseDTO {
		private List<PointHistoryDTO> histories;
		private int total;
	}
	
}
