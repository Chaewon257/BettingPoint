let socket;

function connectGameWebSocket() {
    if (socket && socket.readyState === WebSocket.OPEN) {
        socket.close(); // 기존 소켓이 있으면 닫고 새로 연결
    }

    socket = new WebSocket(`ws://${location.host}/ws/gameroom`);

    socket.onopen = () => {

    };

    socket.onmessage = (event) => {
        const msg = JSON.parse(event.data);

        if(msg.gamerooms) {
            gamerooms = msg.gamerooms;
        }

        if(msg.playerCounts) {
            playerCounts = msg.playerCounts;
        }

        switch (msg.type) {
            case "insert":
            case "delete":
            case "enter":
            case "exit":
                renderGameRooms(gamerooms, playerCounts);
                break;
            default:
                console.warn("알 수 없는 메시지 타입", msg.type);
        }
    };

    socket.onclose = () => {
        window.location.href = "/";
    }

    socket.onerror = (error) => {
        console.error("❌ 웹소켓 에러 발생", error);
    }
}

let gamerooms = []; // 게임방 리스트
let games = {}; // 게임 정보
let playerCounts = {}; // 각 게임방 플레이어 수

// 게임방 리스트 요청
function gameRoomList() {
    // 게임방 리스트 요청
    $.ajax({
        url: "/api/gameroom/list",
        method: "GET",
        success: function (responseData) {
            gamerooms = responseData;

            // 게임 상세 정보 요청
            // let detailReq = gamerooms.map(room => gameDetail(room, games));

            // 플레이어 수 요청
            let countReq = countPlayers(playerCounts);

            Promise.all([countReq]).then(() => {
                connectGameWebSocket();
                renderGameRooms(gamerooms, playerCounts);
            });
        }
    });
};

// 게임방 리스트 렌더링(임시)
function renderGameRooms(gamerooms, playerCounts) {
    const container = $("#room-container");
    container.empty();

    gamerooms.forEach(room => {
        const count = playerCounts[room.uid] || 0;
        // const game = games[room.game_uid];

        const roomHtml = `
            <div class="game-room" data-room-id="${room.uid}">
                <h3>${room.title}</h3>
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

// 게임 상세 정보 요청
function gameDetail(room, games) {
    return $.ajax({
        url: `/api/game/detail/${room.game_uid}`,
        method: "GET",
        success: function (gameData) {
            games[room.game_uid] = gameData;
        }
    });
}
