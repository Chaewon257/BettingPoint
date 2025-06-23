<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<html>
<head>
    <title>게임방 리스트</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${cpath}/resources/js/turtlegameroom.js"></script>
    <style>
        .game-room {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 5px;
            cursor: pointer;
        }
        .game-room:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>

<h2>게임 방 리스트</h2>
<button id="create-room-btn">게임방 생성</button>
<script>
    $('#create-room-btn').on('click', function() {
        location.href = '/gameroom/insert'; // 경로에 맞게 수정
    });
</script>
<div id="room-container">로딩 중...</div>

<script>
    $(function () {
        gameRoomList(); // 이 함수가 데이터 요청 + 렌더링까지 모두 처리
    });
</script>

</body>
</html>