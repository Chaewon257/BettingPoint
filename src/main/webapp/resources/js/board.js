let currentCategory = "";  // 기본값은 페이지마다 다름
let currentBoardUid = "";
let currentSort = "";

// 문서 로드 완료 시 페이지 종류에 따라 처리
$(document).ready(function () {

  const isListPage = $("#boardList").length > 0;

  if (isListPage) {
    currentCategory = "free"; // 기본 카테고리
    filterByCategory(currentCategory);  // 게시글 목록 로딩
  }

});

// 게시글 등록 페이지 전용 초기화
function setupInsertForm() {
  if ($('#summernote').length) {
    $('#summernote').summernote({
      height: 300,
      lang: "ko-KR",
      placeholder: '최대 2048자까지 쓸 수 있습니다',
      callbacks: {	
        onImageUpload: function(files) {
          uploadSummernoteImageFile(files[0], this);
        },
        // 이미지 복붙 처리 (중복 업로드 방지)
        onPaste: function (e) {
          var clipboardData = e.originalEvent.clipboardData;
          if (clipboardData && clipboardData.items && clipboardData.items.length) {
            var item = clipboardData.items[0];
            if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
              e.preventDefault(); 
            }
          }
        }
      }
    });

    // 이미지 S3에 업로드 후 Summernote에 삽입
    function uploadSummernoteImageFile(file, editor) {
      let data = new FormData();
      data.append("image", file);

      $.ajax({
        data: data,
        type: "POST",
        url: "/api/board/image-upload",
        contentType: false,
        processData: false,
        success: function (res) {
          if (res.url) {
            $(editor).summernote('insertImage', res.url);
          } else {
            alert("이미지 업로드 실패: 응답에 URL 없음");
          }
        },
        error: function () {
          alert("이미지 업로드 실패");
        }
      });
    }
  }

  $('#insertForm').on('submit', function (e) {
    e.preventDefault();

    const token = localStorage.getItem("accessToken");
    if (!token) {
      alert("로그인이 필요합니다.");
      location.href = "/board/list";
      return;
    }

    const dto = {
      title: $('#title').val(),
      content: $('#summernote').summernote('code'),
      category: $('#category').val()
    };

    $.ajax({
      url: "/api/board/boardinsert",
      method: "POST",
      contentType: "application/json",
      headers: {
        'Authorization': 'Bearer ' + token
      },
      data: JSON.stringify(dto),
      success: function () {
        alert("게시글 등록 성공");
        location.href = "/board/list";
      },
      error: function () {
        alert("게시글 등록 실패");
      }
    });
  });
}

// 카테고리 버튼 클릭 시
function filterByCategory(category) {
  currentPage = 1;
  currentCategory = category;
  setActiveCategoryButton(category);
  loadBoardList(currentPage, currentCategory);
}

// 선택된 카테고리 버튼에 active 적용
function setActiveCategoryButton(category) {
  $('#categoryButtons button').removeClass('active');
  $('#categoryButtons button').each(function () {
    if ($(this).text().includes(translateCategory(category))) {
      $(this).addClass('active');
    }
  });
}

// 게시글 목록 로드
function loadBoardList(page, category) {
  currentPage = page;
  if (category !== undefined) {
    currentCategory = category;
  }

  $.ajax({
    url: "/api/board/boardlist",
    type: "GET",
    data: {
      page: page,
      category: currentCategory,
      sort: currentSort
    },
    success: function (boards) {
      let listHtml = "";
      const startNo = (currentPage - 1) * 10 + 1;

      boards.forEach(function (board, index) {
        const createdDate = new Date(board.created_at);
        const formattedDate = createdDate.toLocaleDateString("ko-KR");

        listHtml += `
          <tr>
            <td>${startNo + index}</td>
            <td><a href="${cpath}/board/detail/${board.uid}">${board.title}</a></td>
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

// 카테고리 표시 변환
function translateCategory(category) {
  switch (category) {
    case "free": return "자유";
    case "info": return "정보/조언";
    case "idea": return "제안/아이디어";
    default: return category;
  }
}

// 게시글 상세 보기
function loadBoardDetail(boardId) {
  const token = localStorage.getItem("accessToken");

  $.ajax({
    url: `/api/board/boarddetail/${boardId}`,
    type: "GET",
    headers: {
      "Authorization": "Bearer " + token
    },
    success: function (board) {
      currentBoardUid = board.uid;
      $("#detailTitle").text(board.title);
      $("#detailAuthor").text(board.user_uid);
      $("#detailCategory").text(translateCategory(board.category));
      $("#detailContent").html(board.content);
      $("#detailViewCount").text(board.view_count);
      $("#detailLikeCount").text(board.like_count);

      const createdDate = new Date(board.created_at);
      $("#detailCreatedAt").text(createdDate.toLocaleString("ko-KR"));

      // 로그인 안 한 경우 수정, 삭제 버튼 숨기기
      if (!token) {
        $("#btnEdit").hide();
        $("#btnDelete").hide();
        return;
      }

      // 작성자와 로그인 사용자 비교
      if (board.oner === true) {
        $("#btnEdit").show();
        $("#btnDelete").show();
      } else {
        $("#btnEdit").hide();
        $("#btnDelete").hide();
      }
    },
    error: function () {
      alert("상세 정보를 불러오지 못했습니다.");
    }
  });
}

// 좋아요 버튼 이벤트
$(document).on("click", "#likeBtn", function () {

  if (!currentBoardUid) {
    alert("게시글 정보가 없습니다.");
    return;
  }

  $.ajax({
    url: "/api/board/like/" + currentBoardUid,
    method: "POST",
    success: function () {
      let likeSpan = $("#likeCount");
      let likeSpan2 = $("#detailLikeCount");
      let current = parseInt(likeSpan.text()) || 0;
      let current2 = parseInt(likeSpan2.text()) || 0;
      likeSpan.text(current + 1);
      likeSpan2.text(current2 + 1);
    },
    error: function () {
      alert("좋아요 처리에 실패했습니다.");
    }
  });
});

// 정렬 버튼 클릭
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

// 수정하기 버튼, 수정 페이지로 이동
$(document).on("click", "#btnEdit", function () {
  location.href = `/board/update/${currentBoardUid}`;
});

// 수정 페이지 전용 초기화 함수
function setupUpdateForm(boardId) {
  // Summernote 초기화
  $('#summernote').summernote({
    height: 300,
    lang: 'ko-KR',
    placeholder: '최대 2048자까지 작성할 수 있습니다'
  });

  const token = localStorage.getItem("accessToken");

  // 기존 게시글 데이터 조회 (GET)
  $.ajax({
    url: `/api/board/boarddetail/${boardId}`,
    method: "GET",
    headers: {
      'Authorization': 'Bearer ' + token
    },
    success: function (board) {
      $("#title").val(board.title);
      $("#category").val(board.category);
      $('#summernote').summernote('code', board.content);
    },
    error: function () {
      alert("게시글 정보를 불러오지 못했습니다.");
      location.href = "/board/list";
    }
  });

  // 폼 제출 처리 (PUT)
  $("#updateForm").on("submit", function (e) {
    e.preventDefault();

    if (!token) {
      alert("로그인이 필요합니다.");
      return;
    }

    const dto = {
      uid: boardId,
      title: $("#title").val(),
      category: $("#category").val(),
      content: $("#summernote").summernote("code")
    };

    $.ajax({
      url: `/api/board/boardupdate/${boardId}`,
      method: "PUT",
      contentType: "application/json",
      headers: {
        "Authorization": "Bearer " + token
      },
      data: JSON.stringify(dto),
      success: function () {
        alert("수정 성공!");
        location.href = `/board/detail/${boardId}`;
      },
      error: function () {
        alert("수정 실패!");
      }
    });
  });
}

// 삭제 버튼 클릭 이벤트 등록
$(document).on("click", "#btnDelete", function () {
  const pathSegments = window.location.pathname.split("/");
  const uid = pathSegments[pathSegments.length - 1];

  if (!uid) {
    alert("게시글 정보가 없습니다.");
    return;
  }

  const token = localStorage.getItem("accessToken");

  if (!token) {
    alert("로그인이 필요합니다.");
    return;
  }

  const confirmed = confirm("정말 삭제하시겠습니까?");
  if (!confirmed) return;

  $.ajax({
    url: "/api/board/boarddelete/" + uid,
    method: "DELETE",
    headers: {
      "Authorization": "Bearer " + token
    },
    success: function () {
      alert("삭제되었습니다.");
      location.href = cpath + "/board/list";
    },
    error: function (xhr) {
      if (xhr.status === 401) {
        alert("로그인이 필요합니다.");
      } else {
        alert("삭제에 실패했습니다.");
        console.error(xhr.responseText);
      }
    }
  });
});
