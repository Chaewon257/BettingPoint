<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="board" tagdir="/WEB-INF/tags/board"%>

<ui:layout pageName="Betting Point 게시판 글 작성" pageType="main">
	<jsp:attribute name="bodyContent">
		<script src="${cpath}/resources/js/summernote/summernote-lite.js"></script>
		<script src="${cpath}/resources/js/board.js"></script>
		
		<div class="grow flex flex-col items-center py-10">
			<div class="w-full w-[90%] flex flex-col items-center">
				<div class="w-full flex items-end gap-x-4 mb-4">
					<img alt="service image" src="${cpath}/resources/images/service_image_1.png" class="hidden sm:block sm:h-48 md:h-64 lg:h-80">
					<div class="grow sm:mb-8 flex flex-col gap-4">
						<div class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 md:ml-2">게시판 글 작성</div>
						<div class="overflow-y-scroll">
							<div class="font-bold text-xs sm:text-sm mb-2">✍️ 글 작성 시 유의사항</div>
							<ul class="list-disc list-inside space-y-1 text-[0.625rem] sm:text-xs">
								<li><strong>욕설, 비방, 혐오 표현</strong>은 절대 금지입니다. 서로를 존중하며 건강한 커뮤니티를 지켜주세요.</li>
							    <li><strong>개인정보(전화번호, 주소, 계좌번호 등)</strong>가 포함된 글은 작성하지 마세요.</li>
							    <li><strong>무단 광고나 홍보성 게시물</strong>은 사전 통보 없이 삭제될 수 있습니다.</li>
							    <li><strong>중복된 내용의 도배성 글</strong>은 자제 부탁드립니다.</li>
							    <li><strong>게시판 주제와 무관한 내용</strong>은 다른 이용자에게 혼란을 줄 수 있습니다.</li>
							    <!-- <li>부적절한 게시물은 <strong>신고 기능</strong>을 통해 알려주세요.</li> -->
							</ul>
							<div class="mt-4 text-[0.625rem] sm:text-xs text-yellow-700 italic">
								✅ 아름다운 인터넷 환경은 우리 모두의 손으로 만들어집니다. 예의를 지키며 함께 좋은 커뮤니티를 만들어가요 😊
							</div>
						</div>
					</div>
				</div>
				<div class="w-full h-[2px] bg-gray-1 mb-4"></div>
				<div class="w-full grid grid-cols-1 lg:grid-cols-5">
					<div class="col-span-4 w-full h-full flex flex-col gap-y-4 bg-gray-8 p-4">
						<input type="text" id="title" name="title" class="text-3xl font-extrabold bg-transparent outline-none" placeholder="제목을 입력하세요">
						<div class="grid grid-cols-4 gap-4 text-white text-xs sm:text-xm md:text-base">
							<input type="hidden" id="category" name="category" value="free" />
							<button data-tab="free" class="tab-btn bg-blue-3 rounded-full shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-1">자유</button>
							<button data-tab="info" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-full shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-1">정보/조언</button>
							<button data-tab="idea" class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-full shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-1">제안/아이디어</button>
						</div>
						<div class="w-full bg-white">
							<textarea id="summernote" name="content"></textarea>
						</div>
					</div>
					<div class="col-span-1 flex lg:flex-col items-center justify-end gap-4 bg-blue-4 p-4 font-bold text-white text-base md:text-lg lg:text-xl">
						<button class="w-full bg-blue-3 hover:bg-blue-4 rounded-full py-2.5" onclick="history.back()">취소하기</button>
						<button class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5">등록하기</button>						
					</div>
				</div>
			</div>
		</div>
		<script>
		  $(document).ready(function () {
		    if ($('#summernote').length) {
		      $('#summernote').summernote({
		        height: 400,
		        lang: "ko-KR",
		        placeholder: '최대 2048자까지 쓸 수 있습니다',
		        callbacks: {
		          onImageUpload: function (files) {
		            uploadSummernoteImageFile(files[0], this);
		          },
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
		
		      // 이미지 업로드 함수
		      function uploadSummernoteImageFile(file, editor) {
		        let data = new FormData();
		        data.append("image", file);
		
		        $.ajax({
		          data: data,
		          type: "POST",
		          url: "/api/board/image-upload",
		          contentType: false,
		          processData: false,
		          success: function (data) {
		            $(editor).summernote('insertImage', data.url);
		          },
		          error: function () {
		            alert("이미지 업로드에 실패했습니다.");
		          }
		        });
		      }
		
		      // 게시글 등록 폼 제출 처리
		      $('#insertForm').on('submit', function (e) {
		        e.preventDefault();
		
		        const token = localStorage.getItem("accessToken");
		        if (!token) {
		          alert("로그인이 필요합니다.");
		          return;
		        }
		
		        const dto = {
		          title: $('#title').val(),
		          content: $('#summernote').summernote('code'),
		          category: $('#category').val() || "free"
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
		  });
		  
		  $(".tab-btn").on("click", function () {
				const selectedTab = $(this).data("tab");
				
				// 탭 버튼 스타일 초기화
				$(".tab-btn").removeClass("bg-blue-3").addClass("bg-blue-4 hover:bg-blue-3");
				$(this).removeClass("bg-blue-4 hover:bg-blue-3").addClass("bg-blue-3");

				// ✅ 숨겨진 category input 값 변경
				$("#category").val(selectedTab);
			});
		</script>
	</jsp:attribute>
</ui:layout>