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

     //공지사항 페이지네이션 렌더링 (그룹 단위)
    function renderNoticePagination(current, totalCount) {
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
            ' onclick="changeNoticePage(' + prevGroupFirstPage + ')" title="이전 그룹">&lt;&lt;</button>'
        );
        
        // < 버튼 (이전 페이지)
        const isFirstPage = current === 1;
        const prevPage = current - 1;
        
        paginationHTML.push(
            '<button class="w-8 h-8 rounded-s border border-gray-1 ' +
            (isFirstPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
            (isFirstPage ? ' disabled' : '') +
            ' onclick="changeNoticePage(' + prevPage + ')" title="이전 페이지">&lt;</button>'
        );
        
        // 페이지 번호들
        for (let i = startPage; i <= endPage; i++) {
            paginationHTML.push(
                '<button class="w-8 h-8 ' + (i === current ? 'bg-gray-2' : 'hover:bg-gray-2') + ' border border-gray-1"' +
                ' onclick="changeNoticePage(' + i + ')">' + i + '</button>'
            );
        }
        
        // > 버튼 (다음 페이지)
        const isLastPage = current === maxPages;
        const nextPage = current + 1;
        
        paginationHTML.push(
            '<button class="w-8 h-8 border border-gray-1 ' +
            (isLastPage ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
            (isLastPage ? ' disabled' : '') +
            ' onclick="changeNoticePage(' + nextPage + ')" title="다음 페이지">&gt;</button>'
        );
        
        // >> 버튼 (다음 그룹의 첫 페이지로)
        const isLastGroup = endPage === maxPages;
        const nextGroupFirstPage = isLastGroup ? maxPages : currentGroup * pagesPerGroup + 1;
        
        paginationHTML.push(
            '<button class="w-8 h-8 rounded-e border border-gray-1 ' +
            (isLastGroup ? 'text-gray-1 hover:bg-gray-2 cursor-not-allowed' : 'hover:bg-gray-2') + '"' +
            (isLastGroup ? ' disabled' : '') +
            ' onclick="changeNoticePage(' + nextGroupFirstPage + ')" title="다음 그룹">&gt;&gt;</button>'
        );
        
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