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
<script src="${cpath}/resources/js/turtlegameroom.js"></script>
<script>
    $(function () {
        const roomId = "${roomId}";
        connectGameWebSocket(roomId);
        gameRoomDetail(roomId);
    });
</script>
</body>
</html>