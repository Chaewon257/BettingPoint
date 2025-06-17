<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 17.
  Time: 오후 2:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- EL 해석 방지 설정 --%>
<%@ page isELIgnored="true" %>
<%--<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>--%>

<html>
<head>
    <title>게임방 리스트</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .room-card {
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
            width: 300px;
            background-color: #f5f5f5; /* 임시 배경색 추가 */
        }
    </style>
</head>
<body>

<h2>게임 방 리스트</h2>

<div id="room-container">
    <!-- 여기 안에 방 목록이 렌더링됩니다 -->
</div>

<script>
    $(function() {
        $.ajax({
            url: "/api/gameroom",
            method: "GET",
            success: gameroomList
        });
    });

    function gameroomList(responseData) {
        const container = document.getElementById('room-container');
        container.innerHTML = ''; // 기존 내용 비우기

        $.each(responseData, function(index, room) {
            let html = `
                <div class="room-card">
                    <h3>${room.title}</h3>
                    <p><strong>최소 베팅 포인트:</strong> ${room.min_bet} point</p>
                    <p><strong>참여 인원:</strong> ${room.players} / 8</p>
                    <p><strong>상태:</strong> ${room.status}</p>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', html);
        });
    }
</script>
</body>
</html>
