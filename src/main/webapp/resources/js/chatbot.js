$(document).ready(function() {

	var cpath = "/game";
	
	// 카테고리 선택 시 질문 목록 불러오기
    $("#categorySelect").change(function() {
        const selectedCategory = $(this).val();

        $.ajax({
            url: `${cpath}/chat/questionByCate.do`,
            method: "GET",
            data: { category: selectedCategory },
            success: function(data) {
            	console.log("받은 데이터:", data, selectedCategory);
                let html = "";
                data.forEach(function(q) {
                    html += `<li><a href="#" class="question" data-uid="${q.uid}">${q.question_text}</a></li>`;
                });
                $("#categoryList").html(html);
            },
            error: function() {
                alert("질문 목록을 불러오는 데 실패했습니다.");
            }
        });
    });
	
    // 전체 질문 리스트 불러오기
    $("#questionAll").on("click", function(e) {
	    $.ajax({
	        url: `${cpath}/chat/quesiton.do`,
	        method: "GET",
	        success: function(data) {
	        	//console.log("받은 데이터:", data);
	            let html = "";
	            data.forEach(function(q, idx) {
	            	//console.log(`q[${idx}] =`, q);
	                html += `<li><a href="#" class="question" data-uid="${q.uid}">${q.question_text}</a></li>`;
	            });
	            $("#categoryList").html(html);
	        },
	        error: function() {
	            alert("질문 목록을 불러오는 데 실패했습니다.");
	        }
   		});
	});

    // 질문 클릭 시 답변 불러오기
    $(document).on("click", ".question", function(e) {
        e.preventDefault();
        const uid = $(this).data("uid");
        
        $.ajax({
            url: `${cpath}/chat/answer.do`,
            method: "GET",
            data: { uid: uid },
            success: function(answer) {
                $("#answerText").text(answer);
            },
            error: function() {
                $("#answerText").text("답변을 불러오는 데 실패했습니다.");
            }
        });
    });
});