package com.bettopia.game.model.board;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BoardDTO {
	    private String uid;
	    private String title;
	    private String content;
	    private String category;
	    private int view_count;
	    private int like_count;
	    private Date created_at;
	    private Date updated_at;
	    private String board_img;
	    private String user_uid;
	
}
