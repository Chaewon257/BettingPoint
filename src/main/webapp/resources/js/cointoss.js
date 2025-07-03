const MAX_POINTS = 1000000000; // 10억

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
  userNickname: null,             // 사용자 ID (DB에서 받아올 예정)
  loading: false            // 로딩 상태
};

// 난이도 설정 - 서버 데이터로 채워질 예정
let difficultyConfigs = {};

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
  setupEventListeners();
  updateUI();
 
  // 그 다음 서버 연결
  initializeGame();
});

function initializeGame() {
  setLoadingState(true);
  fetchUserInfo();
  loadDifficultySettings();
}

function fetchUserInfo() {
  const token = localStorage.getItem('accessToken');
  if (!token) {
    console.warn('accessToken 없음');
    setLoadingState(false);
    return;
  }

  $.ajax({
    url: '/api/user/me',
    method: 'GET',
    headers: {
      Authorization: 'Bearer ' + token
    },
    xhrFields: { withCredentials: true }
  })
  .done(function (user) {
    $('#userNickname').text(user.nickname);
    $('#balance').text(user.point_balance.toLocaleString());
    gameState.balance = user.point_balance;
    gameState.userNickname =  user.nickname; 
    updateUI();
  })
  .fail(function (xhr) {
    if (xhr.status === 401) {
      // 토큰 만료 → 재발급 시도
      $.ajax({
        url: '/api/auth/reissue',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer ' + token
        },
        xhrFields: { withCredentials: true }
      })
      .done(function (res) {
        const newToken = res.accessToken;
        if (!newToken) {
          console.warn('재발급 응답에 accessToken 없음');
          setLoadingState(false);
          return;
        }

        localStorage.setItem('accessToken', newToken);
        // 새 토큰으로 다시 사용자 정보 요청
        return $.ajax({
          url: '/api/user/me',
          method: 'GET',
          headers: {
            'Authorization': 'Bearer ' + newToken
          },
          xhrFields: { withCredentials: true }
        })
        .done(function (user) {
          $('#userNickname').text(user.nickname);
          $('#balance').text(user.point_balance.toLocaleString() + ' P');
          gameState.balance = user.point_balance;
          gameState.userNickname =  user.nickname;
          updateUI();
        })
        .fail(function () {
          console.warn('재시도 실패');
          setLoadingState(false);
        });
      })
      .fail(function () {
        localStorage.removeItem('accessToken');
        console.warn('토큰 재발급 실패 — 로그아웃 처리 필요');
        location.href = '/login';
      });
    } else {
      console.error('사용자 정보 불러오기 실패:', xhr.responseText);
      setLoadingState(false);
    }
  });
}

// 난이도 설정 데이터를 서버에서 불러옴
function loadDifficultySettings() {
  const gameUid = document.getElementById("gameUid").value;
  if (!gameUid) {
    console.warn("gameUid 값이 없습니다. AJAX 호출 중단");
    setLoadingState(false);
    return;
  }
 
  $.ajax({
    url: '/api/game/levels/by-game/' + gameUid,
    type: 'GET',
    dataType: 'json',
    success: function(gameLevels) {
      // 서버 데이터를 difficultyConfigs에 저장
      buildDifficultyConfigs(gameLevels);
     
      // JSP 화면에 난이도 데이터 표시
      updateDifficultyDisplay(gameLevels);
     
      // 로딩 완료
      setLoadingState(false);
     
      // 기본 난이도 선택 (normal이 없으면 첫 번째 난이도)
      setDefaultDifficulty();
    },
    error: function(xhr, status, error) {
      console.error('난이도 로딩 실패:', xhr.responseText);
      showErrorMessage('난이도 정보를 불러올 수 없습니다');
      setLoadingState(false);
    }
  });
}

// 서버 데이터를 difficultyConfigs 객체로 변환 (수정된 버전)
function buildDifficultyConfigs(gameLevels) {
  difficultyConfigs = {};
 
  gameLevels.forEach(function(gameLevel) {  // game -> gameLevel로 명확화
    let difficultyKey;
   
    // DB의 level을 키로 매핑
    if (gameLevel.level === 'HARD') {
      difficultyKey = 'hard';
    } else if (gameLevel.level === 'NORMAL') {
      difficultyKey = 'normal';
    } else if (gameLevel.level === 'EASY') {
      difficultyKey = 'easy';
    }
   
    if (difficultyKey) {
      difficultyConfigs[difficultyKey] = {
        name: gameLevel.level,
        chance: gameLevel.probability / 100,  // 퍼센트를 소수로 변환 (중요!)
        payout: gameLevel.reward / 100
      };
    }
  });

}

// 기본 난이도 선택
function setDefaultDifficulty() {
  // normal이 있으면 선택, 없으면 첫 번째 난이도 선택
  if (difficultyConfigs['normal']) {
    gameState.difficulty = 'normal';
  } else {
    const firstKey = Object.keys(difficultyConfigs)[0];
    if (firstKey) {
      gameState.difficulty = firstKey;
    }
  }
 
  // UI에서 해당 난이도 선택 표시
  document.querySelectorAll(".difficulty-option").forEach((opt) => opt.classList.remove("selected"));
  const defaultOption = document.querySelector(`.difficulty-option[data-difficulty="${gameState.difficulty}"]`);
  if (defaultOption) {
    defaultOption.classList.add("selected");
  }

}

// JSP 화면에 난이도 데이터 표시하는 함수 (수정된 버전)
function updateDifficultyDisplay(gameLevels) {  // gameData -> gameLevels로 명확화
  $.each(gameLevels, function(index, gameLevel) {  // game -> gameLevel로 명확화
    let difficultyKey;
   
    // DB의 level을 JSP의 data-difficulty와 매핑
    if (gameLevel.level === 'HARD') {
      difficultyKey = 'hard';
    } else if (gameLevel.level === 'NORMAL') {
      difficultyKey = 'normal';
    } else if (gameLevel.level === 'EASY') {
      difficultyKey = 'easy';
    }
   
    // 해당 난이도 옵션 찾아서 데이터 업데이트
    const $difficultyOption = $(`.difficulty-option[data-difficulty="${difficultyKey}"]`);
    if ($difficultyOption.length > 0) {
      $difficultyOption.find('.difficulty-chance').text(`성공률: ${gameLevel.probability}%`);
      $difficultyOption.find('.difficulty-payout').text(`${gameLevel.reward/100}배`);
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

// 게임 시작 - 배팅금액만큼 포인트 차감 (Ajax) (수정된 버전)
function startGame(betAmount) {

gameState.gameData = {
  userNickname: gameState.userNickname,
  betAmount: betAmount,
  difficulty: gameState.difficulty
};

  $.ajax({
    url: '/api/game/start',
    method: 'POST',
    contentType: 'application/json',
    headers: {
    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
    },
    data: JSON.stringify({ betAmount: betAmount }),  
    success: function (res) {

      gameState.balance = res.newBalance;
      gameState.currentBet = betAmount;
      gameState.streak = 0;
      gameState.gameActive = true;
      gameState.accumulatedWin = betAmount;

      const config = difficultyConfigs[gameState.difficulty];
      gameState.potentialWin = Math.round(betAmount * config.payout);

      // 시작 버튼 숨기기
      elements.startBtn.classList.add("hidden");

      updateUI();
      showResult(`🎮 게임 시작! (난이도: ${config.name}) 첫 번째 동전을 던집니다!`, "info");
     
      // 첫 번째 동전 던지기 바로 실행
      flipCoin();
    },
    error: function (xhr) {
      console.error("❌ 게임 시작 실패:", xhr.responseText);
      const msg = (xhr.responseJSON && xhr.responseJSON.message) || "게임 시작 실패!";
      startErrorMessage(msg);
    }
  });
}



// STOP 버튼 - 획득포인트 반영 (Ajax)
function stopGame() {
  $.ajax({
    url: '/api/game/stop',
    method: 'POST',
    contentType: 'application/json',
    headers: {
      'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
    },
    data: JSON.stringify({
        betAmount: gameState.currentBet,    
        winAmount: gameState.accumulatedWin,
        difficulty: gameState.difficulty,
        streak: gameState.streak,
        gameResult: "WIN",
        gameName: "CoinToss"
    }),
    success: function (response) {

      gameState.balance = response.newBalance;
      endGame(true, "게임을 멈췄습니다!");
      showResult(`성공! +${gameState.accumulatedWin}포인트 획득! (연속 ${gameState.streak}회 성공)`, "win");
      updateUI();
    },
    error: function (xhr) {
      console.error(' 포인트 저장 실패:', xhr.responseText);
      endGame(true, "게임을 멈췄습니다!");
      showResult(`성공! +${gameState.accumulatedWin}포인트 획득 (서버 저장 실패)`, "win");
    }
  });
}

// 동전 던지기 (수정된 버전)
function flipCoin() {
  gameState.isFlipping = true;
  elements.coin.classList.add("flipping");
  elements.goBtn.disabled = true;
  elements.stopBtn.disabled = true;

  // 선택된 난이도의 설정값 사용
  const difficultyConfig = difficultyConfigs[gameState.difficulty];  // config -> difficultyConfig로 명확화
 
  setTimeout(() => {
    // 이제 chance가 소수(0~1)이므로 올바르게 작동
    const isWin = Math.random() < difficultyConfig.chance;

    elements.coin.classList.remove("coin-heads", "coin-tails");

    if (isWin) {
      elements.coin.classList.add("coin-heads");
      gameState.streak++;
      gameState.accumulatedWin = Math.round(gameState.accumulatedWin * difficultyConfig.payout);
      gameState.potentialWin = Math.round(gameState.accumulatedWin * difficultyConfig.payout);
	  
	  
	  
	   if (gameState.accumulatedWin >=MAX_POINTS) {
        gameState.accumulatedWin = MAX_POINTS;
        gameState.potentialWin = MAX_POINTS;
        
        showResult(`💰 최대 금액 도달! 자동으로 현금화됩니다. (연속 ${gameState.streak}회 성공)`, "win");
        
        // 2초 후 자동 현금화
        setTimeout(() => {
          stopGame();
        }, 2000);
        
        gameState.isFlipping = false;
        elements.coin.classList.remove("flipping");
        updateUI();
        return;
      }
      
      else{
      showResult(`앞면! 연속 ${gameState.streak}회 성공! (난이도: ${difficultyConfig.name}) 다음 성공시 ${gameState.potentialWin}포인트 획득`, "win");
	
	  elements.goBtn.classList.remove("hidden");
      elements.stopBtn.classList.remove("hidden");
     
      elements.goBtn.disabled = false;
      elements.stopBtn.disabled = false;
      }
    }
     else {
       
      elements.coin.classList.add("coin-tails");
     
      sendLoseHistory();

      endGame(false, "뒷면! 게임 오버!");
      showResult(`뒷면이 나왔습니다. (난이도: ${difficultyConfig.name}) 모든 배팅금을 잃었습니다!`, "lose");
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
      const selectedDifficulty = option.dataset.difficulty;
      gameState.difficulty = selectedDifficulty;
     
      // 선택된 난이도 정보 표시
      const difficultyConfig = difficultyConfigs[gameState.difficulty];  // config -> difficultyConfig
      if (difficultyConfig) {
        if (gameState.loading) {
          showResult(`난이도 "${difficultyConfig.name}" 선택됨 (서버 연결 중...)`, "info");
        } else {
          showResult(`난이도 "${difficultyConfig.name}" 선택됨 (성공확률: ${(difficultyConfig.chance * 100)}%, 배당: ${difficultyConfig.payout}배)`, "info");
        }
      } else {
        showResult(`난이도 선택됨 (데이터 로딩 중...)`, "info");
      }
     
      updateUI();
    });
  });

// 배팅 프리셋 버튼 (수정된 버전 - 금액 누적)
 // 배팅 프리셋 버튼 (수정된 버전 - 금액 누적)
document.querySelectorAll(".bet-preset").forEach((btn) => {
  btn.addEventListener("click", () => {
    if (gameState.gameActive || gameState.loading) return;

    const amountStr = btn.dataset.amount;  // 문자열로 먼저 받기
    const currentAmount = parseInt(elements.betAmount.value) || 0;

    if (amountStr === "all") {  // 문자열 비교
      elements.betAmount.value = gameState.balance;
    } else {
      const amount = parseInt(amountStr) || 0;  // 숫자 변환
      const newAmount = currentAmount + amount;

      if (gameState.balance < newAmount) {
        inputErrorMessage("보유포인트 내에서만 배팅이 가능합니다.");
        elements.betAmount.value = 0;  
      } else {
        elements.betAmount.value = newAmount;
      }
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

    if (!betAmount || betAmount <= 0) {
      startErrorMessage("올바른 배팅 금액을 입력해주세요.");
      return;
    }

    if (betAmount > gameState.balance) {
      startErrorMessage("보유포인트가 부족합니다.");
      return;
    }

    // 선택된 난이도 확인
    const difficultyConfig = difficultyConfigs[gameState.difficulty];  // config -> difficultyConfig
    if (!difficultyConfig) {
      startErrorMessage("난이도 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.");
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
  
  // 기존 result-* 클래스들 제거
  elements.resultMessage.classList.remove("result-win", "result-lose", "result-info");
  
  // 타입에 따라 Tailwind 클래스 적용
  if (type === "win") {
    elements.resultMessage.className = "result-message p-0.5 rounded-lg text-center font-bold text-sm sm:text-base bg-green-100 text-green-800 border border-green-300";
  } else if (type === "lose") {
    elements.resultMessage.className = "result-message p-0.5 rounded-lg text-center font-bold text-sm sm:text-base bg-red-100 text-red-600 border border-red-300";
  } else if (type === "info") {
    elements.resultMessage.className = "result-message p-0.5 rounded-lg text-center font-bold text-sm sm:text-base bg-blue-100 text-blue-800 border border-blue-300";
  }
  
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

// 게임 상태 리셋 함수 수정
function resetGameState() {
  // 게임 상태 초기화
  gameState.currentBet = 0;
  gameState.streak = 0;
  gameState.isFlipping = false;
  gameState.gameActive = false;
  gameState.potentialWin = 0;
  gameState.accumulatedWin = 0;
 
  // 버튼 상태 초기화
  elements.goBtn.classList.add("hidden");
  elements.stopBtn.classList.add("hidden");
  elements.startBtn.classList.remove("hidden");
  elements.startBtn.textContent = "게임 시작";
 
  // 버튼 활성화 상태 초기화 (중요!)
  elements.goBtn.disabled = false;
  elements.stopBtn.disabled = false;
  elements.startBtn.disabled = false;
 
  // 입력 필드 초기화
  elements.betAmount.value = "";
 
  // 동전 상태 초기화
  elements.coin.classList.remove("heads", "tails", "flipping");
  elements.coin.classList.add("heads");
 
  // 메시지 초기화
  elements.resultMessage.style.display = "none";
  elements.inputErrorMessage.style.display = "none";
  elements.startErrorMessage.style.display = "none";
 
  updateUI();
}


function sendLoseHistory() {
  $.ajax({
    url: '/api/game/lose',
    method: 'POST',
    contentType: 'application/json',
    headers: {
      Authorization: 'Bearer ' + localStorage.getItem('accessToken')
    },
    data: JSON.stringify({
      betAmount: gameState.currentBet,
      winAmount: 0,
      difficulty: gameState.difficulty,
      streak: gameState.streak,
      gameResult: "LOSE",
      gameName: "CoinToss"
    }),
    success: function (res) {
    },
    error: function (xhr) {
      console.error(" 패배 히스토리 저장 실패:", xhr.responseText);
    }
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