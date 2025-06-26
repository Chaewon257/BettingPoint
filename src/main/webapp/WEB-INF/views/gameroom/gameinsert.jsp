<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게임방 생성</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${cpath}/resources/js/gameroomlist.js"></script>
</head>
<body>
<h2>게임방 생성</h2>
<form id="create-room-form">
    <label>방 이름: <input type="text" id="title" name="title" required/></label><br/>
    <label>최소 베팅: <input type="number" id="min_bet" name="min_bet" required/></label>
    <span id="user-point-info"></span><br/>
    <label>게임 선택:
        <select id="game_uid" name="game_uid" required>
            <option value="">게임을 선택하세요</option>
        </select>
    </label><br/>
    <label>게임 난이도:
        <select id="game_level_uid" name="game_level_uid" required>
            <option value="">난이도를 선택하세요</option>
        </select>
    </label><br/>
    <span id="game_reward"></span><br/>
    <button type="submit">생성</button>
</form>
<script>
    $(function () {
        gameList();
        levelList();
        userPointBalance();
        createRoom();
    });
</script>
</body>
</html>
