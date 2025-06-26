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
public class BannerDTO {
    private String uid;
    private String title;
    private String image_path;
    private String banner_link_url;
    private String description;
    private Date created_at;
}
