// 문서 로드 시 자동 실행
$(document).ready(function() {
  loadBoardList();
});

// 게시판 목록 불러오기
function loadBoardList() {
  $.ajax({
    url: "/api/board/boardlist", 
    type: "GET",
    dataType: "json",
    success: function(data) {
      const list = $("#boardList");
      list.empty(); // 목록 초기화

      if (data.length === 0) {
        list.append("<li>등록된 게시글이 없습니다.</li>");
        return;
      }

      data.forEach(function(post) {
        const li = $(`
          <li>
            <strong>${post.title}</strong> - 
            <em>${post.category}</em> |
            조회수: ${post.view_count} |
            작성일: ${new Date(post.created_at).toLocaleString()}
          </li>
        `);
        list.append(li);
      });
    },
    error: function(xhr, status, error) {
      alert("게시판 목록 불러오기 실패: " + error);
    }
  });
}




