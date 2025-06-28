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
		<div id="pointPagination" class="flex items-center"></div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function () {
	    const token = localStorage.getItem('accessToken');
	    const pointHistoryContainer = $("#pointHistoryList");
	    
	    const paginationContainer = $("#pointPagination");
	    const itemsPerPage = 10;
	    let currentPage = 1;
	    let totalCount = 0;
	
	    if (!token) {
	        alert("로그인이 필요합니다.");
	        window.location.href = "/";
	        return;
	    }
	
	    // 🟦 게임 이름 매핑 (gh_uid → name) 
	    // 얘도 getname으로 불러오기 (game_history uid로 game 이름 조회)
	    const gameNameMap = {
			"21ab8616b4a14632981fbd8f421756ec": "Turtle Run",
			"76867ded4d104a05bf1aef0252b2ec42": "Coin Toss",
			"0f82ca829f9c43458b05221b8b2c8480": "Coin Toss"
	    };
	
	 	// 🔹 API 호출
	    function loadPointHistory(token, page) {
	        $.ajax({
	            url: `/api/history/point/list?page=\${page}`,
	            method: 'GET',
	            headers: {
	                'Authorization': 'Bearer ' + token
	            },
	            success: function (res) {
	                const histories = res.histories;
	                totalCount = res.total;
	                renderPointHistory(histories, page);
	                renderPointPagination(page, totalCount);
	            },
	            error: function () {
	                alert("포인트 히스토리를 불러오는 데 실패했습니다.");
	            }
	        });
	    }
	
	    // 🔹 렌더링 함수
	    function renderPointHistory(histories, page) {
	        pointHistoryContainer.empty();
	
	        if (!histories || histories.length === 0) {
	            pointHistoryContainer.html(`<div class="text-center text-gray-500 py-6">포인트 기록이 없습니다.</div>`);
	            return;
	        }
	
	        histories.forEach((history, idx) => {
	        	const number = (page - 1) * itemsPerPage + idx + 1;
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
	    
	 	// 🔹 페이지네이션 버튼 렌더링
	    function renderPointPagination(current, totalCount) {
	        const maxPages = Math.ceil(totalCount / itemsPerPage);
	        paginationContainer.empty();
	        const paginationHTML = [];

	        paginationHTML.push(`
	            <button class="w-8 h-8 rounded-s border border-gray-1 
						\${current <= 1 ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' 
								: 'hover:bg-gray-2'}"
		        		\${current <= 1 ? 'disabled' : ''}
	                    onclick="changePointPage(\${current - 1})">&lt;</button>
	        `);

	        for (let i = 1; i <= maxPages; i++) {
	        	paginationHTML.push(`
	                <button class="w-8 h-8 \${i === current ? 'bg-gray-2' : 'hover:bg-gray-2'} border border-gray-1"
                        	onclick="changePointPage(\${i})">\${i}</button>
	            `);
	        }

	        paginationHTML.push(`
	            <button class="w-8 h-8 rounded-e border border-gray-1 
						\${current >= maxPages ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' 
								: 'hover:bg-gray-2'}"
						\${current >= maxPages ? 'disabled' : ''}    
	                    onclick="changePointPage(\${current + 1})">&gt;</button>
	        `);

	        paginationContainer.html(paginationHTML.join(''));
	    }

	    // 🔹 페이지 변경 함수
	    window.changePointPage = function (page) {
	        if (page < 1) return;
	        currentPage = page;
	        loadPointHistory(token, currentPage);
	    };
	
	    // 🔄 유효성 검증 → 포인트 내역 불러오기
	    $.ajax({
	        url: '/api/user/me',
	        method: 'GET',
	        headers: {
	            'Authorization': 'Bearer ' + token
	        },
	        success: function () {
	            loadPointHistory(token, currentPage);
	        },
	        error: function () {
	            alert("로그인 정보가 유효하지 않습니다.");
	            window.location.href = "/";
	        }
	    });
	});
</script>
