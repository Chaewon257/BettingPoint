<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
        <button type="button" onclick="goBackToList()" class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5">뒤로가기</button>
    </div>
</div>

<!-- jQuery 로드 (board.js 없이도 $ 사용 가능) -->
<script
  src="https://code.jquery.com/jquery-3.6.4.min.js">
</script>

<script type="text/javascript">
  var boardId = "${boardId}";
	
  function goBackToList(){
	  // 해당 탭 버튼을 클릭한 것처럼 처리
	  $('.tab-btn[data-tab="' + currentCategory + '"]').trigger('click');
	  
  }
  
 $(function(){
	 
    $('#btnEdit').on('click', function(){
        window.location.href = `/board/write/\${boardId}`;
      });
    
 	// 삭제 버튼 클릭
    $("#btnDelete").on("click", function() {
      if (!confirm("정말 삭제하시겠습니까?")) return;

      const token   = localStorage.getItem("accessToken");
      const headers = token ? { "Authorization": "Bearer " + token } : {};

      $.ajax({
        url: `/api/board/boarddelete/\${boardId}`,
        type: "DELETE",
        headers: headers,
        success: function() {
          alert("게시글이 삭제되었습니다.");
          location.href = `/board`;
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
	  $.ajax({
	    url: `/api/board/like/\${boardId}`,
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