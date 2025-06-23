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
        const game = games[room.game_uid];

        const roomHtml = `
            <div class="game-room" data-room-id="${room.uid}">
                <h3>${room.title}</h3>
                <p><strong>게임 이름:</strong> ${game.name}</p>
                <p><strong>게임 레벨:</strong> ${game.level}</p>
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

let socket;

// 게임방 웹소켓 연결
function connectGameWebSocket(roomId) {
    if (socket && socket.readyState === WebSocket.OPEN) {
        socket.close(); // 기존 소켓이 있으면 닫고 새로 연결
    }

    const token = localStorage.getItem("accessToken");
    if(!token) {
        alert("로그인이 필요합니다.");
        return;
    }

    socket = new WebSocket(`ws://${location.host}/ws/game/turtle/${roomId}?token=${encodeURIComponent(token)}`);

    socket.onopen = () => {
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
                updatePlayerList(msg.players);
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

// 게임방 상세 정보 요청
function gameRoomDetail (roomId) {
    let games = {};
    let roomPlayers = [];

    // 게임방 상세 정보 요청
    $.ajax({
        url: `/api/gameroom/detail/${roomId}`,
        method: "GET",
        success: function (room) {
            // 게임 상세 정보 요청
            let detailReq = gameDetail(room, games);

            // 플레이어 정보 요청
            let playerReq = players(room, roomPlayers);

            Promise.all([detailReq, playerReq]).then(() => {
                const game = games[room.game_uid];
                connectGameWebSocket(roomId);
                renderGameRoomDetail(room, game, roomPlayers);
                console.log(room, game, roomPlayers);
            });
        }
    });
};

// 거북이 선택, 포인트 베팅, 준비 상태 변경
function bindGameEvents() {
    let isReady = false;

    $(document).on('change', 'input[name="turtle"]', function() {
        const turtleId = $(this).val();
        socket.send(JSON.stringify({
            type: "choice",
            turtle_id: turtleId
        }));
    });

    $(document).on('click', '#bet-btn', function() {
        const point = $('#bet-point').val();
        if (!point || point <= 0) {
            alert('베팅 포인트를 입력하세요.');
            return;
        }
        socket.send(JSON.stringify({
            type: "betting",
            betting_point: parseInt(point, 10)
        }));
    });

    $(document).on('click', '#ready-btn', function() {
        isReady = !isReady; // 전역 변수로 선언 필요
        const $btn = $(this);
        $btn.text(isReady ? '준비 취소' : '게임 준비');
        socket.send(JSON.stringify({
            type: "ready",
            isReady: isReady
        }));
    });
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
                <span><strong>베팅 금액:</strong> ${player.betting_point}</span>
                <span><strong>준비 상태:</strong> ${player.ready ? "준비 완료" : "준비"}</span>
            </div>
        `;
        $playerList.append(html);
    });
}

// 게임방 상세 정보 렌더링(임시)
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
    `;

    container.html(roomHtml);

    updatePlayerList(roomPlayers);
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

// 게임 리스트 요청
function gameList() {
    $.ajax({
        url: '/api/game/list',
        type: 'GET',
        success: function(games) {
            games.forEach(function(game) {
                $('#game_uid').append(
                    $('<option>', {
                        value: game.uid,
                        text: game.name
                    })
                );
            });
        }
    });
}

// 게임방 생성 요청
function createRoom() {
    $('#create-room-form').on('submit', function(e) {
        e.preventDefault();

        const token = localStorage.getItem("accessToken");
        if (!token) {
            alert("로그인이 필요합니다.");
            return;
        }

        const payload = {
            title: $('#title').val(),
            min_bet: parseInt($('#min_bet').val()),
            game_uid: $('#game_uid').val()
        };

        $.ajax({
            url: '/api/gameroom/insert',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            headers: {
                'Authorization': 'Bearer ' + token
            },
            success: function(roomId) {
                alert("게임이 생성되었습니다.");
                location.href = '/gameroom/detail/' + roomId;
            },
            error: function() {
                alert("다시 시도하세요.");
            }
        });
    });
}