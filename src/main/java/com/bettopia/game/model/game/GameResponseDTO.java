package com.bettopia.game.model.game;

import lombok.Builder;
import lombok.Data;

import java.sql.Date;

@Data
@Builder
public class GameResponseDTO {
    private String uid;
    private String name;
    private String type;
    private String description;
    private String game_img;
    private String status;
    private Date created_at;
}
