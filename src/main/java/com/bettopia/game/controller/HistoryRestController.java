package com.bettopia.game.controller;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.history.GameHistoryDTO;
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
    public List<GameHistoryDTO> gameHistoryList(@RequestHeader("Authorization") String authHeader,
                                                @RequestParam(defaultValue = "1") int page) {
        String userId = authService.validateAndGetUserId(authHeader);
        return historyService.gameHistoryList(userId, page);
    }

    @GetMapping("/point/list")
    public List<PointHistoryDTO> pointHistoryList(@RequestHeader("Authorization") String authHeader,
                                                @RequestParam(defaultValue = "1") int page) {
        String userId = authService.validateAndGetUserId(authHeader);
        return historyService.pointHistoryList(userId, page);
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