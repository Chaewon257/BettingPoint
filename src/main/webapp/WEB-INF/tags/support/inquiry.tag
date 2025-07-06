<%@ tag language="java" pageEncoding="UTF-8"%>

<script src="${cpath}/resources/js/summernote/summernote-lite-support.js"></script>
<div class="w-full grid grid-cols-1 lg:grid-cols-5">
	<div class="col-span-4 w-full h-full flex flex-col gap-y-4 bg-gray-8 p-4">
		<input type="text" id="title" name="title" class="text-3xl font-extrabold bg-transparent outline-none" placeholder="제목을 입력하세요">
		<div class="w-full bg-white">
			<textarea id="summernote" name="content"></textarea>
		</div>
	</div>
	<div class="col-span-1 flex lg:flex-col items-center justify-end gap-4 bg-blue-4 p-4 font-bold text-white text-base md:text-lg lg:text-xl">
		<button class="w-full bg-blue-3 hover:bg-blue-4 rounded-full py-2.5" onclick="window.location.href = '${cpath}/support'">취소하기</button>
		<button id="submit-inquiry" class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5">문의하기</button>
	</div>
</div>
<script>
	$(document).ready(function() {
		if ($('#summernote').length) {
			$('#summernote').summernote({
				height : 400,
				lang : "ko-KR",
				toolbar: [
	            	// 글꼴 
	                ['fontname', ['fontname']],
	                // 글자 크기 설정
	                ['fontsize', ['fontsize']],
	                // 글꼴 스타일
	                ['font', ['bold', 'underline', 'clear']],
	                // 글자 색상
	                ['color', ['color']],
	                // 문단 스타일
	                ['para', ['paragraph']],
	                // 코드 보기
	                ['view', ['codeview']],
	            ],
				
				placeholder : '최대 2048자까지 쓸 수 있습니다'
			});
		}
	});
	
	// 🔹 문의하기 버튼 클릭 시
	$(document).on("click", "#submit-inquiry", function () {
	    const title = $("#title").val().trim();
	    const question = $("#summernote").val().trim();

	    if (!title || !question) {
	        alert("제목과 내용을 모두 입력해주세요.");
	        return;
	    }

	    const requestData = {
	        title: title,
	        question: question
	    };

	    $.ajax({
	        url: "/api/chatlog/insertChatlog",
	        type: "POST",
	        contentType: "application/json",
	        data: JSON.stringify(requestData),
	        success: function () {
	            alert("문의가 정상적으로 등록되었습니다. 문의 내역 확인은 [마이페이지]-[문의 내역]에서 확인해주세요!");
	            window.location.href = "/support";
	        },
	        error: function () {
	            alert("문의 등록에 실패했습니다.");
	        }
	    });
	});

</script>