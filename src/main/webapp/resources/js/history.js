// 게임 히스토리 목록 조회
function gameHistoryList(page=1) {
    const token = localStorage.getItem("accessToken");
    if(!token) {
        alert("로그인이 필요합니다.");
        return;
    }

    return $.ajax({
        url: `/api/history/game/list?page=${page}`,
        method: "GET",
        headers: {
            "Authorization": "Bearer " + token
        }
    });
}

// 포인트 히스토리 목록 조회
function pointHistoryList(page=1) {
    const token = localStorage.getItem("accessToken");
    if(!token) {
        alert("로그인이 필요합니다.");
        return;
    }

    return $.ajax({
        url: `/api/history/point/list?page=${page}`,
        method: "GET",
        headers: {
            "Authorization": "Bearer " + token
        }
    });
}

// 게임 히스토리 저장
// 이것만 호출하면 게임 히스토리 저장 후 포인트 히스토리 자동 저장합니다.
function saveGameHistory() {
    const token = localStorage.getItem("accessToken");
    if(!token) {
        alert("로그인이 필요합니다.");
        return;
    }

    // 변수 동적으로 추출해서 가져와야 합니다.
    const historyData = {
        game_uid: gameUid,
        betting_amount: bettingAmount,
        game_result: gameResult,
        point_value: pointValue
    };

    return $.ajax({
        url: "/api/history/game/insert",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(historyData),
        headers: {
            "Authorization": "Bearer " + token
        },
        success: function (gamehistory) {
            userPointChange(gamehistory.game_result, pointValue, token, function () {
                userPointBalance(token, function (point) {
                    savePointHistory(gamehistory, point);
                });
            });
        }
    });
}

// 포인트 히스토리 저장
function savePointHistory(gamehistory, point) {
    const token = localStorage.getItem("accessToken");
    if(!token) {
        alert("로그인이 필요합니다.");
        return;
    }

    const historyData = {
        type: gamehistory.game_result,
        amount: gamehistory.point_value,
        balance_after: point,
        gh_uid: gamehistory.uid
    };

    return $.ajax({
        url: "/api/history/point/insert",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(historyData),
        headers: {
            "Authorization": "Bearer " + token
        }
    });
}

// 보유 포인트 요청
function userPointBalance(token, callback) {
    $.ajax({
        url: '/api/user/me',
        type: 'GET',
        headers: {
            'Authorization': 'Bearer ' + token
        },
        success: function(user) {
            callback(user.point_balance);
        }
    });
}

// 사용자 포인트 변동
function userPointChange(gameResult, point, token, callback) {
    let url = null;

    if (gameResult === "WIN") {
        url = "/api/user/get";
    } else if (gameResult === "LOSE") {
        url = "/api/user/lose";
    }

    if (!url) {
        console.warn("알 수 없는 게임 결과:", gameResult);
        if (typeof callback === "function") callback();
        return;
    }

    $.ajax({
        url: url,
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ point: point }),
        headers: {
            "Authorization": "Bearer " + token
        },
        success: function () {
            console.log("포인트 변경 완료:", gameResult);
            if (typeof callback === "function") callback();
        },
        error: function () {
            console.error("포인트 변경 실패:", gameResult);
        }
    });
}