package com.bettopia.game.model.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardService {
    
    @Autowired
    BoardDAOInterface boardDAO;
    public BoardService(BoardDAOInterface boardDAO) {
        this.boardDAO = boardDAO;
    }

    public List<BoardDTO> getAllBoards() {
        return boardDAO.selectAll();
    }

   
}
