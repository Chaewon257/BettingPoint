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
public class GameHistoryDTO {
    private String uid;
    private String user_uid;
    private String game_uid;
    private int betting_amount;
    private String game_result;
    private int point_value;
    private Date created_at;
}
