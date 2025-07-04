<%@ tag language="java" pageEncoding="UTF-8"%>

<div class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-4">제목</span>
		<span class="col-span-2">조회</span>
		<span class="col-span-2">작성자</span>
		<span class="col-span-3">날짜</span>
	</div>
	<div class="grid grid-cols-1 border-b-2 border-gray-7 mb-6">
		<div id="NoticeList"></div>
	</div>
	<div class="flex justify-center items-center">
		<div id="NoticePagination" class="flex items-center"></div>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
    const noticeContainer = $("#NoticeList"); // 공지사항 목록 출력 영역
    const paginationContainer = $("#NoticePagination");
    const itemsPerPage = 10;
    let currentPage = 1;
    let totalCount = 0;

    // 🔹 공지사항 목록 불러오기
    function loadNoticeList(page) {
        $.ajax({
            url: `/api/support/list/NOTICE?page=\${page}`,
            method: 'GET',
            success: function (res) {
                const notices = res.notices || res; // 응답이 리스트일 수도 있고, 객체일 수도 있음
                totalCount = res.total || notices.length;

                renderNoticeList(notices, page);
                renderNoticePagination(page, totalCount);
            },
            error: function () {
                noticeContainer.html(`<div class="text-center text-red-500 py-6">공지사항을 불러오는 데 실패했습니다.</div>`);
            }
        });
    }

    // 🔹 공지사항 렌더링
    function renderNoticeList(notices, page) {
        noticeContainer.empty();

        if (!notices || notices.length === 0) {
            noticeContainer.html(`<div class="text-center text-gray-500 py-6">공지사항이 없습니다.</div>`);
            return;
        }

        notices.forEach((notice, idx) => {
            const number = (page - 1) * itemsPerPage + idx + 1;
            const title = notice.title || "-";
            const views = notice.view_count || 0;
            const writer = notice.writer || "관리자";
            const date = formatDate(notice.created_at);

            const html = `
                <div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1 font-light">
                    <span>\${number}</span>
                    <button data-notice="\${notice.uid}" class="notice-view col-span-4 truncate hover:underline">\${title}</button>
                    <div class="col-span-2 flex items-center justify-center gap-x-2">
                        <img alt="service image" src="/resources/images/view.png" class="w-4">
                        <span>\${views}</span>
                    </div>
                    <span class="col-span-2">\${writer}</span>
                    <span class="col-span-3">\${date}</span>
                </div>
            `;

            noticeContainer.append(html);
        });
    }

    // 🔹 페이지네이션 렌더링
    function renderNoticePagination(current, totalCount) {
        const maxPages = Math.ceil(totalCount / itemsPerPage);
        paginationContainer.empty();
        const paginationHTML = [];

        paginationHTML.push(`
            <button class="w-8 h-8 rounded-s border border-gray-1 
                    \${current <= 1 ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2'}"
                    \${current <= 1 ? 'disabled' : ''}
                    onclick="changeNoticePage(\${current - 1})">&lt;</button>
        `);

        for (let i = 1; i <= maxPages; i++) {
            paginationHTML.push(`
                <button class="w-8 h-8 \${i === current ? 'bg-gray-2' : 'hover:bg-gray-2'} border border-gray-1"
                        onclick="changeNoticePage(\${i})">\${i}</button>
            `);
        }

        paginationHTML.push(`
            <button class="w-8 h-8 rounded-e border border-gray-1 
                    \${current >= maxPages ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2'}"
                    \${current >= maxPages ? 'disabled' : ''}    
                    onclick="changeNoticePage(\${current + 1})">&gt;</button>
        `);

        paginationContainer.html(paginationHTML.join(''));
    }

    // 🔹 날짜 포맷
    function formatDate(dateStr) {
        if (!dateStr) return "-";
        const date = new Date(dateStr);
        if (isNaN(date)) return "-";
        return date.toLocaleDateString('ko-KR').replace(/\s/g, '').replace(/\.$/, '');
    }

    // 🔹 페이지 변경
    window.changeNoticePage = function (page) {
        if (page < 1) return;
        currentPage = page;
        loadNoticeList(currentPage);
    };

    // 🔄 초기 로딩
    loadNoticeList(currentPage);
});

</script>