<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="points" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-3">내역</span>
		<span class="col-span-2">잔액</span>
		<span>종류</span>
		<span class="col-span-3">비고</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 border-b-2 border-gray-7 mb-6">
		<div id="pointHistoryList"></div>
	</div>
	<div class="flex justify-center items-center">
		<div class="flex items-center">
			<button class="w-8 h-8 rounded-s border border-gray-1 text-gray-1 hover:bg-gray-2"><</button>
			<button class="w-8 h-8 bg-gray-2 border border-gray-1">1</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">2</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">3</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">4</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">5</button>
			<button class="w-8 h-8 rounded-e border border-gray-1 hover:bg-gray-2">></button>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function () {
	    const token = localStorage.getItem('accessToken');
	    const pointHistoryContainer = $("#pointHistoryList");
	
	    if (!token) {
	        alert("로그인이 필요합니다.");
	        window.location.href = "/";
	        return;
	    }
	
	    // 🟦 게임 이름 매핑 (gh_uid → name) 
	    // 얘도 getname으로 불러오기 (game_history uid로 game 이름 조회)
	    const gameNameMap = {
			"21ab8616b4a14632981fbd8f421756ec": "Turtle Run"
	    };
	
	    // 🔹 API 호출
	    function loadPointHistory(token) {
	        $.ajax({
	            url: '/api/history/point/list',
	            method: 'GET',
	            headers: {
	                'Authorization': 'Bearer ' + token
	            },
	            success: function (histories) {
	                renderPointHistory(histories);
	            },
	            error: function () {
	                alert("포인트 히스토리를 불러오는 데 실패했습니다.");
	            }
	        });
	    }
	
	    // 🔹 렌더링 함수
	    function renderPointHistory(histories) {
	        pointHistoryContainer.empty();
	
	        if (!histories || histories.length === 0) {
	            pointHistoryContainer.html(`<div class="text-center text-gray-500 py-6">포인트 기록이 없습니다.</div>`);
	            return;
	        }
	
	        histories.forEach((history, idx) => {
	            const number = idx + 1;
	            const typeKorMap = {
	                "CHARGE": "충전",
	                "USE": "사용",
	                "WIN": "승리",
	                "LOSE": "패배"
	            };
	
	            const typeText = typeKorMap[history.type] || "기타";
	            const isPositive = (history.type === "CHARGE" || history.type === "WIN");
	            const amountSign = isPositive ? "+" : "-";
	            const amountClass = isPositive ? "text-blue-1" : "text-red-1";
	            const typeClass = amountClass;
	
	            const amountText = `\${amountSign}\${history.amount}`;
	            const balanceText = history.balance_after;
	            const date = new Date(history.created_at).toISOString().slice(0, 10).replace(/-/g, ".");
	
	            const note = history.gh_uid ? (gameNameMap[history.gh_uid] || "Unknown") : "";
	
	            const html = `
	                <div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
	                    <span class="font-light">\${number}</span>
	                    <span class="col-span-3 \${amountClass}">\${amountText}</span>
	                    <span class="col-span-2 font-light">\${balanceText}</span>
	                    <span class="\${typeClass}">\${typeText}</span>
	                    <span class="col-span-3 font-light">\${note}</span>
	                    <span class="col-span-2 font-light">\${date}</span>
	                </div>
	            `;
	
	            pointHistoryContainer.append(html);
	        });
	    }
	
	    // 🔄 유효성 검증 → 포인트 내역 불러오기
	    $.ajax({
	        url: '/api/user/me',
	        method: 'GET',
	        headers: {
	            'Authorization': 'Bearer ' + token
	        },
	        success: function () {
	            loadPointHistory(token);
	        },
	        error: function () {
	            alert("로그인 정보가 유효하지 않습니다.");
	            window.location.href = "/";
	        }
	    });
	});
</script>
