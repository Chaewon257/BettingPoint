<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="info" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-3">제목</span>
		<span class="col-span-2">좋아요</span>
		<span class="col-span-2">조회</span>
		<span class="col-span-2">작성자</span>
		<span class="col-span-2">날짜</span>
	</div>
	 <!--JS로 채워질 영역-->
  <div id="boardList" class="grid grid-cols-1 border-b-2 border-gray-7 mb-6">
    
  </div>
  
	<div class="w-full flex justify-end items-center mb-4">
		<a id="writeBoard" href="/board/write" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">글쓰기</a>
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
</script>