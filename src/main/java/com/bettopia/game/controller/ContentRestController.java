package com.bettopia.game.controller;

import com.bettopia.game.model.content.BannerDTO;
import com.bettopia.game.model.content.BettubeDTO;
import com.bettopia.game.model.content.ContentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/content")
public class ContentRestController {

    @Autowired
    private ContentService contentService;

    @GetMapping("/banner/list")
    public List<BannerDTO> bannerList() {
        return contentService.bannerList();
    }

    @GetMapping("/bettube/list")
    public List<BettubeDTO> bettubeList() {
        return contentService.bettubeList();
    }
}
