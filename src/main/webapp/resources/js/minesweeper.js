let gameState = {
  balance: 0,
  currentBet: 0,
  difficulty: "normal",
  gemsFound: 0,
  potentialWin: 0,
  gameActive: false,
  userNickname: null,
  loading: false,
};

document.addEventListener("DOMContentLoaded", () => {
  const TOTAL_TILES = 25;
  const gameBoard = document.getElementById("gameBoard");

  function createGameBoard() {
    gameBoard.innerHTML = "";
    for (let i = 0; i < TOTAL_TILES; i++) {
      const tile = document.createElement("button");
      tile.className = "tile";
      tile.textContent = ""; // 내용 없음
      tile.dataset.index = i;
      tile.addEventListener("click", () => {
        tile.classList.add("revealed");
        tile.textContent = "💎"; // 임시
      });
      gameBoard.appendChild(tile);
    }
  }

  // 초기 보드 생성
  createGameBoard();

  // 게임 시작 버튼 클릭 시 보드 재생성
  document.getElementById("start-btn").addEventListener("click", () => {
    createGameBoard();
    document.getElementById("result-message").textContent = "게임을 시작합니다!";
    document.getElementById("result-message").classList.remove("hidden");
  });

  // 리셋 버튼
  document.getElementById("reset-btn").addEventListener("click", () => {
    createGameBoard();
    document.getElementById("result-message").textContent = "리셋되었습니다.";
    document.getElementById("result-message").classList.remove("hidden");
  });
});
