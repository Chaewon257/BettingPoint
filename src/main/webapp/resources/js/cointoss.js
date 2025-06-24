// 게임상태(객체)
let gameState = {
  balance: 0,               //  사용자 보유 포인트 (DB에서 받아올 예정)
  currentBet: 0,            // 현재 배팅 금액
  difficulty: "normal",     // 디폴트 난이도(중)
  streak: 0,                // 연속 성공횟수
  isFlipping: false,        // 동전 돌고있는지 상태
  gameActive: false,        // 개임진행 상태
  potentialWin: 0,          // 예상획득 포인트
  accumulatedWin: 0,        // 누적 획득 포인트
  userId: null,             // 사용자 ID (DB에서 받아올 예정)
  loading: false            // 로딩 상태
};

// 난이도 설정
 let difficultyConfigs = {
 };



// HTML 요소들
const elements = {
  balance: document.getElementById("balance"),
  betAmount: document.getElementById("bet-amount"),
  currentBet: document.getElementById("current-bet"),
  streak: document.getElementById("streak"),
  potentialWin: document.getElementById("potential-win"),
  coin: document.getElementById("coin"),
  resultMessage: document.getElementById("result-message"),
  startBtn: document.getElementById("start-btn"),
  goBtn: document.getElementById("go-btn"),
  stopBtn: document.getElementById("stop-btn"),
  inputErrorMessage: document.getElementById("input-error"),
  startErrorMessage: document.getElementById("start-error-message")
};

// 페이지 로드 시 초기 데이터 가져오기
document.addEventListener('DOMContentLoaded', function() {
  // 먼저 기본 UI 설정 (연결 전에도 난이도 선택 가능)
  updateDifficultyUI();
  setupEventListeners();
  updateUI();
  
  // 그 다음 서버 연결
  initializeGame();
});


// 게임 초기화 함수
function initializeGame() {
  setLoadingState(true);
  
  // 1. 사용자 보유포인트 가져오기 (Ajax)
  $.get('/api/user/balance')
    .done(function(response) {
      gameState.userId = response.userId;
      gameState.balance = response.balance;
      
      // 2. 난이도 설정 가져오기 (Ajax)
      loadDifficultySettings();
    })
    .fail(function(xhr) {
      showErrorMessage('사용자 정보를 불러올 수 없습니다: ' + xhr.status);
      setLoadingState(false);
    });
}

function loadDifficultySettings() {
    $.ajax({
        url: '/api/game/by-name/CoinToss',
        type: 'GET',
        dataType: 'json',
        success: function(gameData) {
            console.log('게임 데이터:', gameData);
            
            // 기존 difficultyConfigs 설정
            $.each(gameData, function(index, game) {
                difficultyConfigs[game.level] = {
                    chance: game.probability,
                    payout: game.reward
                };
            });
           
            // JSP 화면에 데이터 표시
            updateDifficultyDisplay(gameData);
            
            updateDifficultyUI();
            updateUI();
            setLoadingState(false);
            
            const config = difficultyConfigs[gameState.difficulty];
          
        },
        error: function(xhr, status, error) {
            console.error('게임 설정 로딩 실패:', error);
            updateDifficultyUI();
            updateUI();
            setLoadingState(false);
        }
    });
}

// JSP 화면에 난이도 데이터 표시하는 함수
function updateDifficultyDisplay(gameData) {
    
    $.each(gameData, function(index, game) {
        let difficultyKey;
        
        // DB의 level을 JSP의 data-difficulty와 매핑
        if (game.level === 'HARD') {
            difficultyKey = 'hard';
        } else if (game.level === 'MEDIUM') {
            difficultyKey = 'normal'; // JSP에서는 normal로 되어있음
        } else if (game.level === 'EASY') {
            difficultyKey = 'easy';
        }
        
        // 해당 난이도 옵션 찾아서 데이터 업데이트
        const $difficultyOption = $(`.difficulty-option[data-difficulty="${difficultyKey}"]`);
        if ($difficultyOption.length > 0) {
            $difficultyOption.find('.difficulty-chance').text(`성공률: ${game.probability}%`);
            $difficultyOption.find('.difficulty-payout').text(`배당: ${game.reward}배`);
        }
    });
}



// 난이도 UI 업데이트
function updateDifficultyUI() {
  document.querySelectorAll('.difficulty-option').forEach(option => {
    const difficulty = option.dataset.difficulty;
    const config = difficultyConfigs[difficulty];
    
    if (config) {
      option.querySelector('.difficulty-name').textContent = config.name;
      option.querySelector('.difficulty-chance').textContent = `${Math.round(config.chance * 100)}% 확률`;
      option.querySelector('.difficulty-payout').textContent = `성공시 ${config.payout}배 획득`;
    }
  });
}

// 로딩 상태 설정
function setLoadingState(loading) {
  gameState.loading = loading;
  
  if (loading) {
    elements.startBtn.disabled = true;
    elements.startBtn.textContent = '로딩 중...';
  } else {
    elements.startBtn.disabled = false;
    elements.startBtn.textContent = gameState.gameActive ? '다시 시작' : '게임 시작';
  }
}

// 게임 시작 - 배팅금액만큼 포인트 차감 (Ajax)
function startGame(betAmount) {
  const gameData = {
    userId: gameState.userId,
    betAmount: betAmount,
    difficulty: gameState.difficulty  // 선택된 난이도 전송
  };
  
  $.post('/api/game/start', gameData)
    .done(function(response) {
      // 서버에서 포인트 차감 후 새로운 잔액 받아오기
      gameState.balance = response.newBalance;
      gameState.currentBet = betAmount;
      gameState.streak = 0;
      gameState.gameActive = true;
      gameState.accumulatedWin = betAmount;
      gameState.potentialWin = Math.round(betAmount * difficultyConfigs[gameState.difficulty].payout);

      elements.startBtn.classList.add("hidden");
      elements.goBtn.classList.remove("hidden");
      elements.stopBtn.classList.remove("hidden");

      updateUI();
      showResult(`게임이 시작되었습니다! (난이도: ${difficultyConfigs[gameState.difficulty].name}) GO 버튼을 눌러 동전을 던지세요.`, "info");
    })
    .fail(function(xhr) {
      const errorMsg = xhr.responseJSON ? xhr.responseJSON.message : '게임 시작 실패';
      startErrorMessage(errorMsg);
    });
}

// STOP 버튼 - 획득포인트 반영 (Ajax)
function stopGame() {
  const gameData = {
    userId: gameState.userId,
    winAmount: gameState.accumulatedWin,
    difficulty: gameState.difficulty,  // 난이도 정보 전송
    streak: gameState.streak           // 연속 성공 횟수 전송
  };
  
  $.post('/api/game/stop', gameData)
    .done(function(response) {
      // 서버에서 포인트 추가 후 새로운 잔액 받아오기
      gameState.balance = response.newBalance;
      
      endGame(true, "게임을 멈췄습니다!");
      showResult(`성공! +${gameState.accumulatedWin}포인트 획득! (연속 ${gameState.streak}회 성공)`, "win");
      updateUI();
    })
    .fail(function(xhr) {
      console.error('포인트 저장 실패:', xhr.status);
      // 실패해도 게임은 종료 (클라이언트에서 처리)
      endGame(true, "게임을 멈췄습니다!");
      showResult(`성공! +${gameState.accumulatedWin}포인트 획득 (서버 저장 실패)`, "win");
    });
}

// 동전 던지기 (선택된 난이도 반영)
function flipCoin() {
  gameState.isFlipping = true;
  elements.coin.classList.add("flipping");
  elements.goBtn.disabled = true;
  elements.stopBtn.disabled = true;

  // 선택된 난이도의 설정값 사용
  const config = difficultyConfigs[gameState.difficulty];
  
  setTimeout(() => {
    const isWin = Math.random() < config.chance;

    elements.coin.classList.remove("heads", "tails");

    if (isWin) {
      elements.coin.classList.add("heads");
      gameState.streak++;
      gameState.accumulatedWin = Math.round(gameState.accumulatedWin * config.payout);
      gameState.potentialWin = Math.round(gameState.accumulatedWin * config.payout);

      showResult(`앞면! 연속 ${gameState.streak}회 성공! (난이도: ${config.name}) 다음 성공시 ${gameState.potentialWin}포인트 획득`, "win");

      elements.goBtn.disabled = false;
      elements.stopBtn.disabled = false;
    } else {
      elements.coin.classList.add("tails");
      
      endGame(false, "뒷면! 게임 오버!");
      showResult(`뒷면이 나왔습니다. (난이도: ${config.name}) 모든 배팅금을 잃었습니다!`, "lose");
    }

    gameState.isFlipping = false;
    elements.coin.classList.remove("flipping");
    updateUI();
  }, 2000);
}

// 에러 메시지 표시
function showErrorMessage(message) {
  elements.startErrorMessage.innerHTML = message;
  elements.startErrorMessage.style.display = "block";
  
  setTimeout(() => {
    elements.startErrorMessage.style.display = "none";
  }, 5000);
}

// 이벤트 리스너 설정 (별도 함수로 분리)
function setupEventListeners() {
  // 난이도 선택
  document.querySelectorAll(".difficulty-option").forEach((option) => {
    option.addEventListener("click", () => {
      // 게임 진행 중일 때만 난이도 변경 불가 (로딩 중에는 변경 가능)
      if (gameState.gameActive) {
        showResult("게임 진행 중에는 난이도를 변경할 수 없습니다.", "info");
        return;
      }

      // 기존 선택 제거
      document.querySelectorAll(".difficulty-option")
        .forEach((opt) => opt.classList.remove("selected"));
      
      // 새로운 선택 추가
      option.classList.add("selected");
      gameState.difficulty = option.dataset.difficulty;
      
      // 선택된 난이도 정보 표시
      const config = difficultyConfigs[gameState.difficulty];
      if (gameState.loading) {
        showResult(`난이도 "${config.name}" 선택됨 (서버 연결 중...)`, "info");
      } else {
        showResult(`난이도 "${config.name}" 선택됨 (성공확률: ${Math.round(config.chance * 100)}%, 배당: ${config.payout}배)`, "info");
      }
      
      updateUI();
    });
  });

  // 배팅 프리셋 버튼
  document.querySelectorAll(".bet-preset").forEach((btn) => {
    btn.addEventListener("click", () => {
      if (gameState.gameActive || gameState.loading) return;

      const amount = btn.dataset.amount;
      
      if (amount === "all") {
        elements.betAmount.value = gameState.balance;
      } else if (gameState.balance < amount) {
        inputErrorMessage("보유포인트 내에서만 배팅이 가능합니다.");
        elements.betAmount.value = 0;
      } else {
        elements.betAmount.value = amount;
      }

      updateUI();
    });
  });

  // 배팅 금액 입력
  elements.betAmount.addEventListener("input", () => {
    const amount = parseInt(elements.betAmount.value) || 0;
    
    if (gameState.balance < amount) {
      inputErrorMessage("보유포인트 내에서만 배팅이 가능합니다.");
      elements.betAmount.value = 0;
    }
      
    updateUI();
  });

  // 게임 시작 버튼
  elements.startBtn.addEventListener("click", () => {
    if (gameState.loading) return;
    
    if (elements.startBtn.textContent === "다시 시작") {
      resetGameState();
      return;
    }
    
    const betAmount = parseInt(elements.betAmount.value) || 0;

    if (!betAmount > 0) {
      startErrorMessage("올바른 배팅 금액을 입력해주세요.");
      return;
    }

    if (betAmount > gameState.balance) {
      startErrorMessage("보유포인트가 부족합니다.");
      return;
    }

    // 선택된 난이도 확인
    const config = difficultyConfigs[gameState.difficulty];
    if (!config) {
      startErrorMessage("난이도를 선택해주세요.");
      return;
    }

    // Ajax로 서버에 배팅금액 차감 요청 (선택된 난이도 포함)
    startGame(betAmount);
  });

  // GO 버튼
  elements.goBtn.addEventListener("click", () => {
    if (!gameState.isFlipping && gameState.gameActive && !gameState.loading) {
      flipCoin(); // 선택된 난이도로 처리
    }
  });

  // STOP 버튼
  elements.stopBtn.addEventListener("click", () => {
    if (gameState.gameActive && !gameState.isFlipping && !gameState.loading) {
      stopGame(); // Ajax로 서버에 포인트 추가 요청
    }
  });
}
// 게임 종료
function endGame(won, message) {
  gameState.gameActive = false;
  elements.goBtn.classList.add("hidden");
  elements.stopBtn.classList.add("hidden");
  elements.startBtn.classList.remove("hidden");
  elements.startBtn.textContent = "다시 시작";
  
  setTimeout(() => {
    elements.coin.classList.remove("heads", "tails");
    elements.coin.classList.add("heads");
  }, 2000);
}

function showResult(message, type) {
  elements.resultMessage.innerHTML = message;
  elements.resultMessage.className = `result-message result-${type}`;
  elements.resultMessage.style.display = "block";
}

function inputErrorMessage(message) {
  elements.inputErrorMessage.innerHTML = message;
  elements.inputErrorMessage.style.display = "block";
  
  setTimeout(() => {
    elements.inputErrorMessage.style.display = "none";
  }, 3000);
}

function startErrorMessage(message) {
  elements.startErrorMessage.innerHTML = message;
  elements.startErrorMessage.style.display = "block";
  
  setTimeout(() => {
    elements.startErrorMessage.style.display = "none";
  }, 3000);
}

function resetGameState() {
  gameState.currentBet = 0;
  gameState.streak = 0;
  gameState.isFlipping = false;
  gameState.gameActive = false;
  gameState.potentialWin = 0;
  gameState.accumulatedWin = 0;
  
  elements.goBtn.classList.add("hidden");
  elements.stopBtn.classList.add("hidden");
  elements.startBtn.classList.remove("hidden");
  elements.startBtn.textContent = "게임 시작";
  elements.betAmount.value = "";
  
  elements.coin.classList.remove("heads", "tails", "flipping");
  elements.coin.classList.add("heads");
  elements.resultMessage.style.display = "none";
  
  // 현재 포인트 다시 불러오기 (Ajax)
  $.get('/api/user/balance')
    .done(function(response) {
      gameState.balance = response.balance;
      updateUI();
    })
    .fail(function(xhr) {
      console.error('포인트 새로고침 실패:', xhr.status);
    });
}

function updateUI() {
  elements.balance.textContent = gameState.balance.toLocaleString();
  elements.currentBet.textContent = gameState.currentBet.toLocaleString();
  elements.streak.textContent = gameState.streak;
  
  elements.potentialWin.textContent = gameState.gameActive  
    ? gameState.accumulatedWin.toLocaleString()  
    : "0";
}


$(document).ready(function() {
    loadDifficultySettings();
});