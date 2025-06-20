let currentPage = 1;
let totalPages = 1;
let currentCategory = "";
let currentBoardUid = "";
let currentSort = ""; // 기본은 최신순 (정렬 안 보냄)

// 로딩 완료 시 기본 카테고리(자유) 리스트 로드
$(document).ready(function () {
  filterByCategory(currentCategory);
});

$(document).ready(function () {
  const params = new URLSearchParams(window.location.search);
  const uid = params.get("uid");
  if (uid) {
    loadBoardDetail(uid);  // ❗이게 있어야 detail.jsp가 제대로 작동해
  }
});

/**
 * 카테고리 버튼 클릭 시 호출됨
 * @param {string} category - 'free', 'info', 'idea'
 */
function filterByCategory(category) {
  currentPage = 1;           // 페이지 1로 초기화
  currentCategory = category; // 현재 카테고리 저장
  setActiveCategoryButton(category);  // 버튼 active 처리
  loadBoardList(currentPage, currentCategory); // 게시글 불러오기
}

/**
 * 선택된 카테고리 버튼에 active 클래스 추가, 나머지 버튼은 제거
 * @param {string} category
 */
function setActiveCategoryButton(category) {
  $('#categoryButtons button').removeClass('active');
  $('#categoryButtons button').each(function () {
    if ($(this).text().includes(categoryToKorean(category))) {
      $(this).addClass('active');
    }
  });
}

/**
 * 카테고리 영문코드를 한글로 변환 (버튼 텍스트 매칭용)
 * @param {string} category
 * @returns {string} '자유', '정보', '아이디어'
 */
function categoryToKorean(category) {
  switch (category) {
    case 'free': return '자유';
    case 'info': return '정보';
    case 'idea': return '아이디어';
    default: return '';
  }
}

/**
 * AJAX로 게시글 목록을 받아와 테이블에 출력
 * @param {number} page
 * @param {string} category
 */
function loadBoardList(page, category) {
	currentPage = page;
  	if (category !== undefined) {
    currentCategory = category;  // 필터 조건 업데이트
  }
  $.ajax({
    url: cpath + "/api/board/boardlist",
    type: "GET",
    data: { 
    	page: page, 
    	category: currentCategory, 
    	sort: currentSort
    },
    success: function (response) {
      totalPages = response.totalPages;

      let listHtml = "";
      const startNo = (currentPage - 1) * 10 + 1;

      response.boards.forEach(function (board, index) {
        const createdDate = new Date(board.created_at);
        const formattedDate = createdDate.toLocaleDateString("ko-KR");

        listHtml += `
          <tr>
            <td>${startNo + index}</td>
            <td><a href="${cpath}/board/detail?uid=${board.uid}">${board.title}</a></td>
            <td>${translateCategory(board.category)}</td>
            <td>${board.user_uid}</td>
            <td>${board.view_count}</td>
            <td>${board.like_count}</td>
            <td>${formattedDate}</td>
          </tr>`;
      });

      $("#boardList").html(listHtml);
      renderPaging();
    },
    error: function () {
      alert("게시글 목록을 불러오는데 실패했습니다.");
    }
  });
}

/**
 * 페이징 UI 렌더링
 */
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

/**
 * DB의 category 값을 한글로 변환해서 출력
 * @param {string} category
 * @returns {string}
 */
function translateCategory(category) {
  switch (category) {
    case "free": return "자유";
    case "info": return "정보/조언";
    case "idea": return "제안/아이디어";
    default: return category;
  }
}

//상세보기 
function loadBoardDetail(uid) {
  $.ajax({
    url: cpath + "/api/board/boarddetail/" + uid,
    type: "GET",
    data: { uid: uid },
    success: function (board) {
      currentBoardUid = board.uid; 
    
      $("#detailTitle").text(board.title);
      $("#detailAuthor").text(board.user_uid);
      $("#detailCategory").text(translateCategory(board.category));
      $("#detailContent").text(board.content);
      $("#detailViewCount").text(board.view_count);
      $("#detailLikeCount").text(board.like_count);

      const createdDate = new Date(board.created_at);
      $("#detailCreatedAt").text(createdDate.toLocaleString("ko-KR"));

      if (board.board_img) {
        $("#detailImg").attr("src", board.board_img);
      } else {
        $("#detailImg").attr("alt", "이미지 없음");
      }
    },
    error: function () {
      alert("상세 정보를 불러오지 못했습니다.");
    }
  });
}

//좋아요 버튼
$(document).on("click", "#likeBtn", function () {
  if (!currentBoardUid) {
    alert("게시글 정보가 없습니다.");
    return;
  }

  $.ajax({
    url: cpath + "/board/like/" + currentBoardUid,
    method: "POST",
    success: function (res) {
      if (res === "success") {
        let likeSpan = $("#likeCount");
        let current = parseInt(likeSpan.text());
        likeSpan.text(current + 1);
      }
    },
    error: function () {
      alert("좋아요 처리에 실패했습니다.");
    }
  });
});

//좋아요, 조회수 순으로 정렬
$("#sortButtons").on("click", ".sort-btn", function () {
  const selectedSort = $(this).data("sort");  
  
  if (currentSort === selectedSort) {
    currentSort = "";
    $(".sort-btn").removeClass("active");
  } else {
    currentSort = selectedSort;
    $(".sort-btn").removeClass("active");
    $(this).addClass("active");
  }

  loadBoardList(1, currentCategory);
});




