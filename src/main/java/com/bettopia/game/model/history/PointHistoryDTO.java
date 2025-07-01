package com.bettopia.game.model.history;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PointHistoryDTO {
    private String uid;
    private String user_uid;
    private String type;
    private int amount;
    private int balance_after;
    private String gh_uid;
    private Date created_at;
    private String game_name; 
}
