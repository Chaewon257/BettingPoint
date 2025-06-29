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
		<div id="gamePagenation" class="flex items-center"></div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function () {
		const token = localStorage.getItem('accessToken');
		const historyContainer = $("#gameHistoryList");
		
		const paginationContainer = $("#gamePagenation");  // 페이지 버튼 감싸는 div
		const itemsPerPage = 10;
		let currentPage = 1;
		let totalCount = 0;
	
		if (!token) {
			alert("로그인이 필요합니다.");
			window.location.href = "/";
			return;
		}
	
		// 🔹 API 호출
		function loadGameHistory(token, page) {
			$.ajax({
				url: `/api/history/game/list?page=\${page}`,
				method: 'GET',
				headers: {
					'Authorization': 'Bearer ' + token
				},
				success: function (res) {
					const histories = res.histories;
					totalCount = res.total;
					renderGameHistory(histories, page);
					renderPagination(page, totalCount); // 페이지 버튼 그리기
				},
				error: function () {
					alert("게임 히스토리를 불러오는 데 실패했습니다.");
				}
			});
		}
	
		// 🔹 히스토리 렌더링
		function renderGameHistory(histories, page) {
			historyContainer.empty();
	
			if (!histories || histories.length === 0) {
				historyContainer.html(`<div class="text-center text-gray-500 py-6">게임 기록이 없습니다.</div>`);
				return;
			}
	
			histories.forEach((history, idx) => {


				const number = (page - 1) * itemsPerPage + idx + 1;
				
				
				const gameName = history.game_name || "Unknown Game";    
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
		
		// 🔹 페이지네이션 렌더링
		function renderPagination(current, totalCount) {
			paginationContainer.empty();
			const maxPages = Math.ceil(totalCount / itemsPerPage);
			const paginationHTML = [];

			// Prev
			paginationHTML.push(`
				<button class="w-8 h-8 rounded-s border border-gray-1 
						\${current <= 1 ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' 
										: 'hover:bg-gray-2'}"
				        \${current <= 1 ? 'disabled' : ''}
				        onclick="changePage(\${current - 1})">&lt;</button>
			`);

			for (let i = 1; i <= maxPages; i++) {
				paginationHTML.push(`
					<button class="w-8 h-8 \${i === current ? 'bg-gray-2' : 'hover:bg-gray-2'} border border-gray-1"
					        onclick="changePage(\${i})">\${i}</button>
				`);
			}

			// Next
			paginationHTML.push(`
				<button class="w-8 h-8 rounded-e border border-gray-1 
						\${current >= maxPages ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' 
												: 'hover:bg-gray-2'}"
						\${current >= maxPages ? 'disabled' : ''}
				        onclick="changePage(\${current + 1})">&gt;</button>
			`);

			paginationContainer.html(paginationHTML.join(""));
		}
		
		// 🔹 페이지 변경
		window.changePage = function (page) {
			if (page < 1) return;
			currentPage = page;
			loadGameHistory(token, currentPage);
		};
	
		// 🔄 토큰 유효성 확인 후 로딩
		$.ajax({
			url: '/api/user/me',
			method: 'GET',
			headers: {
				'Authorization': 'Bearer ' + token
			},
			success: function () {
				loadGameHistory(token, currentPage);
			},
			error: function () {
				alert("로그인 정보가 유효하지 않습니다.");
				window.location.href = "/";
			}
		});
	});

</script>
