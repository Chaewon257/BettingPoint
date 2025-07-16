<%@ tag language="java" pageEncoding="UTF-8"%>

<div class="w-full grid grid-cols-1 lg:grid-cols-5 mt-5">
	<div class="col-span-4 w-full h-full flex flex-col gap-y-4 bg-gray-8 p-4">
		<!-- 제목 -->
		<span id="notice-title" class="text-3xl font-extrabold">게시판 제목은 여기 들어가요</span>
		
		<!-- 작성자, 조회수, 날짜 -->
		<div class="grid grid-cols-8 text-gray-3 font-light text-xs sm:text-sm md:text-base">
			<span id="notice-writer" class="col-span-5 text-start">작성자이름</span>
			<div class="flex items-center justify-center gap-x-2">
				<img alt="view image" src="${cpath}/resources/images/view.png" class="w-4">
				<span id="notice-views">100</span>
			</div>
			<span id="notice-date" class="col-span-2 text-end">2025.06.23</span>
		</div>
		
		<!-- 본문 -->
		<div class="w-full h-96 bg-white p-2 overflow-y-scroll">
			<div id="notice-content" class="list-inside">
				**게시판 내용은 여기에 들어가요!!****게시판 내용은 여기에 들어가요!!**
			</div>
		</div>
	</div>
	<div class="col-span-1 flex lg:flex-col items-center justify-end gap-4 bg-blue-4 p-4 font-bold text-white text-base md:text-lg lg:text-xl">
		<button class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5" onclick="goBackToNotice()">뒤로가기</button>
	</div>
</div>

<script>

function goBackToNotice() {
	removeUidFromUrl();
    // 공지사항 탭 버튼을 클릭한 것처럼 처리
    $('.tab-btn[data-tab="notice"]').trigger('click');
}

function removeUidFromUrl() {
    const url = new URL(location.href);
    url.searchParams.delete('uid');
    history.replaceState(null, '', url.pathname); // → "/support"
}

function formatDate(dateStr) {
    if (!dateStr) return "-";
    const date = new Date(dateStr);
    if (isNaN(date)) return "-";
    return date.toLocaleDateString('ko-KR').replace(/\s/g, '').replace(/\.$/, '');
}
</script>