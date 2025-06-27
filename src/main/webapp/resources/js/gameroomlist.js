let socket;

function connectGameWebSocket() {
    if (socket && socket.readyState === WebSocket.OPEN) {
        socket.close(); // 기존 소켓이 있으면 닫고 새로 연결
    }

    socket = new WebSocket(`ws://${location.host}/ws/gameroom`);

    socket.onopen = () => {};

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
                renderGameRooms(gamerooms, games, levels, playerCounts);
                break;
            default:
                console.warn("알 수 없는 메시지 타입", msg.type);
        }
    };

    socket.onclose = () => {}

    socket.onerror = (error) => {
        console.error("❌ 웹소켓 에러 발생", error);
    }
}

let gamerooms = []; // 게임방 리스트
let games = {}; // 게임 정보
let levels = {};
let playerCounts = {}; // 각 게임방 플레이어 수

// 게임방 리스트 요청
function gameRoomList() {
    // 게임방 리스트 요청
    $.ajax({
        url: "/api/gameroom/list",
        method: "GET",
        success: function (responseData) {
            gamerooms = responseData;

            // 게임 정보 요청
            let gameReqs = gamerooms.map(room => {
                return levelDetail(room, levels).then(() => {
                    const levelData = levels[room.game_level_uid];
                    return gameDetail(levelData, games);
                });
            });

            // 플레이어 수 요청
            let countReq = countPlayers(playerCounts);

            Promise.all([...gameReqs, countReq]).then(() => {
                connectGameWebSocket();
                renderGameRooms(gamerooms, games, levels, playerCounts);
            });
        }
    });
};

// 게임방 리스트 렌더링(임시)
function renderGameRooms(gamerooms, games, levels, playerCounts) {
    const container = $("#room-container");
    container.empty();

    gamerooms.forEach(room => {
        const count = playerCounts[room.uid] || 0;
        const level = levels[room.game_level_uid] || {};
        const game = games[level.game_uid] || {};

        const roomHtml = `
            <div class="game-room" data-room-id="${room.uid}" data-status="${room.status}">
                <h3>${room.title}</h3>
                <p><strong>게임 이름:</strong> ${game.name}</p>
                <p><strong>난이도:</strong> ${level.level}</p>
                <p><strong>현재 인원:</strong> ${count} / 8</p>
                <p><strong>최소 베팅 금액:</strong> ${room.min_bet} 포인트</p>
                <p><strong>게임방 상태:</strong> ${room.status}</p>
            </div>
        `;

        container.append(roomHtml);
    });

    $(".game-room").on("click", function () {
        const roomStatus = $(this).data("status");
        if(roomStatus !== "PLAYING") {
            const roomId = $(this).data("room-id");
            window.location.href = `/gameroom/detail/${roomId}`;
        } else {
            alert("진행중인 게임방입니다.");
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

// 게임방 게임 난이도 정보 요청
function levelDetail(room, levels) {
    return $.ajax({
        url: `/api/game/level/${room.game_level_uid}`,
        method: "GET",
        success: function (levelData) {
            levels[room.game_level_uid] = levelData;
        }
    })
}

// 게임 리스트 요청
function gameList() {
    $.ajax({
        url: '/api/game/list/type',
        type: 'GET',
        data: {type:"MULTI"},
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

// 게임 난이도 정보 요청
function levelList() {
    $('#game_uid').on('change', function() {
        const uid = $(this).val();
        if(!uid) return;

        $.ajax({
            url: `/api/game/levels/by-game/${uid}`,
            type: 'GET',
            success: function(levels) {
                $('#game_level_uid').empty().append(`<option value="">난이도를 선택하세요</option>`);

                levels.forEach(level => {
                    $('#game_level_uid').append(
                        $('<option>', {
                            value: level.uid,
                            text: level.level
                        })
                    );
                });
            }
        });

        $('#game_level_uid').on('change', function() {
            const levelId = $(this).val();
            if (!levelId) {
                $('#game_reward').text('');
                return;
            }

            $.ajax({
                url: `/api/game/level/${levelId}`,  // 난이도 상세 조회 API
                type: 'GET',
                success: function(level) {
                    // level 객체에 배당률 reward 필드가 있다고 가정
                    $('#game_reward').text(`배당률: ${level.reward}`);
                },
                error: function() {
                    $('#game_reward').text('배당률 정보를 불러오는데 실패했습니다.');
                }
            });
        });
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

        minBet = parseInt($('#min_bet').val());

        if(minBet > userPoint) {
            alert(`최소 베팅 금액은 보유 포인트(${userPoint}P)를 초과할 수 없습니다.`);
            return;
        }

        const payload = {
            title: $('#title').val(),
            min_bet: minBet,
            game_uid: $('#game_uid').val(),
            game_level_uid: $('#game_level_uid').val()
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

let userPoint = 0;

// 보유 포인트 요청
function userPointBalance() {
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
            userPoint = user.point_balance;
            $('#min_bet').attr('max', userPoint); // 최대값 제한
            $('#user-point-info').text(`보유 포인트: ${userPoint}P`);
        }
    });
}