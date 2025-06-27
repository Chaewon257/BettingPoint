package com.bettopia.game.model.content;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BettubeDTO {
    private String uid;
    private String title;
    private String bettube_url;
    private String description;
    private Date created_at;
}
