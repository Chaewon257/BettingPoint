let totalPages 		= 1;
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
	    type: "GET",
	    data: { page: currentPage, 
	    		category: currentCategory,
	    		sort: currentSort },
	    success: function (boards) {
	      let listHtml = "";
	      const startNo = (currentPage - 1) * 10 + 1;

	      boards.forEach(function (board, idx) {
	        const formattedDate = new Date(board.created_at)
	                               .toLocaleDateString("ko-KR");

	         /*  div-grid (Tailwind 클래스 유지) */
	        listHtml += `
	          <div class="p-4 grid grid-cols-12 items-center text-center
	                      border-b border-gray-1 font-light">
	            <span>${startNo + idx}</span>

	            <span class="col-span-3 truncate text-center">
	              <a href="/board/view/${board.uid}"
	                 class="truncate hover:underline">
	                ${board.title}
	              </a>
	            </span>

	            <div class="col-span-2 flex items-center justify-center gap-x-2">
	              <img src="${cpath}/resources/images/like.png" class="w-4" alt="">
	              <span>${board.like_count}</span>
	            </div>

	            <div class="col-span-2 flex items-center justify-center gap-x-2">
	              <img src="${cpath}/resources/images/view.png" class="w-4" alt="">
	              <span>${board.view_count}</span>
	            </div>

	            <span class="col-span-2">${board.nickname}</span>
	            <span class="col-span-2">${formattedDate}</span>
	          </div>`;
	      });

	      $("#boardList").html(listHtml);
	      renderPaging();
	    },
	    error: function () {
	      alert("게시글 목록을 불러오는데 실패했습니다.");
	    }
	  });
	}

	// 페이징 처리
	function renderPaging() {
	  let pagingHtml = "";
	  for (let i = 1; i <= totalPages; i++) {
	    if (i === currentPage) {
	      pagingHtml += `<strong style="margin:0 5px;">${i}</strong>`;
	    } else {
	      pagingHtml += `<a href="#" style="margin:0 5px;" onclick="loadBoardList(${i}, '${currentCategory}'); return false;">${i}</a>`;
	    }
	  }
	  $("#paging").html(pagingHtml);
	}
