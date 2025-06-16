package com.bettopia.game.model.board;

import java.util.List;

public interface BoardDAOInterface {
    List<BoardDTO> selectAll();       //게시글 목록 조회
   
}