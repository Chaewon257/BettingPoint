package com.bettopia.game.model.content;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ContentDAO {

    @Autowired
    private SqlSession sqlSession;

    String namespace = "com.bpoint.content.";

    public List<BannerDTO> bannerList() {
        return sqlSession.selectList(namespace + "selectBannerAll");
    }

    public List<BettubeDTO> bettubeList() {
        return sqlSession.selectList(namespace + "selectBettubeAll");
    }
}
