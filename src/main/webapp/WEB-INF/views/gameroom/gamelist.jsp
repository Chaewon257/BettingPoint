<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- EL 해석 방지 설정 --%>
<%@ page isELIgnored="true" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<html>
<head>
    <title>게임방 리스트</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>

<h2>게임 방 리스트</h2>

<div id="room-container">
    <!-- 여기 안에 방 목록이 렌더링됩니다 -->
</div>

<script>
    $(function () {
        let gamerooms = []; // 게임방 리스트
        let games = {}; // 게임 정보
        let playerCounts = {}; // 각 게임방 플레이어 수

        $.ajax({
            url: "/api/gameroom/list",
            method: "GET",
            success: function (responseData) {
                gamerooms = responseData;

                let requests = [];

                // 게임 상세정보 요청들
                gamerooms.forEach(room => {
                    let req = $.ajax({
                        url: `/api/game/detail/${room.game_uid}`,
                        method: "GET",
                        success: function (gameData) {
                            games[room.game_uid] = gameData;
                        }
                    });
                    requests.push(req);
                });

                // 플레이어 수 요청
                let playerReq = $.ajax({
                    url: "/api/player/count",
                    method: "GET",
                    success: function (countData) {
                        playerCounts = countData;
                    }
                });
                requests.push(playerReq);

                // $.when.apply($, requests).done(function() {
                //     // 모든 데이터 다 받았으니 화면 그리기 함수 호출
                //     renderRooms(gamerooms, games, playerCounts);
                // });
            }
        });
    });
    <%--function renderRooms(gamerooms, games, playerCounts) {--%>
    <%--    const container = document.getElementById('room-container');--%>
    <%--    container.innerHTML = ''; // 초기화--%>

    <%--    gamerooms.forEach(room => {--%>
    <%--        const gameData = games[room.game_uid];--%>
    <%--        const playerCount = playerCounts[room.uid];--%>

    <%--        const roomDiv = document.createElement('div');--%>
    <%--        roomDiv.classList.add('room-card');--%>

    <%--        roomDiv.innerHTML = `--%>
    <%--        <h3>${room.title}</h3>--%>
    <%--        <p><strong>최소 베팅 포인트:</strong> ${room.min_bet} point</p>--%>
    <%--        <p><strong>참여 인원:</strong> ${playerCount} / 8</p>--%>
    <%--        <p><strong>상태:</strong> ${room.status}</p>--%>
    <%--        <div class="game-info">--%>
    <%--            <p><strong>게임 이름:</strong> ${gameData ? gameData.name : '정보 없음'}</p>--%>
    <%--            <p><strong>난이도:</strong> ${gameData ? gameData.level : '-'}</p>--%>
    <%--            <p><strong>상태:</strong> ${gameData ? gameData.status : '-'}</p>--%>
    <%--        </div>--%>
    <%--    `;--%>

    <%--        container.appendChild(roomDiv);--%>
    <%--    });--%>
    <%--}--%>
</script>
</body>
</html>
