// 게임방 리스트 요청
function gameRoomList() {
    let gamerooms = []; // 게임방 리스트
    let games = {}; // 게임 정보
    let playerCounts = {}; // 각 게임방 플레이어 수

    // 게임방 리스트 요청
    $.ajax({
        url: "/api/gameroom/list",
        method: "GET",
        success: function (responseData) {
            gamerooms = responseData;

            // 게임 상세 정보 요청
            let detailReq = gamerooms.map(room => gameDetail(room, games));

            // 플레이어 수 요청
            let countReq = countPlayers(playerCounts);

            Promise.all([...detailReq, countReq]).then(() => {
                renderGameRooms(gamerooms, games, playerCounts);
                console.log(gamerooms, games, playerCounts);
            });
        }
    });
};

// 게임방 리스트 렌더링(임시)
function renderGameRooms(gamerooms, games, playerCounts) {
    const container = $("#room-container");
    container.empty();

    gamerooms.forEach(room => {
        const count = playerCounts[room.uid] || 0;

        const roomHtml = `
            <div class="game-room" data-room-id="${room.uid}">
                <h3>${room.title}</h3>
                <p><strong>게임 이름:</strong> ${games.name}</p>
                <p><strong>게임 레벨:</strong> ${games.level}</p>
                <p><strong>현재 인원:</strong> ${count} / 8</p>
                <p><strong>최소 베팅 금액:</strong> ${room.min_bet} 포인트</p>
                <p><strong>게임방 상태:</strong> ${room.status}</p>
            </div>
        `;

        container.append(roomHtml);
    });

    $(".game-room").on("click", function () {
        const roomId = $(this).data("room-id");
        window.location.href = `/gameroom/detail/${roomId}`;
    });
}

// 게임방 상세 정보 요청
function gameRoomDetail (roomId) {
    let game = {};
    let roomPlayers = [];

    // 게임방 상세 정보 요청
    $.ajax({
        url: `/api/gameroom/detail/${roomId}`,
        method: "GET",
        success: function (room) {
            // 게임 상세 정보 요청
            let detailReq = gameDetail(room, game);

            // 플레이어 정보 요청
            let playerReq = players(room, roomPlayers);

            Promise.all([detailReq, playerReq]).then(() => {
                renderGameRoomDetail(room, game, roomPlayers);
                console.log(room, game, roomPlayers);
            });
        }
    });
};

// 게임방 상세 정보 렌더링
function renderGameRoomDetail(room, game, roomPlayers) {
    const container = $("#room-detail-container");
    container.empty();

    const roomHtml = `
        <h2 id="room-title">${room.title}</h2>
        <div>
            <p><strong>게임 이름:</strong> ${game.name}</p>
            <p><strong>게임 레벨:</strong> ${game.level}</p>
        </div>
        <div id="player-list"></div>
        <div id="chat-box"></div>
    `;

    container.html(roomHtml);

    updatePlayerList(roomPlayers);
}

// 게임 상세 정보 요청
function gameDetail(room, game) {
    return $.ajax({
        url: `/api/game/detail/${room.game_uid}`,
        method: "GET",
        success: function (gameData) {
            Object.assign(game, gameData);
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

// 전체 플레이어 수 요청
function countPlayers(playerCounts) {
    return $.ajax({
        url: "/api/player/count",
        method: "GET",
        success: function (countData) {
            Object.assign(playerCounts, countData);
        }
    });
}

// 게임방 웹소켓 연결
function connectGameWebSocket(roomId) {
    socket = new WebSocket(`ws://${location.host}/ws/game/turtle/${roomId}`);

    socket.onopen = () => {
        const token = localStorage.getItem("accessToken");
        socket.send(JSON.stringify({
            type: "auth",
            token: "Bearer " + token
        }));
        console.log("웹소켓 연결 성공");
    };

    socket.onmessage = (event) => {
        const msg = JSON.parse(event.data);
        console.log("서버 메시지:", msg);

        switch (msg.type) {
            case "enter":
            case "exit":
                updatePlayerList(msg.players);
                showSystemMessage(`${msg.userId} 님이 ${msg.type === 'enter' ? '입장' : '퇴장'}했습니다.`);
                break;
            case "update":
                updatePlayerInfo(msg.player);
                break;
            default:
                console.warn("알 수 없는 메시지 타입:", msg.type);
        }
    };

    socket.onclose = () => {
        console.log("웹소켓 연결 종료");
        window.location.href = "/gameroom";
    };

    socket.onerror = (error) => {
        console.error("웹소켓 에러", error);
    };

    function showSystemMessage(message) {
        $("#chat-box").append(`<div class="system-message">${message}</div>`);
    }
}

function updatePlayerInfo(updatedPlayer) {
    const $playerList = $("#player-list");

    // 기존 플레이어 div 삭제
    $playerList.find(`#player-${updatedPlayer.user_uid}`).remove();

    // 새로운 정보로 추가
    const html = `
        <div id="player-${updatedPlayer.user_uid}">
            <div><strong>ID:</strong> ${updatedPlayer.user_uid}</div>
            <div><strong>선택한 거북이:</strong> ${updatedPlayer.turtle_id}</div>
            <div><strong>준비 상태:</strong> ${updatedPlayer.isReady}</div>
        </div>
    `;
    $playerList.append(html);
}

// 플레이어 목록 갱신
function updatePlayerList(players) {
    const $playerList = $("#player-list");
    $playerList.empty(); // 기존 플레이어 목록 초기화

    players.forEach(player => {
        const html = `
            <div class="player-info" id="player-${player.user_uid}">
                <span><strong>ID:</strong> ${player.user_uid}</span>
                <span><strong>선택한 거북이:</strong> ${player.turtle_id}</span>
                <span><strong>준비 상태:</strong> ${player.isReady}</span>
            </div>
        `;
        $playerList.append(html);
    });
}