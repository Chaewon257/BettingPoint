// 게시판 목록 조회
function loadBoardList() {
  $.ajax({
    url: "/board/list",
    type: "GET",
    dataType: "json",
    success: function(data) {
      const list = $("#boardList");
      list.empty();  // 초기화
      data.forEach(function(post) {
        const li = $(
          `<li><a href="boardDetail.jsp?uid=${post.uid}">${post.title}</a> [${post.category}] 조회수: ${post.view_count}</li>`
        );
        list.append(li);
      });
    },
    error: function(xhr, status, error) {
      alert("게시판 목록 불러오기 실패: " + error);
    }
  });
}

// 게시글 상세 조회
function loadBoardDetail() {
  const params = new URLSearchParams(location.search);
  const uid = params.get("uid");

  if (!uid) {
    alert("잘못된 접근입니다.");
    return;
  }

  $.ajax({
    url: `/board/detail/${uid}`,
    type: "GET",
    dataType: "json",
    success: function(data) {
      $("#title").text(data.title);
      $("#category").text(data.category);
      $("#userUid").text(data.user_uid);
      $("#createAt").text(new Date(data.create_at).toLocaleString());
      $("#viewCount").text(data.view_count);
      $("#content").text(data.content);

      if (data.board_img) {
        $("#boardImg").attr("src", data.board_img).show();
      } else {
        $("#boardImg").hide();
      }
    },
    error: function(xhr, status, error) {
      alert("게시글 상세 불러오기 실패: " + error);
    }
  });
}

// JSP 로드 시 페이지 구분해서 함수 실행
$(document).ready(function() {
  if ($("#boardList").length) {
    loadBoardList();
  }

  if ($("#title").length) {
    loadBoardDetail();
  }
});
