let currentPage     = 1;
const PAGE_SIZE     = 10;
let currentCategory = "free";
let currentSort     = "";

	// 게시글 목록 로드
	function loadBoardList(page=1, category, sort) {
	  currentPage = page;
	  if (category !== undefined) currentCategory = category;
	  if (sort     !== undefined) currentSort    = sort;

	  $.ajax({
	    url: "/api/board/boardlist",
	    method: "GET",
	    data: {
	      page:     currentPage,
	      category: currentCategory,
	      sort:     currentSort
	    },
	    dataType: "json",
	    success: function (res) {
	    
		    // 메타 업데이트
	        totalPages  = res.totalPages;
	        currentPage = res.currentPage;
	
	        // 리스트 뿌리고
	        renderPosts(res.boards);
	
	        // 버튼 갱신
	        renderPaging(currentPage, res.totalCount);
	    },
	    error: function () {
	      alert("게시글 목록을 불러오는데 실패했습니다.");
	    }
	  });
	}
	

// 2) #boardList에 글 10개 렌더링
  function renderPosts(boards) {
    let listHtml = "";
    const startNo = (currentPage - 1) * PAGE_SIZE + 1;

    boards.forEach(function(b, idx) {
      const date = new Date(b.created_at)
                     .toLocaleDateString("ko-KR");
    
      listHtml += `
        <div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1 font-light">
          <span>${startNo + idx}</span>
          <button data-board="${b.uid}" onclick = 'f_boardViewClick("${b.uid}")'  class="board-view col-span-3 truncate hover:underline">${b.title}</button>
          <div class="col-span-2 flex items-center justify-center gap-x-2">
            <img src="/resources/images/like.png" class="w-4" alt="like"/>
            <span>${b.like_count}</span>
          </div>
          <div class="col-span-2 flex items-center justify-center gap-x-2">
            <img src="/resources/images/view.png" class="w-4" alt="view"/>
            <span>${b.view_count}</span>
          </div>
          <span class="col-span-2">${b.nickname}</span>
          <span class="col-span-2">${date}</span>
        </div>`;
    });
    
     $("#boardList").html(listHtml);
 }
	
  const PAGE_BTN_COUNT = 5;  // 한 블록당 버튼 수

function renderPaging(current, totalCount) {
  const maxPages = Math.ceil(totalCount / PAGE_SIZE);

  // 현재 블록 계산
  const currentBlock  = Math.floor((current - 1) / PAGE_BTN_COUNT);
  const startPage     = currentBlock * PAGE_BTN_COUNT + 1;
  const endPage       = Math.min(startPage + PAGE_BTN_COUNT - 1, maxPages);

  // 블록 이동용 페이지
  const prevBlockPage = startPage > 1      ? startPage - 1 : 1;
  const nextBlockPage = endPage < maxPages ? endPage + 1   : maxPages;

  const html = [];

  // << (처음)
  html.push(`
    <button
      class="w-8 h-8 border border-gray-1 rounded-s
             ${current === 1 ? 'text-gray-1 cursor-not-allowed' : 'hover:bg-gray-2'}"
      ${current === 1 ? 'disabled' : ''}
      onclick="loadBoardList(1, '${currentCategory}', '${currentSort}')">
      &laquo;
    </button>
  `);

  // < (이전 페이지)
  html.push(`
    <button
      class="w-8 h-8 border border-gray-1
             ${current  === 1 ? 'text-gray-1 cursor-not-allowed' : 'hover:bg-gray-2'}"
      ${current  === 1 ? 'disabled' : ''}
      onclick="loadBoardList(${current - 1}, '${currentCategory}', '${currentSort}')">
      &lsaquo;
    </button>
  `);

  // 페이지 번호 버튼
  for (let i = startPage; i <= endPage; i++) {
    html.push(`
      <button
        class="w-8 h-8 border border-gray-1
               ${i === current ? 'bg-gray-2' : 'hover:bg-gray-2'} page-btn"
        onclick="loadBoardList(${i}, '${currentCategory}', '${currentSort}')">
        ${i}
      </button>
    `);
  }

  // › (다음 페이지)
  html.push(`
    <button
      class="w-8 h-8 border border-gray-1
             ${endPage === maxPages ? 'text-gray-1 cursor-not-allowed' : 'hover:bg-gray-2'}"
      ${endPage === maxPages ? 'disabled' : ''}
      onclick="loadBoardList(${current + 1}, '${currentCategory}', '${currentSort}')">
      &rsaquo;
    </button>
  `);

  // » (다음 블록으로 이동)
  html.push(`
    <button
      class="w-8 h-8 border border-gray-1 rounded-e
             ${endPage === maxPages ? 'text-gray-1 cursor-not-allowed' : 'hover:bg-gray-2'}"
      ${endPage === maxPages ? 'disabled' : ''}
      onclick="loadBoardList(${nextBlockPage}, '${currentCategory}', '${currentSort}')">
      &raquo;
    </button>
  `);

  $("#paging").html(html.join(''));
}

  	$(function() {
	  loadBoardList(1);
	});