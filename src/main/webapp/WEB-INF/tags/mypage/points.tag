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
	
	    
	
	 	// 🔹 API 호출
	    function loadPointHistory(token, page) {
	        $.ajax({
	            url: `/api/history/point/list?page=\${page}`,
	            method: 'GET',
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
				
	            const historyAmount = Number(history.amount).toLocaleString();
	            const amountText = `\${amountSign}\${historyAmount}`;
	            const balanceText = Number(history.balance_after).toLocaleString();
	            const date = formatDate(history.created_at);
	

	            const note = history.game_name || "Unknown";

	
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
	    
	 // 🔹 포인트 히스토리 페이지네이션 렌더링 (그룹 단위)
	    function renderPointPagination(current, totalCount) {
	        paginationContainer.empty();
	        const maxPages = Math.ceil(totalCount / itemsPerPage);
	        const pagesPerGroup = 5; // 한 그룹에 보여줄 페이지 수
	        
	        // 현재 페이지가 속한 그룹 계산
	        const currentGroup = Math.ceil(current / pagesPerGroup);
	        const startPage = (currentGroup - 1) * pagesPerGroup + 1;
	        const endPage = Math.min(startPage + pagesPerGroup - 1, maxPages);
	        
	        const paginationHTML = [];
	        
	        // 맨 처음 페이지 버튼 (<<)
	        const isFirstPage = current === 1;
	        paginationHTML.push(
	            '<button class="w-8 h-8 rounded-s border border-gray-1 ' +
	            (isFirstPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
	            (isFirstPage ? ' disabled' : '') +
	            ' onclick="changePointPage(1)" title="맨 처음 페이지">&lt;&lt;</button>'
	        );
	        
	        // Prev 버튼
	        const isFirstPageInGroup = current === startPage;
	        const prevPage = isFirstPageInGroup ? startPage - 1 : current - 1;
	        
	        paginationHTML.push(
	            '<button class="w-8 h-8 border border-gray-1 ' +
	            (isFirstPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
	            (isFirstPage ? ' disabled' : '') +
	            ' onclick="changePointPage(' + prevPage + ')" title="이전 페이지">&lt;</button>'
	        );
	        
	        // 페이지 번호들
	        for (let i = startPage; i <= endPage; i++) {
	            paginationHTML.push(
	                '<button class="w-8 h-8 ' + (i === current ? 'bg-gray-2' : 'hover:bg-gray-2') + ' border border-gray-1"' +
	                ' onclick="changePointPage(' + i + ')">' + i + '</button>'
	            );
	        }
	        
	        // Next 버튼
	        const isLastPage = current === maxPages;
	        const isLastPageInGroup = current === endPage;
	        const nextPage = isLastPageInGroup ? endPage + 1 : current + 1;
	        
	        paginationHTML.push(
	            '<button class="w-8 h-8 border border-gray-1 ' +
	            (isLastPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
	            (isLastPage ? ' disabled' : '') +
	            ' onclick="changePointPage(' + nextPage + ')" title="다음 페이지">&gt;</button>'
	        );
	        
	        // 맨 마지막 페이지 버튼 (>>)
	        paginationHTML.push(
	            '<button class="w-8 h-8 rounded-e border border-gray-1 ' +
	            (isLastPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
	            (isLastPage ? ' disabled' : '') +
	            ' onclick="changePointPage(' + maxPages + ')" title="맨 마지막 페이지">&gt;&gt;</button>'
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
