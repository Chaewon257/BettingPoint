<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="games" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-5">게임 이름</span>
		<span>결과</span>
		<span class="col-span-3">포인트 변동</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 border-b-2 border-gray-7 mb-6">
		<div id="gameHistoryList"></div>
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
		const historyContainer = $("#gameHistoryList");
	
		if (!token) {
			alert("로그인이 필요합니다.");
			window.location.href = "/";
			return;
		}
	
		// 🟦 게임 이름 매핑 (서버에서 DTO에 포함되면 생략 가능)
		// 매핑하지 말고 getName 불러와서 (나중에) 해야됨
		const gameNameMap = {
			"f47ac10b58cc4372a5670e02b2c3d479": "Coin Toss",
			"0a644307148b4446857a624dc2a6e3b2": "Turtle Run"
			// 필요시 계속 추가
		};
	
		// 🔹 API 호출
		function loadGameHistory(token) {
			$.ajax({
				url: '/api/history/game/list',
				method: 'GET',
				headers: {
					'Authorization': 'Bearer ' + token
				},
				success: function (histories) {
					renderGameHistory(histories);
				},
				error: function () {
					alert("게임 히스토리를 불러오는 데 실패했습니다.");
				}
			});
		}
	
		// 🔹 히스토리 렌더링
		function renderGameHistory(histories) {
			historyContainer.empty();
	
			if (!histories || histories.length === 0) {
				historyContainer.html(`<div class="text-center text-gray-500 py-6">게임 기록이 없습니다.</div>`);
				return;
			}
	
			histories.forEach((history, idx) => {
				const number = idx + 1;
				const gameName = gameNameMap[history.game_uid] || "Unknown Game";
				const result = history.game_result === "WIN" ? "승리" : "패배";
				const resultClass = history.game_result === "WIN" ? "text-blue-1" : "text-red-1";
				const sign = history.game_result === "WIN" ? "+" : "-";
				const pointChange = `(\${sign}\${history.point_value})`;
				const date = new Date(history.created_at).toISOString().slice(0, 10).replace(/-/g, ".");
				
				
				const html = `
					<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
						<span class="font-light">\${number}</span>
						<span class="col-span-5">\${gameName}</span>
						<span class="\${resultClass}">\${result}</span>
						<div class="col-span-3 flex flex-col sm:flex-row items-center justify-center">
							<span class="font-light">\${history.betting_amount}</span>
							<span class="\${resultClass}">\${pointChange}</span>
						</div>
						<span class="col-span-2 font-light">\${date}</span>
					</div>
				`;
	
				historyContainer.append(html);
			});
		}
	
		// 🔄 토큰 유효성 확인 후 로딩
		$.ajax({
			url: '/api/user/me',
			method: 'GET',
			headers: {
				'Authorization': 'Bearer ' + token
			},
			success: function () {
				loadGameHistory(token);
			},
			error: function () {
				alert("로그인 정보가 유효하지 않습니다.");
				window.location.href = "/";
			}
		});
	});

</script>
