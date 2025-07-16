package com.bettopia.game.model.multi.turtle;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TurtlePlayerDTO {
    private String user_uid;
    private String nickname;
    private String room_uid;
    private boolean isReady;
    private String turtle_id;
    private int betting_point;
}
