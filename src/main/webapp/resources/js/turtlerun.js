// 난이도별 거북이 수 설정
const difficultyMap = {
   EASY:   { count: 4 },
  NORMAL: { count: 6},
  HARD:   { count: 8}
};

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
let userId;
let isHost = false;

const roomId = (function() {
    const match = window.location.pathname.match(/\/multi\/([^\/]+)\/turtlerun/);
    return match ? match[1] : null;
})();

userInfo(function(uid) {
    userId = uid; // 콜백에서 userId 전역 변수 세팅
    // 반드시 userId가 준비된 뒤에 gameRoomDetail 실행
    gameRoomDetail(roomId);
});

// 유저 정보 요청
function userInfo(callback) {
    const token = localStorage.getItem("accessToken");
    if (!token) {
        alert("로그인이 필요합니다.");
        return;
    }

    $.ajax({
        url: '/api/user/me',
        type: 'GET',
        headers: {
            'Authorization': 'Bearer ' + token
        },
        success: function(user) {            
            callback(user.uid);
        }
    });
}

function onRoomInfoLoaded(room, userId) {
    isHost = (room.host_uid === userId);
}

let roomPlayers = [];

// 게임방 상세 정보 요청
function gameRoomDetail (roomId) {
    // 게임방 상세 정보 요청
    $.ajax({
        url: `/api/gameroom/detail/${roomId}`,
        method: "GET",
        success: function (room) {
            minBet = room.min_bet;
            isHost = (room.host_uid === userId);
            connectGameWebSocket(roomId);
            onRoomInfoLoaded(room, userId);
            players(roomPlayers, function() {
                renderGameDetail(room, roomPlayers);
            });
        }
    });
};

// 플레이어 정보 요청
function players(roomPlayers, callback) {
    return $.ajax({
        url: `/api/player/detail/${roomId}`,
        method: "GET",
        success: function (players) {
            roomPlayers.push(...players);
            if(callback) callback();
        }
    });
}

function renderGameDetail(room, roomPlayers) {
    // 1. 난이도, 거북이 수 등
    const difficulty = room.level;
    const turtleCount = (difficultyMap[difficulty] ? difficultyMap[difficulty].count : undefined);  
    // 3. 사용자 베팅, 포인트, 선택 등
    const myInfo = roomPlayers.find(p => p.user_uid === userId);
    if(!myInfo) {
        alert("플레이어 정보 동기화 실패(내 정보 없음)");
        return;
    }

    const userBet = myInfo.betting_point;
    const selectedTurtle = (Number(myInfo.turtle_id) - 1);
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
    turtleGame = new TurtleRacingGame({
        turtleCount,
        difficulty,
        userBet,
        turtleImages,
        victoryImages,
        defeatImages,
        selectedTurtle
    });
}

function connectGameWebSocket(roomId) {
    // roomId는 URL이나 다른 방식으로 먼저 준비
    const token = localStorage.getItem("accessToken");
    // WebSocket 연결 및 메시지 핸들러 등록 (초기화 시)
    ws = new WebSocket(`ws://${location.host}/ws/game/turtle/${roomId}?token=${encodeURIComponent(token)}`);
   
    ws.onopen = function() {
    }

    ws.onmessage = function(event) {
        const msg = JSON.parse(event.data);
        // 방장이 퇴장했을 때 방장 변경
        if(msg.type === "host_changed") {
            isHost = (userId === msg.newHostUid);
        }
        // 모든 플레이어 위치 갱신!
        if (msg.type === "race_update" && turtleGame) {
            turtleGame.updateAllPositions(msg.positions);
        }
        // 경기 종료
        if(msg.type === "race_finish" && turtleGame) {
            const myResult = msg.results.find(r => r.user_uid === userId);
            turtleGame.finishRace(msg, myResult);
        }
        // 중간 퇴장
        if (msg.type === "force_exit") {
            alert("연결이 끊겨 패배 처리되었습니다.\n게임방 리스트로 이동합니다.");
            players(roomPlayers);
            window.location.href = msg.targetUrl;
        }
        // 게임 종료 후 방으로 이동
        if(msg.type === "end") {
            const targetUrl = msg.target;
            window.location.href = targetUrl;
        }
    };
}

function showCountdownOverlay(startNum, callback, totalBetAmount) {
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

// 위치 정보 업데이트 될 동안 쓰는 애니메이션 함수
function lerp(a, b, t) {
    return a + (b - a) * t;
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
    }) {
        this.selectedDifficulty = difficulty; 
        this.turtleCount = turtleCount; 
        this.userBet = userBet; 
        this.turtleImages = turtleImages;
        this.victoryImages = victoryImages;
        this.defeatImages = defeatImages;
        this.selectedTurtle = selectedTurtle;
        this.turtleBets = Array(this.turtleCount).fill(0);
        this.positions = Array(this.turtleCount).fill(0);
        this.displayedPositions = Array(this.turtleCount).fill(0);
        this.transitionToFollow = false; // 선택 거북이 중앙 패닝 여부
        this.turtles = [];
        this.numbers = ['1번', '2번', '3번', '4번', '5번', '6번', '7번', '8번'];
        for (let i = 0; i < this.turtleCount; i++) {
            this.turtles.push({ id: i, name: `${this.numbers[i]} 거북이`, class: `${this.numbers[i]}-turtle` });
        }
        this.renderTrack();
        this.selectTurtle(this.selectedTurtle);
        showCountdownOverlay(3, () => {
            if(isHost) {
                ws.send(JSON.stringify({ type: "game_start", roomId }));
            }
        });
    }

    selectTurtle(selectedTurtle) {
        if (this.isRacing) return;
        this.selectedTurtle = selectedTurtle;
        // 모두 테두리 제거
        this.turtleElements.forEach(turtle => turtle.classList.remove('selected'));
        // 선택된 거북이에만 테두리 부여
        if (typeof selectedTurtle === 'number' && selectedTurtle >= 0 && selectedTurtle < this.turtleElements.length) {
            this.turtleElements[selectedTurtle].classList.add('selected');
        }
    }

    updatePanning() {
    // 선택된 거북이가 유효해야 패닝
    if (typeof this.selectedTurtle !== 'number' || !this.turtleElements[this.selectedTurtle]) return;
    // displayedPositions 기반으로 px 위치 계산
    const selectedPos = this.displayedPositions[this.selectedTurtle];
    const selectedPx = START_MARGIN + (selectedPos / 100) * TRACK_LENGTH;
    const vp = document.getElementById('trackViewport');
    const isMobile = window.innerWidth <= 640;
    const isTablet = window.innerWidth > 640 && window.innerWidth <= 1024;
    const isTabletOrMobileView = isTablet || isMobile;
    if (!this.transitionToFollow) {
        this.container.style.transform = 'translateX(0px)';
        if (!isTabletOrMobileView && selectedPos > 5 && selectedPos < 90) {
            this.transitionToFollow = true;
        }
        if (isMobile && selectedPos > 0.5) {
            this.transitionToFollow = true;
        }
        if (isTablet && selectedPos > 2.5) {
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
        if (crowdStand) crowdStand.style.transform = `translateX(${-panX}px)`;
    }
}

    updateAllPositions(positions) {
        this.positions = positions;
        for(let i = 0; i < this.turtleElements.length; i++) {
            if(!this.turtleElements[i].classList.contains('racing')) {
                this.turtleElements[i].classList.add('racing');
            }
        }
        this.animateTurtles();
    }

    animateTurtles() {
        if(this._animating) {
            // 이미 실행중이라면 중복 호출 방지
            return;
        }
        this._animating = true;
        // 매 프레임마다 displayedPositions → positions로 lerp
        let needNextFrame = false;
        for(let i=0; i<this.turtleCount; i++) {
            // 보간
            const prev = this.displayedPositions[i];
            const target = this.positions[i];
            const newPos = lerp(prev, target, 0.1); // 0.1~0.2 추천
            this.displayedPositions[i] = newPos;
            // px로 변환해서 DOM 위치 갱신
            if(this.turtleElements[i]) {
                const px = START_MARGIN + (newPos / 100) * TRACK_LENGTH;
                this.turtleElements[i].style.left = px + 'px';
            }
            // 아직 목표까지 많이 남았으면 계속 프레임 돌림
            if(Math.abs(target - newPos) > 0.05) needNextFrame = true;
        }
        this.updatePanning();
        if(needNextFrame) {
            requestAnimationFrame(() => {
                this._animating = false;
                this.animateTurtles();
            });
        } else {
            this._animating = false;
        }
    }

    renderTrack() { 
        const container = document.getElementById('trackContainer');
        const TRACK_COUNT = 8; // 트랙 개수 고정(8개)
        const trackHeight = container.clientHeight; // 트랙 높이 (px 단위)
        const laneHeight = trackHeight / TRACK_COUNT; // 각 트랙의 높이 (px 단위)
         // [핵심] 난이도별 거북이 위치 지정
        let startLane, endLane;
        if (this.selectedDifficulty === "EASY") {
            startLane = 2; endLane = 5; // 3~6번(0-based: 2~5)
        } else if (this.selectedDifficulty === "NORMAL") {
            startLane = 1; endLane = 6; // 2~7번(0-based: 1~6)
        } else { // hard or 기타
            startLane = 0; endLane = 7; // 1~8번(0-based: 0~7)
        }
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
        let turtleIdx = 0;
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
                turtle = document.createElement('img');
                turtle.src = this.turtleImages[turtleIdx] || this.turtleImages[0];
                turtle.className = 'turtle';
                turtle.style.left = (START_MARGIN - TURTLE_SIZE + TURTLE_GAP) + 'px';
                turtle.style.top = (laneHeight / 2 - (laneHeight * 0.7) / 2) + 'px';
                turtle.style.height = (laneHeight * 0.7) + "px";
                turtle.setAttribute('data-turtle-idx', turtleIdx); // 거북이 ID 설정
                track.appendChild(turtle);
                this.turtleElements.push(turtle); // 거북이 요소 저장
                turtleIdx++;
            }
            container.appendChild(track);
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
        this.positions = Array(this.turtleElements.length).fill(0);
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
    }

    finishRace(serverMsg, myResult) {
        const winnerText = document.getElementById('winnerText');
        const resultImage = document.getElementById('resultImage');
        const resultMessage = document.getElementById('resultMessage');
        const pointSummary = document.getElementById('pointSummary');
        // serverMsg.results 배열에서 내 결과만 추출
        const pointChange = myResult.pointChange;
        const didWin = myResult.didWin;
        const winner = serverMsg.winner;
        const selectedTurtle = this.selectedTurtle;
        // ---- 패닝/애니메이션용 ----
        const winnerPx = START_MARGIN + TRACK_LENGTH + END_MARGIN / 2 + TURTLE_GAP * 2;
        if (this.turtleElements[winner]) {
            this.turtleElements[winner].style.left = winnerPx + 'px';
            this.displayedPositions[winner] = winnerPx + 'px';
            this.positions[winner] = winnerPx + 'px';
        }
        // ---- 텍스트 및 이미지 ----
        winnerText.textContent = `우승 거북이: ${this.turtles[winner].name}`;
        resultMessage.textContent = didWin ? '🎉 당신이 선택한 거북이가 우승했습니다!' : '😢 당신이 선택한 거북이가 우승하지 못했습니다.';
        const resultImageSrc = didWin ? this.victoryImages[selectedTurtle] : this.defeatImages[selectedTurtle];
        resultImage.innerHTML = `<img src="${resultImageSrc}" alt="결과 이미지" class="result-turtle-image">`;
        pointSummary.textContent = `포인트 변화 : (${pointChange > 0 ? '+' : ''}${pointChange.toLocaleString()})`;
        pointSummary.style.color = pointChange > 0 ? 'green' : 'red';
        // 애니메이션
        for (let i = 0; i < this.turtleElements.length; i++) {
            const turtle = this.turtleElements[i];
            if (!turtle) continue;
            if(turtle) turtle.classList.remove('racing');
            const turtleIdx = parseInt(turtle.getAttribute('data-turtle-idx'), 10);
            turtle.src = (turtleIdx === winner)
            ? (this.victoryImages[turtleIdx] || this.turtleImages[turtleIdx])
            : (this.defeatImages[turtleIdx] || this.turtleImages[turtleIdx]);
        }
        // 모달 표시 및 카운트다운 이동
        showModal();
        startRedirectCountdown(5);
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
    if(modal) {
        modal.classList.remove('hidden');
        modal.classList.add('flex');
    }
}

// [Tailwind 변환] 모달 닫기 함수
function hideModal() {
    const modal = document.getElementById('resultModal');
    if(modal) {
        modal.classList.add('hidden');
        modal.classList.remove('flex');
    }
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
             // 상태 WAITING으로 변경 후 이동
            $.ajax({
                url: `/api/gameroom/start/${roomId}`,
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify({status: "WAITING"}),
                success: function () {
                    ws.send(JSON.stringify({
                        type: "end"
                    }));
                },
                error: function() {
                    alert("게임방이 존재하지 않습니다.");
                    window.location.href = "/";
                }
            });
        } else {
            countdownElem.textContent = `${counter}초 후 게임방으로 이동합니다.`;
        }
    }, 1000);
}