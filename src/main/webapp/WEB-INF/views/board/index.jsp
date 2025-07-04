<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="board" tagdir="/WEB-INF/tags/board"%>

<ui:layout pageName="Betting Point 게시판" pageType="main">
	<jsp:attribute name="bodyContent">
		<div class="grow flex flex-col items-center py-10">
			<div class="w-full w-[90%] flex flex-col items-center">
				<div class="w-full flex items-end gap-x-4 mb-4">
					<img alt="service image" src="${cpath}/resources/images/service_image_1.png" class="h-40 sm:h-48 md:h-64 lg:h-80">
					<div class="grow mb-8 flex flex-col gap-4">
						<div class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 md:ml-2">게시판</div>
						<div class="grid grid-cols-2 md:grid-cols-5 gap-4 text-white font-extrabold text-sm sm:text-base md:text-lg lg:text-xl">
							<button data-tab="free" class="tab-btn bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">자유</button>
							<button data-tab="info" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">정보/조언</button>
							<button data-tab="idea" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">제안/아이디어</button>
						</div>
					</div>
				</div>
				<div id="board-tab-content" class="w-full">
					<board:free></board:free>
				</div>
			</div>
		</div>
		<script src="/resources/js/board.js"></script>
		<script>
	
		$(function(){
			
			
			
			$(".tab-btn").on("click", function () {
				const selectedTab = $(this).data("tab");
				
				currentCategory = selectedTab;
				
								
				// 버튼 스타일 업데이트
				$(".tab-btn").removeClass("bg-blue-3").addClass("bg-blue-4 hover:bg-blue-3");
				$(this).removeClass("bg-blue-4 hover:bg-blue-3").addClass("bg-blue-3");
				
				// 정렬 버튼 스타일 기본값으로 초기화
				$(".sort-btn").removeClass("text-gray-7 underline").addClass("text-gray-3 hover:text-gray-7");

				// 기본 정렬 값 적용 (created_at)
				$(`.sort-btn[data-sort="created_at"]`)
					.removeClass("text-gray-3 hover:text-gray-7")
					.addClass("text-gray-7 underline");

				// 콘텐츠 영역 비우고 로딩
				const contentContainer = $("#board-tab-content");
				contentContainer.html('<div class="text-center py-8 text-gray-5">로딩 중...</div>');

				// 선택된 탭에 따라 콘텐츠 요청
				$.ajax({
					url: `/board/\${selectedTab}`,
					type: 'GET',
					success: function (html) {
						contentContainer.html(html);
						loadBoardList(1, currentCategory, currentSort);
					},
					error: function () {
						contentContainer.html('<div class="text-red-500">게시판 로딩 실패</div>');
					}
				});
				
			});
			
			// 정렬
			$(document).on("click", ".sort-btn", function () {
				const selectedSort = $(this).data("sort");
			
				// 정렬 버튼 스타일 기본값으로 초기화
				$(".sort-btn").removeClass("text-gray-7 underline").addClass("text-gray-3 hover:text-gray-7");
				
				// 기본 정렬 값 적용 (created_at)
				$(this).removeClass("text-gray-3 hover:text-gray-7").addClass("text-gray-7 underline");
				
				currentSort = selectedSort;
				
				loadBoardList(1, currentCategory, selectedSort);
		
			});

		// 게시글 상세보기
		//$(document).on("click", '.board-view', f_boardViewClick);
			
		});
	
		function f_boardViewClick(boardId) {
			//const boardId = $(this).data("board");
						
			// 콘텐츠 영역 비우고 로딩
			const contentContainer = $("#board-tab-content");
			contentContainer.html('<div class="text-center py-8 text-gray-5">로딩 중...</div>');
			const token   = localStorage.getItem("accessToken");
	 		
			$.ajax({
				url: `/board/view/\${boardId}`,
				type: 'GET',
				success: function (html) {
					contentContainer.html(html); 
					$.ajax({
					      url: `/api/board/boarddetail/\${boardId}`,
					      type: "GET",
					      headers: { "Authorization": "Bearer " + token },
					      success: function(board) {
					    	  
					        $("#detailTitle").text(board.title);
					        $("#detailAuthor").text(board.nickname);
					        $("#detailLikeCount").text(board.like_count);
					        $("#detailViewCount").text(board.view_count);
					        $("#detailCreatedAt").text(
					          new Date(board.created_at).toLocaleString("ko-KR")
					        );
					        $("#detailContent").html(board.content);
					       
					        if (board.oner == true) {
					            $("#btnEdit, #btnDelete").show();
					          }
							
					      },
					      error: function() {
					        alert("상세 정보를 불러오지 못했습니다.");
					        history.back();
					      }
					    });
					}
			});
		}
		
		
		</script>
	</jsp:attribute>
</ui:layout>
		