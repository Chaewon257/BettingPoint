package com.bettopia.game.model.history;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class HistoryService {

    @Autowired
    private HistoryDAO historyDAO;

    public List<GameHistoryDTO> gameHistoryList(String userId) {
        return historyDAO.gameHistoryList(userId);
    }

    public List<PointHistoryDTO> pointHistoryList(String userId) {
        return historyDAO.pointHistoryList(userId);
    }

    public List<GameHistoryDTO> gameHistoryList(String userId, int page) {
        int size = 10;
        int offset = (page-1) * size;
        return historyDAO.gameHistoryList(userId, offset, size);
    }

    public List<PointHistoryDTO> pointHistoryList(String userId, int page) {
        int size = 10;
        int offset = (page-1) * size;
        return historyDAO.pointHistoryList(userId, offset, size);
    }

    public GameHistoryDTO insertGameHistory(GameHistoryDTO gameHistory, String userId) {
        return historyDAO.insertGameHistory(gameHistory, userId);
    }

    public String insertPointHistory(PointHistoryDTO pointHistory, String userId) {
        return historyDAO.insertPointHistory(pointHistory, userId);
    }
}
