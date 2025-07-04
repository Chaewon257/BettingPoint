<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<div data-content="questions" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-5">문의 내용</span>
		<span class="col-span-2">상태</span>
		<span class="col-span-2">상세</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 border-b-2 border-gray-7 mb-6">
		<div id="chatlogList"></div>
	</div>
	<div class="flex justify-center items-center">
		<div id="chatlogPagination" class="flex items-center"></div>
	</div>
</div>
<ui:modal modalId="questionsDetailModal" title="문의내역 상세보기">
	<jsp:attribute name="content">
		<div class="py-4 px-2 sm:w-[36rem] md:w-[48rem] min-w-72 flex flex-col gap-y-4">
		
			<div class="text-lg font-semibold flex justify-between">
			  <span id="chatDetailTitle">제목</span>
			  <span id="chatDetailDate" class="text-sm text-gray-500">2025.06.25</span>
			</div>
			
			<div class="mt-4">
			  <h4 class="font-semibold mb-1">문의 내용</h4>
			  <p id="chatDetailQuestion" class="text-sm text-gray-700"></p>
			</div>
			
			<div class="mt-4">
			  <h4 class="font-semibold mb-1">답변</h4>
			  <p id="chatDetailAnswer" class="text-sm text-gray-700"></p>
			  <p class="text-xs text-right text-gray-400 mt-1">답변일시: <span id="chatDetailResponseDate">-</span></p>
			</div>
			
		</div>
	</jsp:attribute>
</ui:modal>

<script type="text/javascript">
	$(document).ready(function () {
		const token = localStorage.getItem('accessToken');
		const logListContainer = $("#chatlogList");
		
		const paginationContainer = $("#chatlogPagination");
	    const itemsPerPage = 10;
	    let currentPage = 1;
	    let totalCount = 0;
	
		if (!token) {
			alert("로그인이 필요합니다.");
			window.location.href = "/";
			return;
		}
	
		// 사용자 문의 내역 가져오기
		function loadChatLogs(token, page) {
			$.ajax({
				url: `/api/chatlog?page=\${page}`,
				method: 'GET',
				headers: {
					'Authorization': 'Bearer ' + token
				},
				success: function (res) {
					const logs  = res.logs ;
	                totalCount = res.total;
	                renderChatLogs(logs, page);
	                renderChatLogsPagination(page, totalCount);
				},
				error: function () {
					alert("문의 내역을 불러오는 데 실패했습니다.");
				}
			});
		}
	
		// 문의 내역 렌더링
		function renderChatLogs(logs, page) {
			logListContainer.empty();
	
			if (!logs || logs.length === 0) {
				logListContainer.html(`<div class="text-center text-gray-500 py-6">문의 내역이 없습니다.</div>`);
				return;
			}
	
			logs.forEach((log, idx) => {
				const number = (page - 1) * itemsPerPage + idx + 1;
				const title = log.title || "(제목 없음)";
				const status = log.response ? "답변완료" : "대기중";
				const statusClass = log.response ? "text-blue-1" : "";
				const date = formatDate(log.chat_date);
				const uid = log.uid;
				
				const html = `
					<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
						<span class="font-light">\${number}</span>
						<span class="col-span-5 truncate">\${title}</span>
						<span class="col-span-2 font-light \${statusClass}">\${status}</span>
						<button class="col-span-2 underline" onclick="openChatDetailModal('\${uid}')">상세보기</button>
						<span class="col-span-2 font-light">\${date}</span>
					</div>
				`;
	
				logListContainer.append(html);
			});
		}
		
		// 🔹 페이지네이션 렌더링
		function renderChatLogsPagination(current, totalCount) {
			paginationContainer.empty();
			const maxPages = Math.ceil(totalCount / itemsPerPage);
			const paginationHTML = [];

			paginationHTML.push(`
				<button class="w-8 h-8 rounded-s border border-gray-1 
						\${current <= 1 ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' 
								: 'hover:bg-gray-2'}"
		        		\${current <= 1 ? 'disabled' : ''}
						onclick="changeChatPage(\${current - 1})">&lt;</button>
			`);

			for (let i = 1; i <= maxPages; i++) {
				paginationHTML.push(`
					<button class="w-8 h-8 \${i === current ? 'bg-gray-2' : 'hover:bg-gray-2'} border border-gray-1"
							onclick="changeChatPage(\${i})">\${i}</button>
				`);
			}

			paginationHTML.push(`
				<button class="w-8 h-8 rounded-e border border-gray-1 
						\${current >= maxPages ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' 
								: 'hover:bg-gray-2'}"
						\${current >= maxPages ? 'disabled' : ''}    
	                    onclick="changeChatPage(\${current + 1})">&gt;</button>
			`);

			paginationContainer.html(paginationHTML.join(''));
		}

		// 🔹 페이지 변경
		window.changeChatPage = function (page) {
			if (page < 1) return;
			currentPage = page;
			loadChatLogs(token, currentPage);
		};
	
		// 🔄 Token 유효성 확인 → 문의 내역 불러오기
		$.ajax({
			url: '/api/user/me',
			method: 'GET',
			headers: {
				'Authorization': 'Bearer ' + token
			},
			success: function () {
				loadChatLogs(token, currentPage);
			},
			error: function () {
				alert("로그인 정보가 유효하지 않습니다.");
				window.location.href = "/";
			}
		});
	
	});
	
	function openChatDetailModal(chatlogUid) {
	    $.ajax({
	        url: `/api/chatlog/detail/\${chatlogUid}`,
	        method: 'GET',
	        success: function (res) {
	            // DOM 요소에 데이터 삽입
	            $('#chatDetailTitle').text(res.title || "(제목 없음)");
	            $('#chatDetailDate').text(formatDate(res.chat_date));
	            $('#chatDetailQuestion').html(res.question || "(질문 없음)");
	            $('#chatDetailAnswer').html(res.response || "(답변 없음)");
	            $('#chatDetailResponseDate').text(res.response_date ? formatDate(res.response_date) : "-");

	            // 모달 열기
	            document.getElementById('questionsDetailModal').classList.remove('hidden');
	        },
	        error: function () {
	            alert("문의 상세 정보를 불러오지 못했습니다.");
	        }
	    });
	}

	// 날짜 포맷팅 함수 (yyyy.mm.dd)
	function formatDate(dateStr) {
	    if (!dateStr) return "-";
	    const date = new Date(dateStr);
	    if (isNaN(date)) return "-";
	    return date.toLocaleDateString('ko-KR').replace(/\./g, '.').replace(/\s/g, '');
	}
	
	// 렌더링 끝난 뒤 이벤트 바인딩
	$(document).on('click', '.chat-detail-btn', function () {
	    const uid = $(this).data('uid');
	    openChatDetailModal(uid);
	});

	
</script>

