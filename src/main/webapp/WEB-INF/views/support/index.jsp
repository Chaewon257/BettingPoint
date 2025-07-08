<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="support" tagdir="/WEB-INF/tags/support"%>

<ui:layout pageName="Betting Point 고객지원" pageType="main">
	<jsp:attribute name="bodyContent">
		<div class="grow flex flex-col items-center py-10">
			<div class="w-full w-[90%] flex flex-col items-center">
				<div class="w-full flex items-end gap-x-4 mb-4">
					<img alt="service image" src="${cpath}/resources/images/service_image_1.png" class="h-40 sm:h-48 md:h-64 lg:h-80">
					<div class="grow mb-8 flex flex-col gap-4">
						<div class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 md:ml-2">고객지원</div>
						<div class="grid grid-cols-2 md:grid-cols-5 gap-4 text-white font-extrabold text-sm sm:text-base md:text-lg lg:text-xl">
							<button data-tab="faq" class="tab-btn bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">FAQ's</button>
							<button data-tab="notice" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">공지사항</button>
							<button data-tab="inquiry" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-lg shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-2">1대1 문의</button>
						</div>
					</div>
				</div>
				<div class="w-full h-[2px] bg-gray-1"></div>
				<div id="support-tab-content" class="w-full">
					<support:faq></support:faq>
				</div>
			</div>
		</div>
		<script type="text/javascript">	
			// 메인페이지에서 uid 들고 공지사항 페이지 넘어왔을 때
			$(function(){
				const uidParam = new URLSearchParams(location.search).get('uid');
				  
				if(uidParam){				   
					// 1. 공지사항 탭 버튼 클릭 (탭을 띄우기 위함)
					$('button.tab-btn[data-tab="notice"]').trigger('click');
					
					// 2. 탭 콘텐츠가 로딩될 시간을 고려해서 약간 지연 실행
					setTimeout(function () {
					    // 3. 해당 uid를 가진 공지사항 항목을 찾아 클릭 트리거s
					    $(`[data-notice="\${uidParam}"]`).first().trigger('click');
					}, 300); // 필요 시 딜레이 조정
				}
				
				$(document).on('click', '.tab-btn', function () {
				    removeUidFromUrl(); // ← 탭 전환 시 주소에서 uid 제거
				});
				
				function removeUidFromUrl() {
				    const url = new URL(location.href);
				    url.searchParams.delete('uid');
				    history.replaceState(null, '', url.pathname); // → "/support"
				}
			});		
		
			//FAQ 토글 버튼
			$(document).on("click", ".faq-toggle", function () {
			    const $faqItem = $(this).closest(".faq-item");
			    const $content = $faqItem.find(".faq-content");
			    const $question = $faqItem.find(".question-title");
			    const $icon = $(this).find(".icon-open");
	
			    $content.stop(true, true).slideToggle(300);
			    $question.toggleClass("font-semibold");
			    $icon.toggleClass("rotate-180");
			});
		
			$(".tab-btn").on("click", function () {
				const selectedTab = $(this).data("tab");
				
				// 버튼 스타일 업데이트
				$(".tab-btn").removeClass("bg-blue-3").addClass("bg-blue-4 hover:bg-blue-3");
				$(this).removeClass("bg-blue-4 hover:bg-blue-3").addClass("bg-blue-3");
				
				// 콘텐츠 영역 비우고 로딩
				const contentContainer = $("#support-tab-content");
				contentContainer.html('<div class="text-center py-8 text-gray-5">로딩 중...</div>');

				// 선택된 탭에 따라 콘텐츠 요청
				$.ajax({
					url: `/support/\${selectedTab}`,
					type: 'GET',
					success: function (html) {
						contentContainer.html(html);
					},
					error: function () {
						contentContainer.html('<div class="text-red-500">게시판 로딩 실패</div>');
					}
				});
			});
			
			$(document).on("click", '.notice-view', function () {
				const selectednotice = $(this).data("notice");
				//const selectednotice = new URLSearchParams(window.location.search).get('uid');
				
				// 콘텐츠 영역 비우고 로딩
				const contentContainer = $("#support-tab-content");
				contentContainer.html('<div class="text-center py-8 text-gray-5">로딩 중...</div>');
				
				$.ajax({
					url: `/support/view`,
					type: 'GET',
					success: function (html) {
						contentContainer.html(html);
						
						// ✅ 상세 API 호출
						$.ajax({
							url: `/api/support/detail/\${selectednotice}`,
							type: 'GET',
							success: function (notice) {
								$("#notice-title").text(notice.title || "-");
								$("#notice-writer").text(notice.writer || "관리자");
								$("#notice-views").text(notice.view_count ?? 0);
								$("#notice-date").text(formatDate(notice.created_at));
								$("#notice-content").html(notice.content || "-");
							},
							error: function () {
								alert("공지사항 데이터를 불러오는 데 실패했습니다.");
							}
						});
					},
					error: function () {
						alert('공지사항 보기 실패');
					}
				});
			});
		</script>
		<ui:chatbot></ui:chatbot>
	</jsp:attribute>
</ui:layout>