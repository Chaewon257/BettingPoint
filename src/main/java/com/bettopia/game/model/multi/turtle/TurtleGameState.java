package com.bettopia.game.model.multi.turtle;

public class TurtleGameState {
    private final int turtleCount;
    private final double[] positions;       // 각 거북이 위치(0~100)
    private final double[] baseSpeeds;      // 기본 속도
    private final double[] burstChances;    // 버스트 확률
    private boolean finished = false;       // 레이스 종료 여부
    private int winner = -1;                // 우승자(0~n-1)
    private String status = "WAITING";      // WAITING, RUNNING, FINISHED

    public TurtleGameState(int turtleCount) {
        this.turtleCount = turtleCount;
        this.positions = new double[turtleCount];
        this.baseSpeeds = new double[turtleCount];
        this.burstChances = new double[turtleCount];
        for (int i = 0; i < turtleCount; i++) {
            baseSpeeds[i] = 0.07 + Math.random() * 0.03;
            burstChances[i] = Math.random() * 0.3;
        }
    }
    // 레이스 한 프레임 진행
    public void updateRace() {
        if (finished) return;
        for (int i = 0; i < turtleCount; i++) {
            if (positions[i] < 100) {
                double burst = Math.random() < burstChances[i] ? 0.03 + Math.random() * 0.05 : 0;
                double variation = (Math.random() - 0.15) * 0.1;
                double move = baseSpeeds[i] + variation + burst;
                positions[i] += move;
                if (positions[i] >= 100) {
                    positions[i] = 100;
                    winner = i;
                    finished = true;
                    status = "FINISHED";
                    positions[i] = 103;
                }
            }
        }
    }
    // getter
    public double[] getPositions() { return positions; }
    public boolean isFinished() { return finished; }
    public int getWinner() { return winner; }
    public String getStatus() { return status; }
    public int getTurtleCount() { return turtleCount; }
}
