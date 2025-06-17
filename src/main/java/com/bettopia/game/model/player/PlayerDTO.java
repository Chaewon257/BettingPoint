package com.bettopia.game.model.player;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlayerDTO {
    private String user_uid;
    private String room_uid;
    private boolean isReady;
    private String turtle_id;
    private int betting_point;
}
