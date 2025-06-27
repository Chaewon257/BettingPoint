<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거북이 베팅 게임</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        #player-list, #chat-box {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div id="room-detail-container">
</div>
<div id="chat-box" style="margin-top: 20px;"></div>
<div id="game-controls">
    <h3>거북이 선택</h3>
    <div id="turtle-options">
        <label><input type="radio" name="turtle" value="1"> 🐢 1번</label>
        <label><input type="radio" name="turtle" value="2"> 🐢 2번</label>
        <label><input type="radio" name="turtle" value="3"> 🐢 3번</label>
        <label><input type="radio" name="turtle" value="4"> 🐢 4번</label>
        <label><input type="radio" name="turtle" value="5"> 🐢 5번</label>
        <label><input type="radio" name="turtle" value="6"> 🐢 6번</label>
        <label><input type="radio" name="turtle" value="7"> 🐢 7번</label>
        <label><input type="radio" name="turtle" value="8"> 🐢 8번</label>
    </div>

    <h3>베팅</h3>
    <input type="number" id="bet-point" placeholder="베팅 포인트 입력" />
    <button id="bet-btn">베팅하기</button>

    <h3>준비</h3>
    <button id="ready-btn">게임 준비</button>

    <h3>게임 시작</h3>
    <button id="start-game-btn">게임 시작</button>
</div>
<script src="${cpath}/resources/js/turtlegameroom.js"></script>
<script>
    $(function () {
        const roomId = "${roomId}";
        gameRoomDetail(roomId);
        bindGameEvents();

        // 게임 시작 버튼 클릭 이벤트
        $("#start-game-btn").click(function () {
            $.ajax({
                url: `/api/gameroom/start/${roomId}`,
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify({ status: "PLAYING" }),
                success: function () {
                    // 게임 페이지로 리다이렉션
                    socket.send(JSON.stringify({
                        type: "start"
                    }));
                },
                error: function () {
                    alert("게임 시작에 실패했습니다.");
                }
            });
        });
    });
</script>
</body>
</html>