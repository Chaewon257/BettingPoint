package com.bettopia.game.model.multi.turtle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.LoginDAO;
import com.bettopia.game.model.auth.UserVO;
import com.bettopia.game.model.game.GameService;
import com.bettopia.game.model.gameroom.GameRoomResponseDTO;
import com.bettopia.game.model.gameroom.GameRoomService;
import com.bettopia.game.model.history.GameHistoryDTO;
import com.bettopia.game.model.history.HistoryService;
import com.bettopia.game.model.history.PointHistoryDTO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

@Service
public class TurtleGameService {
	
	@Autowired
	private PlayerDAO playerDAO;
	@Autowired
	private GameRoomService gameRoomService;
	@Autowired
	private AuthService authService;
	@Autowired
	private GameService gameService;
	@Autowired
	private HistoryService historyService;
	@Autowired
	private LoginDAO loginDAO;
	
    private final Map<String, TurtleGameState> gameStates = new ConcurrentHashMap<>();
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(4);

    // 콜백 인터페이스(핸들러에서 정의)
    public interface RaceUpdateCallback {
        void onRaceUpdate(String roomId, double[] positions);
        void onRaceFinish(String roomId, int winner, List<Map<String, Object>> results);
    }

    // 게임 시작(레이스 시작)
    public void startGame(String roomId, int turtleCount, RaceUpdateCallback callback) {
        TurtleGameState state = new TurtleGameState(turtleCount);
        gameStates.put(roomId, state);
        scheduler.schedule(() -> runRaceLoop(roomId, state, callback), 0, TimeUnit.SECONDS);
    }

    // 실제 레이스 루프(40ms마다)
    private void runRaceLoop(String roomId, TurtleGameState state, RaceUpdateCallback callback) {
        int interval = 30;
        Runnable task = new Runnable() {
            @Override
            public void run() {
                if (state.isFinished()) return;
                state.updateRace();
                callback.onRaceUpdate(roomId, state.getPositions());
                if (state.isFinished()) {
                	List<Map<String, Object>> results = gameResultAndPointCalc(roomId, state);
                    callback.onRaceFinish(roomId, state.getWinner(), results);
                } else {
                    scheduler.schedule(this, interval, TimeUnit.MILLISECONDS);
                }
            }
        };
        scheduler.schedule(task, 0, TimeUnit.MILLISECONDS);
    }
    
    // 결과에 따른 포인트, 승패 계산
    private List<Map<String, Object>> gameResultAndPointCalc(String roomId, TurtleGameState state) {
        List<TurtlePlayerDTO> players = playerDAO.getAll(roomId);
        GameRoomResponseDTO gameroom = gameRoomService.selectById(roomId);
        String gameName = "Turtle Run";
        String difficulty = gameroom.getLevel();
        int winner = state.getWinner();

        double userRate = 1.0;
        switch(difficulty) {
            case "EASY": userRate = 0.2; break;
            case "NORMAL": userRate = 1.5; break;
            case "HARD": userRate = 4.0; break;
        }
        int winnerTurtle = winner; // 0-based

        int totalBet = players.stream().mapToInt(TurtlePlayerDTO::getBetting_point).sum();
        int winPool = players.stream()
            .filter(p -> p.getTurtle_id() != null && Integer.parseInt(p.getTurtle_id()) - 1 == winnerTurtle)
            .mapToInt(TurtlePlayerDTO::getBetting_point)
            .sum();
        if (winPool == 0) winPool = 1; // 0방지

        // 결과 리스트 준비
        List<Map<String, Object>> results = new ArrayList<>();

        for (TurtlePlayerDTO player : players) {
            int selectedTurtle = player.getTurtle_id() != null ? Integer.parseInt(player.getTurtle_id()) - 1 : -1;
            int userBet = player.getBetting_point();
            int winAmount = 0;
            int pointChange = 0;
            boolean didWin = (selectedTurtle == winnerTurtle);

            if (didWin) {
                winAmount = (int)Math.round(((double)totalBet / winPool) * userBet + userBet * userRate);
                pointChange += winAmount;
            } else {
                winAmount = 0;
                pointChange -= userBet;
            }
            String gameResult = didWin ? "WIN" : "LOSE";
            saveTurtleRunResult(player.getUser_uid(), userBet, winAmount, gameResult, gameName);

            // ✅ 각 플레이어 결과 Map 저장
            Map<String, Object> result = new HashMap<>();
            result.put("user_uid", player.getUser_uid());
            result.put("selectedTurtle", selectedTurtle);
            result.put("didWin", didWin);
            result.put("winAmount", winAmount);
            result.put("pointChange", pointChange);
            results.add(result);
            System.out.println(results);
        }
        return results;
    }
    
	 // DB 저장
    private void saveTurtleRunResult(String userUid, int betAmount, int winAmount, String gameResult, String gameName) {
    	UserVO user = authService.findByUid(userUid);
        if (user != null) {
        	 if ("WIN".equals(gameResult)) {
     	        user.setPoint_balance(user.getPoint_balance() + winAmount);
     	    } else {
     	        // 이미 차감된 상태면 생략, 아니면 아래 라인 활성화
     	         user.setPoint_balance(user.getPoint_balance() - betAmount);
     	    }
     	    loginDAO.updateUserPoint(user);
            // 히스토리/포인트 히스토리 등도 기록
            String gameUid = gameService.selectByName(gameName)
            		.stream().findFirst()
            		.orElseThrow(() -> new IllegalStateException("'" + gameName + "' 게임을 찾을 수 없습니다."))
            		.getUid();
            GameHistoryDTO savedGame = historyService.insertGameHistory(
                gameUid, gameName, betAmount, Math.abs(winAmount - betAmount), gameResult, userUid
            );
            PointHistoryDTO pointHistory = new PointHistoryDTO();
            pointHistory.setGh_uid(savedGame.getUid());
            pointHistory.setType(gameResult);
            pointHistory.setAmount(Math.abs(winAmount - betAmount));
            pointHistory.setBalance_after(user.getPoint_balance());
            historyService.insertPointHistory(pointHistory, userUid);
        }
    }
    
    public TurtleGameState getGameState(String roomId) {
        return gameStates.get(roomId);
    }
    public void removeGame(String roomId) {
        gameStates.remove(roomId);
    }
}