package com.bettopia.game.model.history;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bettopia.game.model.game.GameResponseDTO;
import com.bettopia.game.model.game.GameService;

import java.util.List;

@Service
public class HistoryService {

    @Autowired
    private HistoryDAO historyDAO;
    
    @Autowired
    private GameService gameService;


    public List<GameHistoryDTO> gameHistoryList(String userId) {
        return historyDAO.gameHistoryList(userId);
    }

    public List<PointHistoryDTO> pointHistoryList(String userId) {
        return historyDAO.pointHistoryList(userId);
    }
    
    public int gameHistoryCount(String userId) {
      return historyDAO.countGameHistory(userId);
    }

    public int pointHistoryCount(String userId) {
      return historyDAO.countPointHistory(userId);
    }

    
    public List<GameHistoryDTO> gameHistoryList(String userId, int page) {
        int size = 10;
        int offset = (page - 1) * size;
        List<GameHistoryDTO> list = historyDAO.gameHistoryList(userId, offset, size);

        for (GameHistoryDTO dto : list) {   //db에 없어서
            GameResponseDTO game = gameService.selectById(dto.getGame_uid());
            if (game != null) {
                dto.setGame_name(game.getName());
            }
        }

        return list;
    }

    public List<PointHistoryDTO> pointHistoryList(String userId, int page) {
        int size = 10;
        int offset = (page - 1) * size;
        List<PointHistoryDTO> list = historyDAO.pointHistoryList(userId, offset, size);

        for (PointHistoryDTO dto : list) {
            // 게임 히스토리 조회
            GameHistoryDTO gameHistory = historyDAO.selectGameHistoryByUid(dto.getGh_uid());
            if (gameHistory != null) {
                // 게임 이름 조회
                GameResponseDTO game = gameService.selectById(gameHistory.getGame_uid());
                if (game != null) {
                    dto.setGame_name(game.getName()); 
                }
            }
        }

        return list;
    }

    public GameHistoryDTO insertGameHistory(GameHistoryDTO gameHistory, String userId) {
        return historyDAO.insertGameHistory(gameHistory, userId);
    }

    public String insertPointHistory(PointHistoryDTO pointHistory, String userId) {
        return historyDAO.insertPointHistory(pointHistory, userId);
    }

    public String insertPointHistory(String userId, int amount) {
        return historyDAO.insertPointHistory(userId, amount);
    }
    
    public GameHistoryDTO insertGameHistory(String gameUid, String gameName, int betAmount, int pointValue, String result, String userId) {
        GameHistoryDTO dto = new GameHistoryDTO();
        dto.setGame_uid(gameUid);
        dto.setGame_name(gameName); 
        dto.setBetting_amount(betAmount);
        dto.setPoint_value(pointValue);
        dto.setGame_result(result);
        return historyDAO.insertGameHistory(dto, userId);
    }
   

}
