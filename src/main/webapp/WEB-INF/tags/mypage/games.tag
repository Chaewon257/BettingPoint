<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="games"
	class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div
		class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span> <span class="col-span-5">게임 이름</span> <span>결과</span>
		<span class="col-span-3">포인트 변동</span> <span class="col-span-2">날짜</span>
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
				
				// 🔹 숫자에 콤마 추가
				const bettingAmount = Number(history.betting_amount).toLocaleString();
				const pointValue = Number(history.point_value).toLocaleString();				
				const pointChange = `(\${sign}\${pointValue})`;
				
				const date = formatDate(history.created_at);
								
				const html = `
					<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
						<span class="font-light">\${number}</span>
						<span class="col-span-5">\${gameName}</span>
						<span class="\${resultClass}">\${result}</span>
						<div class="col-span-3 flex flex-col sm:flex-row items-center justify-center">
							<span class="font-light">\${bettingAmount}</span>
							<span class="\${resultClass}">\${pointChange}</span>
						</div>
						<span class="col-span-2 font-light">\${date}</span>
					</div>
				`;
	
				historyContainer.append(html);
			});
		}
		
		//게임 히스토리 페이지네이션 렌더링 (그룹 단위)
		function renderPagination(current, totalCount) {
		    paginationContainer.empty();
		    const maxPages = Math.ceil(totalCount / itemsPerPage);
		    const pagesPerGroup = 5; // 한 그룹에 보여줄 페이지 수
		    
		    // 현재 페이지가 속한 그룹 계산
		    const currentGroup = Math.ceil(current / pagesPerGroup);
		    const startPage = (currentGroup - 1) * pagesPerGroup + 1;
		    const endPage = Math.min(startPage + pagesPerGroup - 1, maxPages);
		    
		    const paginationHTML = [];
		    
		    // << 버튼 (이전 그룹의 첫 페이지로)
		    const isFirstGroup = currentGroup === 1;
		    const prevGroupFirstPage = isFirstGroup ? 1 : (currentGroup - 2) * pagesPerGroup + 1;
		    
		    paginationHTML.push(
		        '<button class="w-8 h-8 border border-gray-1 ' +
		        (isFirstGroup ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
		        (isFirstGroup ? ' disabled' : '') +
		        ' onclick="changePage(' + prevGroupFirstPage + ')" title="이전 그룹">&lt;&lt;</button>'
		    );
		    
		    // < 버튼 (이전 페이지)
		    const isFirstPage = current === 1;
		    const prevPage = current - 1;
		    
		    paginationHTML.push(
		        '<button class="w-8 h-8 rounded-s border border-gray-1 ' +
		        (isFirstPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
		        (isFirstPage ? ' disabled' : '') +
		        ' onclick="changePage(' + prevPage + ')">&lt;</button>'
		    );
		    
		    // 페이지 번호들
		    for (let i = startPage; i <= endPage; i++) {
		        paginationHTML.push(
		            '<button class="w-8 h-8 ' + (i === current ? 'bg-gray-2' : 'hover:bg-gray-2') + ' border border-gray-1"' +
		            ' onclick="changePage(' + i + ')">' + i + '</button>'
		        );
		    }
		    
		    // > 버튼 (다음 페이지)
		    const isLastPage = current === maxPages;
		    const nextPage = current + 1;
		    
		    paginationHTML.push(
		        '<button class="w-8 h-8 rounded-e border border-gray-1 ' +
		        (isLastPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
		        (isLastPage ? ' disabled' : '') +
		        ' onclick="changePage(' + nextPage + ')">&gt;</button>'
		    );
		    
		    // >> 버튼 (다음 그룹의 첫 페이지로)
		    const isLastGroup = endPage === maxPages;
		    const nextGroupFirstPage = isLastGroup ? maxPages : currentGroup * pagesPerGroup + 1;
		    
		    paginationHTML.push(
		        '<button class="w-8 h-8 border border-gray-1 ' +
		        (isLastGroup ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
		        (isLastGroup ? ' disabled' : '') +
		        ' onclick="changePage(' + nextGroupFirstPage + ')" title="다음 그룹">&gt;&gt;</button>'
		    );
		    
		    paginationContainer.html(paginationHTML.join(""));
		}
		
		
		// 날짜 포맷팅 함수 (yyyy.mm.dd)
		function formatDate(dateStr) {
		    if (!dateStr) return "-";
		    const date = new Date(dateStr);
		    if (isNaN(date)) return "-";
		    return date.toLocaleDateString('ko-KR').replace(/\./g, '.').replace(/\s/g, '');
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
