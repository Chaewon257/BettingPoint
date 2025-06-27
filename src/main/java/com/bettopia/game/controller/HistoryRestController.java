package com.bettopia.game.controller;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.history.GameHistoryDTO;
import com.bettopia.game.model.history.HistoryResponseDTO;
import com.bettopia.game.model.history.HistoryResponseDTO.GameHistoryResponseDTO;
import com.bettopia.game.model.history.HistoryService;
import com.bettopia.game.model.history.PointHistoryDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/history")
public class HistoryRestController {

    @Autowired
    HistoryService historyService;
    @Autowired
    AuthService authService;

    @GetMapping("/game/list")
    public HistoryResponseDTO.GameHistoryResponseDTO gameHistoryList(
    											@RequestHeader("Authorization") String authHeader,
                                                @RequestParam(defaultValue = "1") int page) {
        String userId = authService.validateAndGetUserId(authHeader);
        List<GameHistoryDTO> list = historyService.gameHistoryList(userId, page);
        int totalCount = historyService.gameHistoryCount(userId); // data 총 개수 가져오기

        return HistoryResponseDTO.GameHistoryResponseDTO.builder()
                .histories(list)
                .total(totalCount)
                .build();        
    }

    @GetMapping("/point/list")
    public HistoryResponseDTO.PointHistoryResponseDTO pointHistoryList(
    											@RequestHeader("Authorization") String authHeader,
                                                @RequestParam(defaultValue = "1") int page) {
        String userId = authService.validateAndGetUserId(authHeader);
        List<PointHistoryDTO> list = historyService.pointHistoryList(userId, page);
        int totalCount = historyService.pointHistoryCount(userId); // data 총 개수 가져오기
        
        return HistoryResponseDTO.PointHistoryResponseDTO.builder()
        		.histories(list)
        		.total(totalCount)
        		.build();
    }

    @PostMapping("/game/insert")
    public GameHistoryDTO insertGameHistory(@RequestBody GameHistoryDTO gameRequest,
                                    @RequestHeader("Authorization") String authHeader) {
        String userId = authService.validateAndGetUserId(authHeader);
        return historyService.insertGameHistory(gameRequest, userId);
    }

    @PostMapping("/point/insert")
    public String insertPointHistory(@RequestBody PointHistoryDTO pointRequest,
                                     @RequestHeader("Authorization") String authHeader) {
        String userId = authService.validateAndGetUserId(authHeader);
        return historyService.insertPointHistory(pointRequest, userId);
    }
}