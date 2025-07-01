let currentPage     = 1;
const PAGE_SIZE     = 10;
let currentCategory = "free";
let currentSort     = "created_at";

	// 카테고리 표시 변환
	function translateCategory(category) {
	  switch (category) {
	    case "free": return "자유";
	    case "info": return "정보/조언";
	    case "idea": return "제안/아이디어";
	    default: return category;
	  }
	}
	
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
          <span class="col-span-3 truncate">
            <a href="/board/view/${b.uid}" class="hover:underline">
              ${b.title}
            </a>
          </span>
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
	
function renderPaging(current, totalCount) {
  const itemsPerPage = PAGE_SIZE;
  const maxPages     = Math.ceil(totalCount / itemsPerPage);
  const html         = [];

  // ◀ 이전
  html.push(`
    <button
      class="w-8 h-8 rounded-s border border-gray-1
             ${current <= 1
               ? 'text-gray-1 cursor-not-allowed'
               : 'hover:bg-gray-2'}"
      ${current <= 1 ? 'disabled' : ''}
      onclick="loadBoardList(${current - 1}, '${currentCategory}', '${currentSort}')">
      &lt;
    </button>
  `);

  // [1] [2] … 숫자
  for (let i = 1; i <= maxPages; i++) {
    html.push(`
      <button
        class="w-8 h-8 border border-gray-1
               ${i === current
                 ? 'bg-gray-2'
                 : 'hover:bg-gray-2'} page-btn"
        onclick="loadBoardList(${i}, '${currentCategory}', '${currentSort}')">
        ${i}
      </button>
    `);
  }

  // ▶ 다음
  html.push(`
    <button
      class="w-8 h-8 rounded-e border border-gray-1
             ${current >= maxPages
               ? 'text-gray-1 cursor-not-allowed'
               : 'hover:bg-gray-2'}"
      ${current >= maxPages ? 'disabled' : ''}
      onclick="loadBoardList(${current + 1}, '${currentCategory}', '${currentSort}')">
      &gt;
    </button>
  `);

  // 컨테이너에 출력
  $("#paging").html(html.join(''));
}