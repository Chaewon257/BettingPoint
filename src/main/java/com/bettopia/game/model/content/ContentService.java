package com.bettopia.game.model.content;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContentService {

    @Autowired
    private ContentDAO contentDAO;

    public List<BannerDTO> bannerList() {
        return contentDAO.bannerList();
    }

    public List<BettubeDTO> bettubeList() {
        return contentDAO.bettubeList();
    }
}
