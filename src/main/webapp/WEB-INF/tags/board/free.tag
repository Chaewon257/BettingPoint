<%@ tag language="java" pageEncoding="UTF-8"%>

<div class="w-full px-4 py-2 flex justify-end gap-x-5">
	<input type="hidden" id="sort" name="sort" value="created_at" />
	<button data-sort="created_at" class="sort-btn text-gray-7 underline">최신순</button>
	<button data-sort="like_count" class="sort-btn text-gray-3 hover:text-gray-7">좋아요순</button>
	<button data-sort="view_count" class="sort-btn text-gray-3 hover:text-gray-7">조회순</button>
</div>
<div class="w-full h-[2px] bg-gray-1"></div>
<div data-content="free" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-3">제목</span>
		<span class="col-span-2">좋아요</span>
		<span class="col-span-2">조회</span>
		<span class="col-span-2">작성자</span>
		<span class="col-span-2">날짜</span>
	</div>
	
	<div id="boardList" class="grid grid-cols-1 border-b-2 border-gray-7 mb-6">
    <!-- JS에서 렌더링 -->
    			<button data-notice="" class="board-view col-span-4 truncate hover:underline">로딩중...</button>
    
 	</div>
 	
	<!-- 버튼 / 페이지네이션 -->
	<div class="w-full flex justify-end items-center mb-4">
		<a id="writeBoard" href="/board/write" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">글쓰기</a>
	</div>
	<div class="flex justify-center items-center">
		<!-- 여기 id="paging"만 남겨두고 안의 버튼은 제거 -->
  		<div id="paging" class="flex items-center"></div>
	</div>
</div>
<script type="text/javascript">

	//accessToken으로 유저 정보 요청
	function getUserInfo(accessToken) {
		return $.ajax({
			url: '/api/user/me',
			method: 'GET',
			headers: {
				'Authorization': 'Bearer ' + accessToken
			},
			xhrFields: { withCredentials: true }
		});
	}
	
	// 보호된 링크 클릭 시 토큰 검사
	$("#writeBoard").on("click", function (e) {
		const target = $(this).attr("href");
		const token = localStorage.getItem("accessToken");
	
		// 토큰 없을 경우
		if (!token) {
			alert("로그인 후 이용 가능합니다.");
			e.preventDefault();
			return;
		}
	
		e.preventDefault(); // 유효성 검사 전 기본 이동 차단
	
		getUserInfo(token)
			.done(() => window.location.href = target)
			.fail(() => {
				alert("로그인 후 이용 가능합니다.");
			});
	});
	
	$(".sort-btn").on("click", function () {
		const selectedSort = $(this).data("sort");
		
		// 정렬 버튼 스타일 기본값으로 초기화
		$(".sort-btn").removeClass("text-gray-7 underline").addClass("text-gray-3 hover:text-gray-7");
		
		// 기본 정렬 값 적용 (created_at)
		$(this).removeClass("text-gray-3 hover:text-gray-7").addClass("text-gray-7 underline");		
	});
</script>