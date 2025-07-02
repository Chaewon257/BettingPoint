<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="boardId" value="${boardId}" />

<div class="w-full h-[2px] bg-gray-1 mb-4"></div>
<div class="w-full grid grid-cols-1 lg:grid-cols-5">
	<!-- 좌측: 게시글 데이터 -->
    <div class="col-span-4 w-full h-full flex flex-col gap-y-4 bg-gray-8 p-4">
    	<!-- 제목 -->
        <span id="detailTitle" class="text-3xl font-extrabold">로딩 중…</span>

        <!-- 작성자 · 좋아요 · 조회수 · 작성일 -->
        <div class="grid grid-cols-8 text-gray-3 font-light text-xs sm:text-sm md:text-base">
        	<span id="detailAuthor" class="col-span-4 text-start">—</span>
            <div class="flex items-center justify-center">
	        	<button id="likeBtn" class="flex items-center justify-center gap-x-2 px-2 py-1 rounded-full hover:bg-gray-1">
	            	<img alt="like image" src="${cpath}/resources/images/like.png" class="w-4">
	                <span id="detailLikeCount">0</span>
	            </button>
            </div>
            <div class="flex items-center justify-center gap-x-2">
            	<img alt="view image" src="${cpath}/resources/images/view.png" class="w-4">
                <span id="detailViewCount">0</span>
            </div>
            <span id="detailCreatedAt" class="col-span-2 text-end">—</span>
        </div>

        <!-- 본문 -->
        <div id="detailContent" class="w-full h-[500px] bg-white p-2 overflow-y-scroll">로딩 중…</div>
    </div>

    <!-- 우측: 버튼 -->
    <div class="col-span-1 flex lg:flex-col items-center justify-end gap-4 bg-blue-4 p-4 font-bold text-white text-base md:text-lg lg:text-xl">
    	<button id="btnEdit" style="display:none" class="w-full bg-blue-3 hover:bg-blue-4 rounded-full py-2.5">수정하기</button>
        <button id="btnDelete" style="display:none" class="w-full bg-gray-1 hover:bg-gray-5 text-red-1 rounded-full py-2.5">삭제하기</button>
        <button type="button" onclick="location.href='${cpath}/board';" class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5">뒤로가기</button>
    </div>
</div>

<script type="text/javascript">
  const cpath   = "${cpath}";
  const boardId = "${boardId}";
  let currentBoardUid;

  function loadBoardDetail(boardId) {
    const token = localStorage.getItem("accessToken");
    const headers = token
      ? { "Authorization": "Bearer " + token }
      : {};

    $.ajax({
      url: `${cpath}/api/board/boarddetail/\${boardId}`,
      type: "GET",
      headers: headers,
      success: function(board) {
        currentBoardUid = board.uid;
        $("#detailTitle").text(board.title);
        $("#detailAuthor").text(board.nickname);
        $("#detailLikeCount").text(board.like_count);
        $("#detailViewCount").text(board.view_count);
        $("#detailCreatedAt").text(
          new Date(board.created_at).toLocaleString("ko-KR")
        );
        $("#detailContent").html(board.content);
        
        if (board.oner === true) {
            $("#btnEdit, #btnDelete").show();
          }
		
      },
      error: function() {
        alert("상세 정보를 불러오지 못했습니다.");
        history.back();
      }
    });
  }

  $(document).ready(function(){
    loadBoardDetail(boardId);
    
    $('#btnEdit').on('click', function(){
        window.location.href = `\${cpath}/board/write/\${boardId}`;
      });
    
 	// 삭제 버튼 클릭
    $("#btnDelete").on("click", function() {
      if (!confirm("정말 삭제하시겠습니까?")) return;

      const token   = localStorage.getItem("accessToken");
      const headers = token ? { "Authorization": "Bearer " + token } : {};

      $.ajax({
        url: `${cpath}/api/board/boarddelete/${boardId}`,
        type: "DELETE",
        headers: headers,
        success: function() {
          alert("게시글이 삭제되었습니다.");
          location.href = `${cpath}/board`;
        },
        error: function() {
          alert("삭제에 실패했습니다. 다시 시도해주세요.");
        }
      });
    });
	    
  });
  //좋아요 버튼 클릭 시
  $(document).on("click", "#likeBtn", function () {
	  
	  const token = localStorage.getItem("accessToken");
	  if (!token) {
	    alert("로그인이 필요합니다.");
	    return;
	  }

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
  
</script>