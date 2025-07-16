<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="mypage" tagdir="/WEB-INF/tags/mypage"%>

<ui:layout pageName="Betting Point 마이페이지" pageType="main">
	<jsp:attribute name="bodyContent">
		<div class="grow flex flex-col items-center py-10">
			<div class="w-full w-[90%] flex flex-col items-center">
				<div class="w-full flex items-end gap-x-4 mb-4">
					<img alt="service image" src="${cpath}/resources/images/service_image_1.png" class="h-40 sm:h-48 md:h-64 lg:h-80">
					<div class="grow mb-8 flex flex-col gap-4">
						<div class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 md:ml-2">마이페이지</div>
						<div class="grid grid-cols-2 md:grid-cols-5 gap-4 text-white font-extrabold text-sm sm:text-base md:text-lg lg:text-xl">
							<button data-tab="info" class="tab-btn bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">나의 정보</button>
							<button data-tab="points" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">포인트 내역</button>
							<button data-tab="games" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">게임 내역</button>
							<button data-tab="questions" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">문의 내역</button>
						</div>
					</div>
				</div>
				<div class="w-full h-[2px] bg-gray-1"></div>
				<div id="mypage-tab-content" class="w-full">
					<mypage:info></mypage:info>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(".tab-btn").on("click", function () {
				const selectedTab = $(this).data("tab");
				
				// 버튼 스타일 업데이트
				$(".tab-btn").removeClass("bg-blue-3").addClass("bg-blue-4 hover:bg-blue-3");
				$(this).removeClass("bg-blue-4 hover:bg-blue-3").addClass("bg-blue-3");
				
				// 콘텐츠 영역 비우고 로딩
				const contentContainer = $("#mypage-tab-content");
				contentContainer.html('<div class="text-center py-8 text-gray-5">로딩 중...</div>');

				// 선택된 탭에 따라 콘텐츠 요청
				$.ajax({
					url: `/mypage/\${selectedTab}`,
					type: 'GET',
					success: function (html) {
						contentContainer.html(html);
					},
					error: function () {
						contentContainer.html('<div class="text-red-500">콘텐츠 로딩 실패</div>');
					}
				});
			});
		</script>
		 <ui:chatbot></ui:chatbot>
	</jsp:attribute>
</ui:layout>