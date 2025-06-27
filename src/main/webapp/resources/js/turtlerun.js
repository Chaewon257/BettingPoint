// 난이도별 거북이 수 설정
const difficultyMap = {
   EASY:   { count: 4 },
  NORMAL: { count: 6},
  HARD:   { count: 8}
};
const { count: TURTLE_COUNT} = difficultyMap.HARD; // 기본 난이도 설정


// 난이도/베팅/선택 고정값
let FIXED_DIFFICULTY = 'HARD'; // 'easy', 'normal', 'hard'
let FIXED_TURTLE_COUNT = 8;      // normal
let FIXED_BET = 10000;
let FIXED_SELECTED_TURTLE = 2;   // (3번, 0-based)

// 트랙 설정
const TURTLE_GAP = 10;
const vh = window.innerHeight;
const crowdHeight = vh * 0.18;
const trackHeight = vh - crowdHeight;
const laneHeight = trackHeight / 8;
const TURTLE_SIZE = laneHeight * 0.7; // 거북이 크기 (px 단위)
const TRACK_LENGTH = 8000; // 트랙 길이 (px 단위)
const START_MARGIN = Math.round(TURTLE_SIZE + TURTLE_GAP + 28); // 시작선 여유 공간 (px 단위)
const END_MARGIN = 110 + TURTLE_SIZE + TURTLE_GAP; // 결승선 여유 공간 (px 단위)
const TOTAL_WIDTH = TRACK_LENGTH + START_MARGIN + END_MARGIN; // 전체 트랙 너비 (px 단위)
document.querySelector('.crowd-repeat').style.width = TOTAL_WIDTH + "px";
document.querySelector('.crowd-stand').style.width = TOTAL_WIDTH + "px";
document.getElementById('trackContainer').style.height = trackHeight + 'px';

let ws;
let turtleGame = null;
let roomId = null;

// 게임방 상세 정보 요청
function gameRoomDetail (roomId) {
    let levels = {};
    let games = {};
    let roomPlayers = [];

    // 게임방 상세 정보 요청
    $.ajax({
        url: `/api/gameroom/detail/${roomId}`,
        method: "GET",
        success: function (room) {
            minBet = room.min_bet;

            // 난이도 정보 요청
            levelDetail(room, levels).then(() => {
                const levelData = levels[room.game_level_uid];
                return gameDetail(levelData, games).then(() => {
                    const gameData = games[levelData.game_uid];
                    return players(room, roomPlayers).then(() => {
                        connectGameWebSocket(roomId);
                        renderGameRoomDetail(room, levelData, gameData, roomPlayers);
                    });
                });
            });
        }
    });
};

// 게임 상세 정보 요청
function gameDetail(level, games) {
    return $.ajax({
        url: `/api/game/detail/${level.game_uid}`,
        method: "GET",
        success: function (gameData) {
            games[level.game_uid] = gameData;
        }
    });
}

// 게임 난이도 정보 요청
function levelDetail(room, levels) {
    return $.ajax({
        url: `/api/game/level/${room.game_level_uid}`,
        method: "GET",
        success: function (levelData) {
            levels[room.game_level_uid] = levelData;
        }
    });
}

// 플레이어 정보 요청
function players(room, roomPlayers) {
    return $.ajax({
        url: `/api/player/detail/${room.uid}`,
        method: "GET",
        success: function (players) {
            roomPlayers.push(...players);
        }
    });
}

function renderGameRoomDetail(room, levelData, gameData, roomPlayers) {
    // 1. 난이도/거북이수/베팅금액/포인트 등 필요한 값 추출 (기존 필드명에 따라 수정)
    const difficulty = (levelData.difficulty || levelData.level || "HARD").toUpperCase();
    const turtleCount = difficultyMap[difficulty]?.count || 8;
    const userBet = myInfo.betting_amount || 10000;

    const myInfo = roomPlayers.find(p => p.user_uid === localStorage.getItem("user_uid")) || {};
    const points = myInfo.points || 100;
    const selectedTurtle = myInfo.selectedTurtle ?? null;

    const turtleImages = [
        '/resources/images/turtle1.png', '/resources/images/turtle2.png',
        '/resources/images/turtle3.png', '/resources/images/turtle4.png',
        '/resources/images/turtle5.png', '/resources/images/turtle6.png',
        '/resources/images/turtle7.png', '/resources/images/turtle8.png'
    ];
    const victoryImages =[
        '/resources/images/victory1.png', '/resources/images/victory2.png', 
        '/resources/images/victory3.png', '/resources/images/victory4.png', 
        '/resources/images/victory5.png', '/resources/images/victory6.png', 
        '/resources/images/victory7.png', '/resources/images/victory8.png'
    ];
    const defeatImages =[
        '/resources/images/defeat1.png', '/resources/images/defeat2.png', 
        '/resources/images/defeat3.png', '/resources/images/defeat4.png', 
        '/resources/images/defeat5.png', '/resources/images/defeat6.png', 
        '/resources/images/defeat7.png', '/resources/images/defeat8.png'
    ];

    // 2. 게임 객체 생성 (기존 전역 변수 사용)
    window.turtleGame = new TurtleRacingGame({
        turtleCount,
        difficulty,
        userBet,
        turtleImages,
        victoryImages,
        defeatImages,
        selectedTurtle,
        points
    });
}

function connectGameWebSocket(roomId) {
    
    // roomId는 URL이나 다른 방식으로 먼저 준비
    const token = localStorage.getItem("accessToken");

    // WebSocket 연결 및 메시지 핸들러 등록 (초기화 시)
    ws = new WebSocket(`ws://${location.host}/ws/game/turtle/${roomId}?token=${encodeURIComponent(token)}`);

    ws.onopen = function() {
        console.log("WS 연결 성공")
    };

    ws.onmessage = function(event) {
        const msg = JSON.parse(event.data);

        // if (msg.type === "init") {
        //     // 게임 생성
        //     if(!turtleGame) {
        //         turtleGame = new TurtleRacingGame(msg);
        //     }
        // }
        // 경기 중 위치 업데이트
        if(msg.type === "race_update" && turtleGame) {
            turtleGame.setPositions(msg.positions);
        }
        // 경기 종료
        if(msg.type === "race_finish" && turtleGame) {
            turtleGame.finishRace(msg);
        }
        // 결과 메세지
        if(msg.type === "race_result") {
            // 1. 결과 모달에 필요한 정보
            showResultModal({
                winner: msg.winner,
                didwin: msg.yourResult.didwin,
                pointChange: msg.yourResult.pointChange,
                points: msg.yourResult.points,
                bet: msg.yourResult.bet,
                selectedTurtle: msg.yourResult.selectedTurtle
            });
        }
    };
}

function showCountdownOverlay(startNum, callback) {
    let overlay = document.getElementById('countdownOverlay');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = "countdownOverlay";
        overlay.className = "fixed inset-0 z-[2000] flex items-center justify-center bg-black/30 text-white text-[7vw] font-bold pointer-events-none select-none"; 
        document.getElementById('trackViewport').appendChild(overlay);
    } else {
        overlay.style.display = "flex";
    }
    let count = startNum;
    overlay.innerText = count;
    const step = () => {
        if (count > 0) {
            overlay.innerText = count;
            count--;
            setTimeout(step, 1000);
        } else {
            overlay.innerText = 'START!';
            setTimeout(() => {
                overlay.style.display = "none";
                if (callback) callback();
            }, 900);
        }
    };
    setTimeout(step, 400);
}

// TurtleRacingGame 클래스 정의
class TurtleRacingGame {
    constructor({
        turtleCount,
        difficulty,
        userBet,
        turtleImages,
        victoryImages,
        defeatImages,
        selectedTurtle,
        points
    }) {
        this.selectedDifficulty = difficulty; 
        this.turtleCount = turtleCount; 
        this.userBet = userBet; 
        this.turtleImages = turtleImages;
        this.victoryImages = victoryImages;
        this.defeatImages = defeatImages;
        this.selectedTurtle = selectedTurtle;
        this.points = points; 
        this.turtleBets = Array(this.turtleCount).fill(0);
        this.positions = Array(this.turtleCount).fill(0);
        this.transitionToFollow = false; // 선택 거북이 중앙 패닝 여부

        this.turtles = [];
        this.numbers = ['1번', '2번', '3번', '4번', '5번', '6번', '7번', '8번'];
        for (let i = 0; i < this.turtleCount; i++) {
            this.turtles.push({ id: i, name: `${this.numbers[i]} 거북이`, class: `${this.numbers[i]}-turtle` });
        }

        this.points = this.loadPoints();
        this.renderTrack();
        showCountdownOverlay(3, () => {
            this.startRace();
        });
        this.updatePointsDisplay();
        // if (this.statDisplay) this.updateStatsDisplay();
    }

    selectTurtle(id) {
        if (this.isRacing) return;
        this.selectedTurtle = id;
        this.turtleElements.forEach(turtle => turtle.classList.remove('selected'));
        if (this.turtleElements[id]) this.turtleElements[id].classList.add('selected');
        // 베팅 금액을 해당 거북이에 누적
        if (this.turtleBets && typeof this.userBet === 'number') {
            this.turtleBets[id] += this.userBet;
        }
    }

    renderTrack() { 
        const container = document.getElementById('trackContainer');
        this.turtleElements = []; // 기존 요소 초기화
        const TRACK_COUNT = 8; // 트랙 개수 고정(8개)
        const trackHeight = container.clientHeight; // 트랙 높이 (px 단위)
        const laneHeight = trackHeight / TRACK_COUNT; // 각 트랙의 높이 (px 단위)

         // [핵심] 난이도별 거북이 위치 지정
        let startLane, endLane;
        if (this.selectedDifficulty === "easy") {
            startLane = 2; endLane = 5; // 3~6번(0-based: 2~5)
        } else if (this.selectedDifficulty === "normal") {
            startLane = 1; endLane = 6; // 2~7번(0-based: 1~6)
        } else { // hard or 기타
            startLane = 0; endLane = 7; // 1~8번(0-based: 0~7)
        }
        const TURTLE_COUNT = endLane - startLane + 1; // 마리수 동기화

        // (2) DOM에 실제 크기 반영
        document.querySelector('.crowd-repeat').style.width = TOTAL_WIDTH + "px";
        document.querySelector('.crowd-stand').style.width = TOTAL_WIDTH + "px";
        container.innerHTML = '';
        container.style.width = TOTAL_WIDTH + 'px';
        this.container = container;
        const vp = document.getElementById('trackViewport');
        vp.style.height = vh + 'px'; // 화면 전체(100vh)
        container.style.height = trackHeight + 'px';
        container.style.position = 'relative';
        container.style.display = 'block';

        this.turtleElements = [];
        for (let i = 0; i < TRACK_COUNT; i++) {
            // 트랙 라인 생성
            const track = document.createElement('div');
            track.className = 'track-line';
            track.style.width = TOTAL_WIDTH + 'px';
            track.style.height = laneHeight + 'px';
            track.style.position = 'absolute';
            track.style.left = '0px';
            track.style.top = (i * laneHeight) + 'px';

            // 트랙 번호 표시
            const laneNum = document.createElement('div');
            laneNum.className = 'lane-number';
            laneNum.textContent = i + 1;
            laneNum.style.position = 'absolute';
            laneNum.style.top = (laneHeight / 2 - 17) + 'px';
            laneNum.style.width = '25px';
            laneNum.style.left = '12px';
            laneNum.style.textAlign = 'right';
            laneNum.style.fontSize = '1.8rem';
            laneNum.style.pointerEvents = 'none';
            track.appendChild(laneNum);

            // 거북이
            let turtle = null;
            if(i >= startLane && i <= endLane) {
                const turtleIdx = i - startLane; // 0-based 인덱스
                turtle = document.createElement('img');
                turtle.src = this.turtleImages[turtleIdx] || this.turtleImages[0];
                turtle.className = 'turtle';
                turtle.style.left = (START_MARGIN - TURTLE_SIZE + TURTLE_GAP) + 'px';
                turtle.style.top = (laneHeight / 2 - (laneHeight * 0.7) / 2) + 'px';
                turtle.style.height = (laneHeight * 0.7) + "px";
                turtle.setAttribute('data-turtle-idx', turtleIdx); // 거북이 ID 설정
                track.appendChild(turtle);

                this.turtleElements[turtleIdx] = turtle; // 거북이 요소 저장
            }

            container.appendChild(track);
           
            // START 라인 생성
            const startLine = document.createElement('div');
            startLine.className = 'start-line';
            startLine.style.left = START_MARGIN - TURTLE_GAP / 2 + 'px';
            startLine.style.height = trackHeight + 'px';
            startLine.style.top = '0';
            startLine.style.position = 'absolute';
            startLine.style.zIndex = 20; // 시작선이 트랙 위에 오도록
            startLine.style.pointerEvents = 'none'; // 클릭 이벤트 방지    
                
            const startLabel = document.createElement('div');
            startLabel.className = 'start-line-label';
            startLabel.innerHTML = `
                <span>S</span>
                <span>T</span>
                <span>A</span>
                <span>R</span>
                <span>T</span>
                `;
            startLine.appendChild(startLabel);
            container.appendChild(startLine);

            container.appendChild(track);
            this.turtleElements.push(turtle);
        }
            
        // FINISH 라인 생성
        const finishLine = document.createElement('div');
        finishLine.className = 'finish-line';
        finishLine.style.left = (START_MARGIN + TRACK_LENGTH + TURTLE_SIZE) + 'px'; // 38px은 선 두께/2
        finishLine.style.height = trackHeight + 'px';
        finishLine.style.top = '0';
        finishLine.style.width = '38px'; // 선 두께
        finishLine.style.position = 'absolute';
        finishLine.style.zIndex = 20; // 결승선이 트랙 위에 오도록
        finishLine.style.pointerEvents = 'none'; // 클릭 이벤트 방지
        // 결승선 라벨
        const finishLabel = document.createElement('div');
        finishLabel.className = 'finish-line-label';
        finishLabel.innerHTML = `
            <span>F</span>
            <span>I</span>
            <span>N</span>
            <span>I</span>
            <span>S</span>
            <span>H</span>
            `;
        finishLine.appendChild(finishLabel);
        container.appendChild(finishLine);
    }

    startRace() {
    //    if (this.selectedTurtle === null) return;
        this.positions = Array(this.turtleCount).fill(0);
        if(this.turtleElements && this.turtleElements.forEach) {
            this.turtleElements.forEach((turtle, i) => {
                if(!turtle) return; // 거북이 요소가 없으면 건너뛰기
                turtle.style.left = '0px'; // 출발 리셋
                turtle.classList.add('racing');
                turtle.classList.remove('winner-highlight');
            });
        }
        this.isRacing = true;
        this.winner = null;
        this.transitionToFollow = false;
        this.runRace();
    }

    runRace() {
        const vp = document.getElementById('trackViewport');
        let finished = false;
        const baseSpeeds = this.turtles.map(() => 0.03 + Math.random() * 0.03);
        const burstChances = this.turtles.map(() => Math.random() * 0.3);

        const updateRace = () => {
            if (!this.isRacing || finished) return;
            if (!this.turtleElements || !this.turtleElements[0]) return;

            for (let i = 0; i < this.positions.length; i++) {
                if(!this.turtleElements[i]) continue; // 거북이 요소가 없으면 건너뛰기
                
                if (this.positions[i] < 100) {
                    const burst = Math.random() < burstChances[i] ? 0.1 + Math.random() * 0.05 : 0;
                    const variation = (Math.random() - 0.05) * 0.02;
                    const move = baseSpeeds[i] + variation + burst;
                    this.positions[i] += move;
                    // [중요] 위치는 % → px로 변환
                    const px = START_MARGIN + (this.positions[i] / 100) * TRACK_LENGTH;
                    this.turtleElements[i].style.left = px + 'px';
                    // 1등 거북이는 FINISH + END_MARGIN까지 이동 가능
                    if (finished && i === winner) {
                        // 도착 후: FINISH 위치 + END_MARGIN / 2
                        this.turtleElements[i].style.left = (START_MARGIN + TRACK_LENGTH + END_MARGIN / 2) + 'px';
                    }
                } else if (!finished) {
                    this.winner = i;
                    finished = true;
                    this.turtleElements[i].classList.add('winner-highlight');
                    this.finishRace();
                    return;
                }
            }

            // 경주 위치 실시간 전송
            if (ws && ws.readyState === 1) {
                ws.send(JSON.stringify({
                    type: "race_update",
                    positions: this.positions
                }));
            }

            // 선택 거북이가 중앙에 오도록 트랙 패닝
            const container = this.container;
            const turtles = this.turtleElements;
            const selectedPx = parseFloat(turtles[this.selectedTurtle].style.left);
            const isMobile = window.innerWidth <= 640; // 모바일 여부   
            const isTablet = window.innerWidth > 640 && window.innerWidth <= 1024; // 태블릿 여부
            const isTabletOrMobileView = isTablet || isMobile;
            // [핵심] 초기엔 트랙 전체가 왼쪽에서 시작(맨 왼쪽!)
            if (!this.transitionToFollow) {
                this.container.style.transform = 'translateX(0px)';
                if (!isTabletOrMobileView && this.positions[this.selectedTurtle] > 5 && this.positions[this.selectedTurtle] < 90) {
                    this.transitionToFollow = true;
                    }
                if(isMobile && this.positions[this.selectedTurtle] > 0.5) {
                    this.transitionToFollow = true;
                    }
                if(isTablet && this.positions[this.selectedTurtle] > 2.5) {
                    this.transitionToFollow = true;
                    }                 
            } else if (this.turtleElements[this.selectedTurtle]) {
                const px = selectedPx + 20;
                let panX = px - vp.offsetWidth / 2;
                
                // 패닝 범위 제한
                const minPan = 0;
                const maxPan = TOTAL_WIDTH - vp.offsetWidth;
                if (panX < minPan) panX = minPan;
                if (panX > maxPan) panX = maxPan;
                this.container.style.transform = `translateX(${-panX}px)`;
                const crowd = document.querySelector('.crowd-repeat');
                if (crowd) crowd.style.transform = `translateX(${-panX}px)`;
                const crowdStand = document.querySelector('.crowd-stand');
                if (crowdStand) {
                    crowdStand.style.transform = `translateX(${-panX}px)`;
                }   
            }

            requestAnimationFrame(updateRace);
        };
        requestAnimationFrame(updateRace);
    }

    finishRace(serverMsg) {
        this.isRacing = false;
        if(this.resultSent) return;
        this.resultSent = true;
        const winnerText = document.getElementById('winnerText');
        const resultImage = document.getElementById('resultImage');
        const resultMessage = document.getElementById('resultMessage');
        const pointSummary = document.getElementById('pointSummary');
        const selectedIdx = this.selectedTurtle;
        const winner = this.winner;
        const winnerPx = START_MARGIN + TRACK_LENGTH + END_MARGIN / 2 + TURTLE_GAP * 2; // 결승선 + 여유 공간 
        this.turtleElements[winner].style.left = winnerPx + 'px'; // 우승 거북이 위치 조정  
        const didWin = (this.selectedTurtle === this.winner);

        winnerText.textContent = `우승 거북이: ${this.turtles[this.winner].name}`;

        if(this.selectedTurtle === this.winner) {
            resultMessage.textContent = '🎉 당신이 선택한 거북이가 우승했습니다!';
        } else {
            resultMessage.textContent = '😢 당신이 선택한 거북이가 우승하지 못했습니다.';
        }

        
        const resultImageSrc = didWin ? this.victoryImages[selectedIdx] : this.defeatImages[selectedIdx];
        resultImage.innerHTML = `<img src="${resultImageSrc}" alt="결과 이미지" class="result-turtle-image">`;

        // 포인트 요약
        const userBet = this.userBet; // 사용자가 건 금액
        const userTurtle = this.selectedTurtle; // 사용자가 선택한 거북이
        const winnerTurtle = this.winner;
        const winPool = this.turtleBets[winnerTurtle] || 1; //userBet; 
        const totalBet = this.turtleBets.reduce((a, b) => a + b, 0) || 1; //userBet; 
        const difficultyRateMap = { easy: 0.2, normal: 1.5, hard: 4.0 };
        const difficulty = this.selectedDifficulty; //|| "normal";
        const userRate = difficultyRateMap[difficulty] || 1;

        const pointChange = this.selectedTurtle === this.winner ?
            Math.round((totalBet / winPool) * userBet + userBet * userRate) :
            -userBet;
        this.points = Math.max(0, this.points + pointChange);
        pointSummary.textContent = `보유 포인트: ${this.points} (${pointChange >= 0 ? '+' : ''}${pointChange})`;
        pointSummary.style.color = pointChange >= 0 ? 'green' : 'red';

        this.savePoints();
        this.updatePointsDisplay();
        if (this.statDisplay) this.updateStatsDisplay();
        this.turtleElements.forEach(turtle => {if(turtle) turtle.classList.remove('racing')});

         // 1. 승패 이미지로 변경
        for (let i = 0; i < this.turtleElements.length; i++) {
            const turtle = this.turtleElements[i];
            if (!turtle) continue; // null 보호
            const turtleIdx = parseInt(turtle.getAttribute('data-turtle-idx'), 10);
            if (turtleIdx === this.winner) {
                // 1등: 승리 이미지로
                turtle.src = this.victoryImages[turtleIdx] || this.turtleImages[turtleIdx];
            } else {
                // 나머지: 패배 이미지로
                turtle.src = this.defeatImages[turtleIdx] || this.turtleImages[turtleIdx];
            }
        }

        const gameResult = {
            winner: this.winner,
            positions: this.positions,
            selectedTurtle: this.selectedTurtle,
            points: this.points,
            bet: this.userBet,
            difficulty: this.selectedDifficulty,
            turtleBets: this.turtleBets,
            pointChange: pointChange,
            userId: this.userId, // 사용자 ID 추가
            roomId: this.roomId // 게임방 ID 추가
        };

        if(!serverMsg && ws && ws.readyState === 1 && !this.resultSent) {
            this.resultSent = true;
            ws.send(JSON.stringify({
                type: "race_finish",
                winner: this.winner,
                positions: this.positions,
                selectedTurtle: this.selectedTurtle,
                points: this.points,
                bet: this.userBet,
                difficulty: this.selectedDifficulty,
                turtleBets: this.turtleBets,
                pointChange: pointChange,
                userId: this.userId,
                roomId: this.roomId
            }));
        }

        // 모달 표시
        showModal();
        startRedirectCountdown(5);
    }

    resetRace() {
        this.positions = Array(this.turtleCount).fill(0);
        this.selectedTurtle = null;
        this.turtleElements.forEach(turtle => {
            turtle.classList.remove('selected');
            t.style.left = '0px';
        });
        this.resetBtn.style.display = 'none';
        this.startBtn.style.display = 'inline-block';
        for (let i = 0; i < this.turtleElements.length; i++) {
            const turtle = this.turtleElements[i];
            if (!turtle) continue;
            const turtleIdx = parseInt(turtle.getAttribute('data-turtle-idx'), 10);
            turtle.src = this.turtleImages[turtleIdx];
        }
        this.resultSent = false; // 결과 전송 초기화
    }

    updatePointsDisplay() {
        if(this.pointsDisplay) 
        this.pointsDisplay.textContent = this.points;
    }

    loadPoints() {
        getPointsFromServer((points) => {
            this.points = points || 100; // 기본값 100
            this.updatePointsDisplay();
            if(callback) callback(points);
        });
    }

    savePoints() {
        savePointsToServer(this.points);
    }
}

function isTabletOrMobileView() {
  return window.innerWidth <= 1024;
}

window.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById('resultModal');
    const closeBtn = document.getElementById('modalClose');

    closeBtn.addEventListener('click', hideModal);

    modal.addEventListener('click', (e) => {
        if (e.target === modal) hideModal();
    });
});

// [Tailwind 변환] 모달 표시 함수
function showModal() {
    const modal = document.getElementById('resultModal');
    modal.classList.remove('hidden');
    modal.classList.add('flex');
}

// [Tailwind 변환] 모달 닫기 함수
function hideModal() {
    const modal = document.getElementById('resultModal');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
}

function startRedirectCountdown(seconds) {
    const countdownElem = document.getElementById('countdownText');
    let counter = seconds;
    const modal = document.getElementById('resultModal');

    countdownElem.textContent = `${counter}초 후 게임방으로 이동합니다.`;

    const timer = setInterval(() => {
        counter--;
        if (counter <= 0) {
            clearInterval(timer);
            hideModal();
            window.location.href = '/gameroom/detail/' + roomId;
        } else {
            countdownElem.textContent = `${counter}초 후 게임방으로 이동합니다.`;
        }
    }, 1000);
}