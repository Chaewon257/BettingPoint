package com.bettopia.game.model.board;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Data
public class BoardDTO {
    private String uid;
    private String title;
    private String content;
    private String category;
    private int view_count;
    private int like_count;
    private Date create_at;
    private Date update_at;
    private String board_img;
    private String user_uid;

   
}
