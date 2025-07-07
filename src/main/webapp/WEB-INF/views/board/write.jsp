<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<c:set var="mode" value="${empty boardId ? 'create' : 'update'}" />

<ui:layout pageName="Betting Point 게시판 글 ${mode == 'create' ? '작성' : '수정'}" pageType="main">
  <jsp:attribute name="bodyContent">
  
    <script src="${cpath}/resources/js/summernote/summernote-lite.js"></script>
    <script src="${cpath}/resources/js/board.js"></script>
    
    <div class="grow flex flex-col items-center py-10">
      <div class="w-full w-[90%] flex flex-col items-center">
        <div class="w-full flex items-end gap-x-4 mb-4">
          <img alt="service image"
               src="${cpath}/resources/images/service_image_1.png"
               class="hidden sm:block sm:h-48 md:h-64 lg:h-80">
          <div class="grow sm:mb-8 flex flex-col gap-4">
            <div class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 md:ml-2">
              게시판 글 ${mode == 'create' ? '작성' : '수정'}
            </div>
            <div>
              <div class="font-bold text-xs sm:text-sm mb-2">✍️ 글 작성 시 유의사항</div>
              <ul class="list-disc list-inside space-y-1 text-[0.625rem] sm:text-xs">
                <li><strong>욕설, 비방, 혐오 표현</strong>은 절대 금지입니다. 서로를 존중하며 건강한 커뮤니티를 지켜주세요.</li>
                <li><strong>개인정보(전화번호, 주소, 계좌번호 등)</strong>가 포함된 글은 작성하지 마세요.</li>
                <li><strong>무단 광고나 홍보성 게시물</strong>은 사전 통보 없이 삭제될 수 있습니다.</li>
                <li><strong>중복된 내용의 도배성 글</strong>은 자제 부탁드립니다.</li>
                <li><strong>게시판 주제와 무관한 내용</strong>은 다른 이용자에게 혼란을 줄 수 있습니다.</li>
              </ul>
              <div class="mt-4 text-[0.625rem] sm:text-xs text-yellow-700 italic">
                ✅ 아름다운 인터넷 환경은 우리 모두의 손으로 만들어집니다. 예의를 지키며 함께 좋은 커뮤니티를 만들어가요 😊
              </div>
            </div>
          </div>
        </div>
        <div class="w-full h-[2px] bg-gray-1 mb-4"></div>

        <form id="insertForm" class="w-full grid grid-cols-1 lg:grid-cols-5">
          <!-- 숨겨진 boardId -->
          <c:if test="${mode == 'update'}">
            <input type="hidden" id="boardId" name="boardId" value="${boardId}" />
          </c:if>

          <div class="col-span-4 w-full h-full flex flex-col gap-y-4 bg-gray-8 p-4">
            <input type="text" id="title" name="title"
                   class="text-3xl font-extrabold bg-transparent outline-none"
                   placeholder="제목을 입력하세요" required>
            
            <div class="grid grid-cols-4 gap-4 text-white text-xs sm:text-xm md:text-base">
              <input type="hidden" id="category" name="category" value="free" />
              <button type="button" data-tab="free"
                      class="tab-btn bg-blue-3 rounded-full shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-1">
                자유
              </button>
              <button type="button" data-tab="info"
                      class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-full shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-1">
                정보/조언
              </button>
              <button type="button" data-tab="idea"
                      class="tab-btn bg-blue-4 hover:bg-blue-3 rounded-full shadow-[2px_2px_8px_rgba(0,0,0,0.1)] py-1">
                제안/아이디어
              </button>
            </div>

            <div class="w-full bg-white">
              <textarea id="summernote" name="content"></textarea>
            </div>
          </div>

          <div class="col-span-1 flex lg:flex-col items-center justify-end gap-4
                      bg-blue-4 p-4 font-bold text-white text-base md:text-lg lg:text-xl">
            <button type="submit"
                    class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5">
              ${mode == 'create' ? '등록하기' : '수정하기'}
            </button>
            
            <button class="w-full bg-blue-3 hover:bg-blue-4 rounded-full py-2.5"
                    onclick="history.back()">취소하기</button>
          </div>
        </form>
      </div>
    </div>
    <script>
		  const boardId = "${boardId}";
		
		  $(document).ready(function () {
			  
		    // 1) Summernote 초기화
		    if ($('#summernote').length) {
		      $('#summernote').summernote({
		        height: 500,
		        lang: "ko-KR",
		        placeholder: '최대 2048자까지 쓸 수 있습니다',
		        toolbar: [
		            	// 글꼴 
		                [ 'fontname', ['fontname']],
		                // 글자 크기 설정
		                ['fontsize', ['fontsize']],
		                // 글꼴 스타일
		                ['font', ['bold', 'underline', 'clear']],
		                // 글자 색상
		                ['color', ['color']],
		                // 문단 스타일
		                ['para', ['paragraph']],
		                // 글 높낮이 간격
		                ['height', ['height']],
		            	// 이미지 삽입
		                ['insert', ['picture']],
		                // 코드 보기
		                ['view', ['codeview']],   
		            ],
					
		        callbacks: {
		          onImageUpload: function (files) {
		            uploadSummernoteImageFile(files[0], this);
		          },
		          // 에디터에서 사진 지우는 즉시 s3에서도 삭제.
		          onMediaDelete: function (target) {
		        	// target: jQuery 객체(<img> 요소)
		            const imageUrl = target.attr('src');
		            $.ajax({
		              url: '/api/board/image-delete',
		              method: 'DELETE',
		              contentType: 'application/json',
		              data: JSON.stringify({ url: imageUrl }),
		              success: function () {
		                console.log('S3에서 이미지 삭제 완료');
		              },
		              error: function (err) {
		                console.error('S3 이미지 삭제 실패:', err);
		              }
		            });
		          }
		        }
		      });
		    }
		
		    // 2) 이미지 업로드 함수
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
		          $(editor).summernote('insertImage', res.url);
		        },
		        error: function () {
		          alert("이미지 업로드에 실패했습니다.");
		        }
		      });
		    }
		
		    // 3) 수정 모드일 때 기존 데이터 불러오기
		    <c:if test="${mode == 'update'}">
		    (function(){
		      const bid = $('#boardId').val();
		      $.ajax({
		        url: '/api/board/boarddetail/' + bid,
		        type: "GET",
		        success: function(b) {
		          $('#title').val(b.title);
		          $('#category').val(b.category);
		          $('#summernote').summernote('code', b.content);
		        },
		        error: function() {
		          alert('기존 글을 불러오지 못했습니다.');
		          history.back();
		        }
		      });
		    })();
		    </c:if>
		
		    // 4) 폼 제출 처리
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
		
		      let url, method;
		      <c:choose>
		        <c:when test="${mode == 'update'}">
		          url = '/api/board/boardupdate/' + boardId;
		          method = 'PUT';
		        </c:when>
		        <c:otherwise>
		          url = '/api/board/boardinsert';
		          method = 'POST';
		        </c:otherwise>
		      </c:choose>
		
		      $.ajax({
		        url: url,
		        method: method,
		        contentType: 'application/json',
		        headers: { 'Authorization': 'Bearer ' + token },
		        data: JSON.stringify(dto),
		        success: function () {
		          alert("게시글이 ${mode == 'update' ? '수정' : '등록'} 되었습니다.");
		          location.href = "/board";
		        },
		        error: function () {
		          alert("게시글이 ${mode == 'update' ? '수정' : '등록'} 되었습니다.");
		        }
		      });
		    });
		
		    // 5) 카테고리 탭 클릭 처리
		    $(".tab-btn").on("click", function () {
		      const selectedTab = $(this).data("tab");
		      $(".tab-btn")
		        .removeClass("bg-blue-3")
		        .addClass("bg-blue-4 hover:bg-blue-3");
		      $(this)
		        .removeClass("bg-blue-4 hover:bg-blue-3")
		        .addClass("bg-blue-3");
		      $("#category").val(selectedTab);
		    });
		
		  }); // 문서 로드 콜백 끝
	</script>
  </jsp:attribute>
</ui:layout>
