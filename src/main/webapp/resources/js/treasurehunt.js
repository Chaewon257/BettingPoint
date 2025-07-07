// 1. 개발자 도구 열림 감지
let devtools = { open: false };
const threshold = 160;

function detectDevTools() {
  if (window.outerHeight - window.innerHeight > threshold || 
      window.outerWidth - window.innerWidth > threshold) {
    if (!devtools.open) {
      devtools.open = true;
      console.log(1);
      handleDevToolsOpen();
    }
  } else {
    devtools.open = false;
  }
}

// 2. debugger 감지
function detectDebugger() {
  const start = performance.now();
  debugger;
  const end = performance.now();

  if (end - start > 100) {
    handleDevToolsOpen();
  }
}

// 개발자 도구 감지 시 처리
function handleDevToolsOpen() {
  alert('개발자 도구 사용이 감지되었습니다.\n개발자 모드를 끄려면 f12를 눌러주세요.\n게임의 공정성을 위해 페이지를 새로고침합니다.');
  location.reload();
}

//  감지 루프 실행
setInterval(() => {
  detectDevTools();
  detectDebugger();
}, 1000);

// 6. 우클릭 방지
document.addEventListener('contextmenu', e => e.preventDefault());

// 7. 키보드 단축키 방지
document.addEventListener('keydown', function(e) {
  const blocked = [
    123, // F12
    [17, 73], // Ctrl+Shift+I
    [17, 67], // Ctrl+Shift+C
    [17, 74], // Ctrl+Shift+J
    [17, 85], // Ctrl+U
    [17, 65], // Ctrl+A
    [17, 83], // Ctrl+S
    [17, 67]  // Ctrl+C
  ];

  for (const combo of blocked) {
    if (Array.isArray(combo)) {
      if (e.ctrlKey && e.keyCode === combo[1]) {
        e.preventDefault();
        return false;
      }
    } else if (e.keyCode === combo) {
      e.preventDefault();
      return false;
    }
  }
});

// 8. 콘솔 함수 무력화
(() => {
  const noop = () => {};
  ['log', 'warn', 'error', 'info', 'debug', 'dir', 'dirxml', 'table', 'trace', 'group', 'groupEnd'].forEach(fn => {
    console[fn] = noop;
  });
  console.clear = () => { console.log('%c ', 'font-size: 1px;'); };
})();

// 9. debugger 문 무력화 루프
setInterval(() => {
  (function() { return false; })();
}, 100);

// 10. 민감 변수 접근 차단
['gameState', 'difficultyConfigs'].forEach(prop => {
  Object.defineProperty(window, prop, {
    get: function() {
      location.reload();
    },
    configurable: false
  });
});

// 11. 텍스트 선택, 드래그, 복사 방지
['selectstart', 'dragstart'].forEach(evt =>
  document.addEventListener(evt, e => e.preventDefault())
);

const MAX_POINTS = 1000000000; // 10억

// 게임상태(객체)
let gameState = {
  balance: 0,               // 사용자 보유 포인트 (DB에서 받아올 예정)
  currentBet: 0,            // 현재 배팅 금액
  difficulty: "normal",     // 디폴트 난이도(중)
  gemsFound: 0,             // 발견한 보석 수
  gameActive: false,        // 게임진행 상태
  potentialWin: 0,          // 예상획득 포인트 (다음 성공시)
  accumulatedWin: 0,        // 누적 획득 포인트 (현재까지)
  userNickname: null,       // 사용자 닉네임 (DB에서 받아올 예정)
  loading: false,           // 로딩 상태
  board: [],                // 게임 보드 상태
  minePositions: [],        // 지뢰 위치
  revealedTiles: []         // 공개된 타일들
};

// 난이도 설정 - 서버 데이터로 채워질 예정
let difficultyConfigs = {};

// HTML 요소들
const elements = {
  balance: document.getElementById("balance"),
  betAmount: document.getElementById("bet-amount"),
  currentBet: document.getElementById("current-bet"),
  gemsFound: document.getElementById("gems-found"),
  potentialWin: document.getElementById("potential-win"),
  gameBoard: document.getElementById("gameBoard"),
  resultMessage: document.getElementById("result-message"),
  startBtn: document.getElementById("start-btn"),
  stopBtn: document.getElementById("stop-btn"),
  inputErrorMessage: document.getElementById("input-error"),
  startErrorMessage: document.getElementById("start-error-message"),
  userNickname: document.getElementById("userNickname")
};

// 페이지 로드 시 초기 데이터 가져오기
document.addEventListener('DOMContentLoaded', function() {
  setupEventListeners();
  createGameBoard();
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
    elements.userNickname.textContent = user.nickname;
    elements.balance.textContent = user.point_balance.toLocaleString();
    gameState.balance = user.point_balance;
    gameState.userNickname = user.nickname; 
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
          elements.userNickname.textContent = user.nickname;
          elements.balance.textContent = user.point_balance.toLocaleString() + ' P';
          gameState.balance = user.point_balance;
          gameState.userNickname = user.nickname;
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

// 서버 데이터를 difficultyConfigs 객체로 변환
function buildDifficultyConfigs(gameLevels) {
  difficultyConfigs = {};
 
  gameLevels.forEach(function(gameLevel) {
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
        chance: gameLevel.probability / 100,  // 퍼센트를 소수로 변환
        payout: gameLevel.reward / 100,
        mineCount: Math.round(25 * (1 - gameLevel.probability / 100))
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

// JSP 화면에 난이도 데이터 표시하는 함수
function updateDifficultyDisplay(gameLevels) {
  $.each(gameLevels, function(index, gameLevel) {
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
      const mineCount = Math.round(25 * (1 - gameLevel.probability / 100)); 
      $difficultyOption.find('.difficulty-chance').text(`지뢰 ${mineCount}개`);
      $difficultyOption.find('.difficulty-payout').text(`${gameLevel.reward / 100}배`);
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

// 게임 타일 생성
function createGameBoard() {
  const TOTAL_TILES = 25;
  elements.gameBoard.innerHTML = "";
  
  for (let i = 0; i < TOTAL_TILES; i++) {
    const tile = document.createElement("button");
    tile.className = `
      aspect-square w-full 
      bg-white 
      border border-blue-300 sm:border-2 
      rounded-md sm:rounded-lg 
      flex items-center justify-center 
      text-xs sm:text-sm md:text-base 
      font-bold 
      cursor-pointer 
      transition-all duration-300 
      hover:bg-blue-50 
      focus:outline-none focus:ring-2 focus:ring-blue-400
    `.replace(/\s+/g, ' ').trim();
    
    tile.textContent = "";
    tile.dataset.index = i;
    tile.addEventListener("click", () => handleTileClick(i));
    elements.gameBoard.appendChild(tile);
  }
  
  // 게임 상태 초기화
  gameState.board = new Array(TOTAL_TILES).fill(false);
  gameState.revealedTiles = new Array(TOTAL_TILES).fill(false);
}

// 타일 클릭 처리
function handleTileClick(index) {
  if (!gameState.gameActive || gameState.revealedTiles[index] || gameState.loading) {
    return;
  }
  
  const tile = elements.gameBoard.children[index];
  
  // 지뢰인지 확인
  if (gameState.minePositions.includes(index)) {
    // 지뢰 터짐
    tile.classList.add("revealed", "mine");
    tile.textContent = "💣";
    tile.style.backgroundColor = "#ef4444";
    
    gameOver(false);
  } else {
    // 보석 발견
    tile.classList.add("revealed", "gem");
    tile.textContent = "💎";
    tile.style.backgroundColor = "#22c55e";
    
    gameState.revealedTiles[index] = true;
    gameState.gemsFound++;
    
    // 획득 포인트 계산 (코인토스와 같은 방식)
    const difficultyConfig = difficultyConfigs[gameState.difficulty];
    gameState.accumulatedWin = Math.round(gameState.currentBet * Math.pow(difficultyConfig.payout, gameState.gemsFound));
    gameState.potentialWin = Math.round(gameState.accumulatedWin * difficultyConfig.payout);

    // 10억 초과 체크
    if (gameState.accumulatedWin >= MAX_POINTS) {
      gameState.accumulatedWin = MAX_POINTS;
      gameState.potentialWin = MAX_POINTS;
      updateUI();
      showResult(`💎 최대 금액 도달! 자동으로 현금화됩니다. (${gameState.gemsFound}개 발견)`, "win");
      
      setTimeout(() => {
        stopGame();
      }, 2000);
      
      return;
    } else {
      updateUI();
      showResult(`💎 보석 발견! 연속 ${gameState.gemsFound}개! 다음 성공시 ${gameState.potentialWin.toLocaleString()}포인트 획득`, "win");
      
      // 현재 난이도의 전체 보석 수 계산
      const totalGems = 25 - difficultyConfigs[gameState.difficulty].mineCount;

      // 보석 다 찾았을 경우 자동 종료 처리
      if (gameState.gemsFound >= totalGems) {
        stopGame();  // 자동으로 현금화
      }
      
      // 현금화 버튼 표시
      elements.stopBtn.classList.remove("hidden");
    }
  }
}

// 게임 시작
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
      gameState.gemsFound = 0;
      gameState.gameActive = true;
      gameState.accumulatedWin = 0;  // 초기값 0으로 설정
      gameState.potentialWin = Math.round(betAmount * difficultyConfigs[gameState.difficulty].payout);

      // 지뢰 위치 설정
      const difficultyConfig = difficultyConfigs[gameState.difficulty];
      setMinePositions(difficultyConfig.mineCount);

      // 게임 보드 초기화
      createGameBoard();

      // 시작 버튼 숨기기, 현금화 버튼 숨기기
      elements.startBtn.classList.add("hidden");
      elements.stopBtn.classList.add("hidden");

      updateUI();
      showResult(`게임 시작! (난이도: ${difficultyConfig.name}) 타일을 클릭해서 보석을 찾으세요!`, "info");
    },
    error: function (xhr) {
      console.error("게임 시작 실패:", xhr.responseText);
      const msg = (xhr.responseJSON && xhr.responseJSON.message) || "게임 시작 실패!";
      startErrorMessage(msg);
    }
  });
}

// 지뢰 위치 설정
function setMinePositions(mineCount) {
  gameState.minePositions = [];  //초기화
  const totalTiles = 25;
  
  while (gameState.minePositions.length < mineCount) {
    const randomIndex = Math.floor(Math.random() * totalTiles);
    if (!gameState.minePositions.includes(randomIndex)) {
      gameState.minePositions.push(randomIndex);
    }
  }
}

// 현금화
function stopGame() {
  // 10억 초과 시 10억으로 제한
  if (gameState.accumulatedWin >= MAX_POINTS) {
    gameState.accumulatedWin = MAX_POINTS;
    showResult(`포인트가 최대값(10억)으로 제한되어 현금화됩니다.`, "info");
  }
  
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
      streak: gameState.gemsFound,
      gameResult: "WIN",
      gameName: "TreasureHunt"
    }),
    success: function (response) {
      gameState.balance = response.newBalance;
      endGame(true, "포인트 get 성공!");
      showResult(`성공! +${gameState.accumulatedWin.toLocaleString()}포인트 획득! (보석 ${gameState.gemsFound}개 발견)`, "win");
      updateUI();
    },
    error: function (xhr) {
      console.error('포인트 저장 실패:', xhr.responseText);
      endGame(true, "포인트 get 성공!");
      showResult(`성공! +${gameState.accumulatedWin.toLocaleString()}포인트 획득 (서버 저장 실패)`, "win");
    }
  });
}

// 게임 오버
function gameOver(won) {
  if (!won) {
    // 모든 지뢰 위치 표시
    gameState.minePositions.forEach(index => {
      const tile = elements.gameBoard.children[index];
      if (!tile.classList.contains("revealed")) {
        tile.textContent = "💣";
        tile.style.backgroundColor = "#fca5a5";
      }
    });
    
    sendLoseHistory();
    showResult(`💣 지뢰 발견! 게임 오버! 모든 배팅금을 잃었습니다.`, "lose");
  }
  
  endGame(won, won ? "게임 승리!" : "게임 오버!");
}

// 패배 기록 전송
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
      streak: gameState.gemsFound,
      gameResult: "LOSE",
      gameName: "TreasureHunt"
    }),
    success: function (res) {
      console.log("패배 기록 저장 완료");
    },
    error: function (xhr) {
      console.error("패배 히스토리 저장 실패:", xhr.responseText);
    }
  });
}

// 게임 종료
function endGame(won, message) {
  gameState.gameActive = false;
  elements.stopBtn.classList.add("hidden");
  elements.startBtn.classList.remove("hidden");
  elements.startBtn.textContent = "다시 시작";
}

// 이벤트 리스너 설정
function setupEventListeners() {
  // 난이도 선택
  document.querySelectorAll(".difficulty-option").forEach((option) => {
    option.addEventListener("click", () => {
      if (gameState.gameActive) {
        showResult("게임 진행 중에는 난이도를 변경할 수 없습니다.", "info");
        return;
      }

      document.querySelectorAll(".difficulty-option")
        .forEach((opt) => opt.classList.remove("selected"));
     
      option.classList.add("selected");
      const selectedDifficulty = option.dataset.difficulty;
      gameState.difficulty = selectedDifficulty;
     
      const difficultyConfig = difficultyConfigs[gameState.difficulty];
      if (difficultyConfig) {
        if (gameState.loading) {
          showResult(`난이도 "${difficultyConfig.name}" 선택됨 (서버 연결 중...)`, "info");
        } else {
          showResult(`난이도 "${difficultyConfig.name}" 선택됨 (지뢰 ${difficultyConfig.mineCount}개, 배당: ${difficultyConfig.payout}배)`, "info");
        }
      } else {
        showResult(`난이도 선택됨 (데이터 로딩 중...)`, "info");
      }
     
      updateUI();
    });
  });

  // 배팅 프리셋 버튼 (수정된 버전 - 금액 누적)
  document.querySelectorAll(".bet-preset").forEach((btn) => {
    btn.addEventListener("click", () => {
      if (gameState.gameActive || gameState.loading) return;

      const amountStr = btn.dataset.amount;  
      const currentAmount = parseInt(elements.betAmount.value.replace(/,/g, '')) || 0; 

      if (amountStr === "all") {  // 문자열 비교
        elements.betAmount.value = gameState.balance.toLocaleString();
      } else {
        const amount = parseInt(amountStr) || 0;  // 숫자 변환
        const newAmount = currentAmount + amount;

        if (gameState.balance < newAmount) {
          inputErrorMessage("보유포인트 내에서만 배팅이 가능합니다.");
          elements.betAmount.value = 0;  
        } else {
          elements.betAmount.value = newAmount.toLocaleString();
        }
      }
      updateUI();
    });
  });

  // 배팅 금액 입력
  elements.betAmount.addEventListener("input", (e) => {
    let value = e.target.value.replace(/[^0-9]/g, '');
    const amount = parseInt(value) || 0;
   
    if (gameState.balance < amount) {
      inputErrorMessage("보유포인트 내에서만 배팅이 가능합니다.");
      elements.betAmount.value = 0;
    }else if (amount > 0 && amount < 100) {
    inputErrorMessage("최소배팅금액은 100포인트입니다.");
    elements.betAmount.value = amount.toLocaleString();
  	}
     else {
      elements.betAmount.value = amount > 0 ? amount.toLocaleString() : '';
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
   
    const betAmount = parseInt(elements.betAmount.value.replace(/,/g, '')) || 0;

    if (!betAmount || betAmount <= 0) {
      startErrorMessage("올바른 배팅 금액을 입력해주세요.");
      return;
    }
    
     if (betAmount < 100) {
    startErrorMessage("최소배팅금액은 100포인트입니다. 최소배팅보다 큰 포인트를 입력해주세요.");
    return;
    }
    
    
    if (betAmount > gameState.balance) {
      startErrorMessage("보유포인트가 부족합니다.");
      return;
    }

    const difficultyConfig = difficultyConfigs[gameState.difficulty];
    if (!difficultyConfig) {
      startErrorMessage("난이도 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.");
      return;
    }

    startGame(betAmount);
  });

  // stop 버튼
  elements.stopBtn.addEventListener("click", () => {
    if (gameState.gameActive && !gameState.loading) {
      stopGame();
    }
  });
}

// UI 업데이트
function updateUI() {
  elements.balance.textContent = gameState.balance.toLocaleString();
  elements.currentBet.textContent = gameState.currentBet.toLocaleString();
  elements.gemsFound.textContent = gameState.gemsFound;
  // 코인토스처럼 현재 누적 획득 포인트 표시
  elements.potentialWin.textContent = gameState.gameActive  
    ? gameState.accumulatedWin.toLocaleString()  
    : "0";
}

// 결과 메시지 표시
function showResult(message, type) {
  elements.resultMessage.innerHTML = message;
  
  // 기존 result-* 클래스들 제거
  elements.resultMessage.classList.remove("result-win", "result-lose", "result-info");
  
  // 타입에 따라 Tailwind 클래스 적용
  if (type === "win") {
    elements.resultMessage.className = "result-message  p-0.5 mt-3 rounded-lg text-center font-bold text-sm sm:text-base bg-green-100 text-green-800 border border-green-300";
  } else if (type === "lose") {
    elements.resultMessage.className = "result-message p-0.5 mt-3 rounded-lg text-center font-bold text-sm sm:text-base bg-red-100 text-red-600 border border-red-300";
  } else if (type === "info") {
    elements.resultMessage.className = "result-message p-0.5 mt-3 rounded-lg text-center font-bold text-sm sm:text-base bg-blue-100 text-blue-800 border border-blue-300";
  }
  
  elements.resultMessage.classList.remove("hidden");
}

// 에러 메시지 표시
function inputErrorMessage(message) {
  elements.inputErrorMessage.innerHTML = message;
  elements.inputErrorMessage.classList.remove("hidden");
 
  setTimeout(() => {
    elements.inputErrorMessage.classList.add("hidden");
  }, 3000);
}

function startErrorMessage(message) {
  elements.startErrorMessage.innerHTML = message;
  elements.startErrorMessage.classList.remove("hidden");
 
  setTimeout(() => {
    elements.startErrorMessage.classList.add("hidden");
  }, 3000);
}

function showErrorMessage(message) {
  elements.startErrorMessage.innerHTML = message;
  elements.startErrorMessage.classList.remove("hidden");
 
  setTimeout(() => {
    elements.startErrorMessage.classList.add("hidden");
  }, 5000);
}

// 게임 상태 리셋
function resetGameState() {
  gameState.currentBet = 0;
  gameState.gemsFound = 0;
  gameState.gameActive = false;
  gameState.potentialWin = 0;
  gameState.minePositions = [];
  gameState.revealedTiles = [];
 
  elements.stopBtn.classList.add("hidden");
  elements.startBtn.classList.remove("hidden");
  elements.startBtn.textContent = "게임 시작";
  elements.startBtn.disabled = false;
  elements.stopBtn.disabled = false;
 
  elements.betAmount.value = "";
 
  elements.resultMessage.classList.add("hidden");
  elements.inputErrorMessage.classList.add("hidden");
  elements.startErrorMessage.classList.add("hidden");
 
  createGameBoard();
  updateUI();
}