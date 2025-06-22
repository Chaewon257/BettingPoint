<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>게임방 생성</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<h2>게임방 생성</h2>
<form id="create-room-form">
    <label>방 이름: <input type="text" id="title" name="title" required/></label><br/>
    <label>최소 베팅: <input type="number" id="min_bet" name="min_bet" required/></label><br/>
    <label>게임 선택:
        <select id="game_uid" name="game_uid" required>
            <option value="">게임을 선택하세요</option>
        </select>
    </label><br/>
    <button type="submit">생성</button>
</form>
<div id="result"></div>

<script>
    $(document).ready(function() {
        $.ajax({
            url: '/api/game/list',
            type: 'GET',
            success: function(games) {
                games.forEach(function(game) {
                    $('#game_uid').append(
                        $('<option>', {
                            value: game.uid, // 실제 DTO의 필드명에 맞게 수정
                            text: game.name    // 실제 DTO의 필드명에 맞게 수정
                        })
                    );
                });
            }
        });
    });
</script>

<script>
    $('#create-room-form').on('submit', function (e) {
        e.preventDefault();

        const token = localStorage.getItem("accessToken");
        if (!token) {
            alert("로그인이 필요합니다.");
            return;
        }

        const payload = {
            title: $('#title').val(),
            min_bet: parseInt($('#min_bet').val(), 10),
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
            success: function (roomId) {
                $('#result').text('게임방이 생성되었습니다.');
                location.href = '/gameroom/detail/' + roomId;
            },
            error: function () {
                $('#result').text('생성 실패. 다시 시도하세요.');
            }
        });
    });
</script>
</body>
</html>
