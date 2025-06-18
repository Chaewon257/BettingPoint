package com.bettopia.game.model.board;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class BoardRequestDTO {
	
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	@Data
	public static class InsertBoardRequestDTO {
		private String title;
		private String content;
	    private String category;
	    private String board_img;
		
	}
	
	@Builder
	@NoArgsConstructor
	@AllArgsConstructor
	@Data
	public static class UpdateBoardRequestDTO {
		private String content;
	    private String category;
	    private String board_img;
		
	}
	

}
