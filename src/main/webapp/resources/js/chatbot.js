	$(document).ready(function () {
		// 메인 카테고리 버튼 클릭
	    $(".main-btn").on("click", function () {
	        const mainCategory = $(this).data("main");
	        $(".main-btn").removeClass("active");
	        $(this).addClass("active");

	        $.ajax({
	            url: `/api/chat/subcategories/${mainCategory}`,
	            method: "GET",
	            success: function (subCategories) {
	                let html = "";
	                subCategories.forEach(sc => {
	                    html += `<button class="sub-btn" data-main="${mainCategory}" data-sub="${sc}">${sc}</button>`;
	                });
	                $("#subCategoryButtons").html(html);
	                $("#questionList").empty();
	                $("#answerText").text("선택한 질문의 답변이 여기에 표시됩니다.");
	            }
	        });
	    });
	
	    // 서브 카테고리 버튼 클릭
	    $(document).on("click", ".sub-btn", function () {
	        const mainCategory = $(this).data("main");
	        const subCategory = $(this).data("sub");
	        $(".sub-btn").removeClass("active");
	        $(this).addClass("active");

	        $.ajax({
	            url: `/api/chat/questions/${mainCategory}/${subCategory}`,
	            method: "GET",
	            success: function (questions) {
	                let html = "";
	                questions.forEach(q => {
	                    html += `<li><a href="#" class="question" data-uid="${q.uid}">${q.question_text}</a></li>`;
	                });
	                $("#questionList").html(html);
	                $("#answerText").text("선택한 질문의 답변이 여기에 표시됩니다.");
	            }
	        });
	    });
	
	    // ✅ 질문 클릭 시 → 답변 출력
	    $(document).on("click", ".question", function (e) {
	        e.preventDefault();
	        const uid = $(this).data("uid");
	        
	        // 모든 질문에서 active 제거
	        $(".question").removeClass("active");
	        // 선택한 질문에만 active 추가
	        $(this).addClass("active");
	
	        $.ajax({
	            url: `/api/chat/answer/${uid}`,
	            method: "GET",
	            success: function (answer) {
	                $("#answerText").text(answer);
	            },
	            error: function () {
	                $("#answerText").text("답변을 불러오는 데 실패했습니다.");
	            }
	        });
	    });
	
	    // ✅ 전체 질문 보기
	    $("#questionAll").on("click", function () {
	        $.ajax({
	            url: `/api/chat/allQuestion`,
	            method: "GET",
	            success: function (data) {
	                let html = "";
	                data.forEach(q => {
	                    html += `<li><a href="#" class="question" data-uid="${q.uid}">${q.question_text}</a></li>`;
	                });
	                $("#questionList").html(html);
	                $("#answerText").text("선택한 질문의 답변이 여기에 표시됩니다.");
	                $("#mainCategory").val("");
	                $("#subCategory").html('<option value="">-- 먼저 상위 카테고리를 선택하세요 --</option>');
	            },
	            error: function () {
	                alert("전체 질문을 불러오는 데 실패했습니다.");
	            }
	        });
	    });
	});
