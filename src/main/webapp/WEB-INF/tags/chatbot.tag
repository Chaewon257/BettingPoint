<%@ tag language="java" pageEncoding="UTF-8" description="챗봇 컴포넌트"%>

<script type="text/javascript">
   	function chatWidth() {
   	    const screenWidth = $(window).width();
   	 	const screenHeight = $(window).height() * 0.8;
   	 	
   	 	$("#chatbotContainer").css("max-height", `\${screenWidth}px`);

   	    if (screenWidth < 408) {
   	  		// 버튼 스타일 업데이트
			$("#chatbotContainer").removeClass("right-6 w-96").addClass("right-0 w-full");
   	        $("#chatbotContainer").css({
   	            width: `${screenWidth}px`, // 원래 스크린 전체 너비
   	            right: "0px"
   	        });
   	    } else {
			$("#chatbotContainer").removeClass("right-0 w-full").addClass("right-6 w-96");
   	        $("#chatbotContainer").css({
   	            width: "",
   	            right: "1.5rem" // Tailwind right-6 = 1.5rem (24px)
   	        });
   	    }
   	}
   	
   	function categoryBtnEvents() {
   		$(".category-btn").on("click", function () {
	        const selectedCategory = $(this).data("category");
	        
	     	// 버튼 스타일 업데이트
			$(".category-btn").removeClass("bg-gray-3").addClass("bg-gray-1 hover:bg-gray-3");
			$(this).removeClass("bg-gray-1 hover:bg-gray-3").addClass("bg-gray-3");

			if(selectedCategory === 'ALL') {
				$.ajax({
			           url: `/api/chat/allQuestion`,
			           method: "GET",
			           success: function (data) {
			           	let html = `
					    	<div class="flex items-start space-x-2 animate-fadeInUp mb-2.5">
					        	<div class="w-8 h-8 bg-[#F1B752] rounded-full flex items-center justify-center flex-shrink-0 p-0.5">
					            	<img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
					           	</div>
					            <div class="bg-gray-100 rounded-lg p-3 max-w-xs">
					            	<p class="text-sm text-gray-800">무엇을 도와드릴까요?</p>
					            </div>
					        </div>
					    `;
					    
			               data.forEach(question => {
			                   html += `
			                   	<button data-uid="\${question.uid}" class="question-btn bg-gray-1 hover:bg-gray-3 rounded flex items-center gap-0.5 px-1 py-0.5 mb-0.5">
			    	            	<svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
			                            <path fill-rule="evenodd" d="M18 10c0 3.866-3.582 7-8 7a8.841 8.841 0 01-4.083-.98L2 17l1.338-3.123C2.493 12.767 2 11.434 2 10c0-3.866 3.582-7 8-7s8 3.134 8 7zM7 9H5v2h2V9zm8 0h-2v2h2V9zM9 9h2v2H9V9z" clip-rule="evenodd"></path>
			                        </svg>
			                        <div class="font-light">\${question.question_text}</div>
			    	            </button>
			    	   		`;
			               });
			               $("#subCategoryButtons").html("");
			               $("#questionList").html(html);
			               $("#answerText").text("");
			           },
			           error: function () {
			               alert("전체 질문을 불러오는 데 실패했습니다.");
			           }
			       });
			} else {
				const getSubCategorieText = (subCategorie) => ({ INFO: '정보', RULE: '규칙', POINT: '포인트', ACCOUNT: '계정&회원', SYSTEM: '기술&시스템' }[subCategorie] || '-');
				
				$.ajax({
					url: `/api/chat/subcategories/\${selectedCategory}`,
				    method: "GET",
				    success: function (subCategories) {
					    let html = `
					    	<div class="flex items-start space-x-2 animate-fadeInUp mb-2.5">
					        	<div class="w-8 h-8 bg-[#F1B752] rounded-full flex items-center justify-center flex-shrink-0 p-0.5">
					            	<img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
					           	</div>
					            <div class="bg-gray-100 rounded-lg p-3 max-w-xs">
					            	<p class="text-sm text-gray-800">세부 카테고리를 선택해주세요.</p>
					            </div>
					        </div>
					        <div class="grid grid-cols-2 animate-fadeInUp gap-1 mb-5">
					    `;
					    
					    subCategories.forEach(subCategory => {
				        	html += `
				            	<button data-category="\${selectedCategory}" data-subcategory="\${subCategory}" class="subcategory-btn w-full bg-gray-1 hover:bg-gray-3 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold text-lg py-1">\${getSubCategorieText(subCategory)}</button>
				           	`;
				       	});
				        
					    html += '</div>';
					    
					    $("#subCategoryButtons").html(html);
					    $("#questionList").html("");
					    $("#answerText").html("");
					}
				});
			}
   		});      
   	}
   	
   	$(document).ready(function () {
   		// 초기 컨텐츠를 변수에 저장
	    const initialContent = $("#chatbotContainer").html();
   		
	    // 모달을 감시하는 MutationObserver 생성
	    const targetNode = document.getElementById("chatbotContainer");

	    const observer = new MutationObserver(function (mutationsList, observer) {
	        for (const mutation of mutationsList) {
	            if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
	                const isHidden = $(targetNode).hasClass("hidden");
	                if (isHidden) {
	                    // hidden 되었을 때 초기화
	                    $("#chatbotContainer").html(initialContent);
	                    
	                    chatWidth();
	                	categoryBtnEvents();
	                }
	            }
	        }
	    });

	    // observer 옵션 설정
	    observer.observe(targetNode, { attributes: true });
   		
  		// 처음 실행
    	chatWidth();
    	categoryBtnEvents();
    	
  		// 리사이즈 시 다시 적용
    	$(window).resize(function() {
    		chatWidth();
    	});
  	
  		// 서브 카테고리 버튼 클릭
		$(document).on("click", ".subcategory-btn", function () {
	        const selectedCategory = $(this).data("category");
	        const selectedSubCategory = $(this).data("subcategory");
	        
	     	// 버튼 스타일 업데이트
			$(".subcategory-btn").removeClass("bg-gray-3").addClass("bg-gray-1 hover:bg-gray-3");
			$(this).removeClass("bg-gray-1 hover:bg-gray-3").addClass("bg-gray-3");
			
			$.ajax({
				url: `/api/chat/questions/\${selectedCategory}/\${selectedSubCategory}`,
			    method: "GET",
			    success: function (questions) {
				    let html = `
						<div class="flex items-start space-x-2 animate-fadeInUp mb-2.5">
					    	<div class="w-8 h-8 bg-[#F1B752] rounded-full flex items-center justify-center flex-shrink-0 p-0.5">
					        	<img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
					        </div>
					        <div class="bg-gray-100 rounded-lg p-3 max-w-xs">
					        	<p class="text-sm text-gray-800">무엇을 도와드릴까요?</p>
					        </div>
					    </div>
					    `;
					    
				    questions.forEach(question => {
				    	html += `
				        	<button data-uid="\${question.uid}" class="question-btn bg-gray-1 hover:bg-gray-3 rounded flex items-center gap-0.5 px-1 py-0.5 mb-0.5">
				   	        	<svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
				                	<path fill-rule="evenodd" d="M18 10c0 3.866-3.582 7-8 7a8.841 8.841 0 01-4.083-.98L2 17l1.338-3.123C2.493 12.767 2 11.434 2 10c0-3.866 3.582-7 8-7s8 3.134 8 7zM7 9H5v2h2V9zm8 0h-2v2h2V9zM9 9h2v2H9V9z" clip-rule="evenodd"></path>
				                </svg>
				                <div class="font-light">\${question.question_text}</div>
				   	        </button>
				   	   	`;
				    });
				              
				    $("#questionList").html(html);
			        $("#answerText").text("");
			    },
			    error: function () {
			    	alert("질문을 불러오는 데 실패했습니다.");
			    }
			});
		});
  	
		// 질문 버튼 클릭
		$(document).on("click", ".question-btn", function (e) {
			e.preventDefault();
     			const uid = $(this).data("uid");
     
  				// 버튼 스타일 업데이트
			$(".question-btn").removeClass("bg-gray-3 text-white").addClass("bg-gray-1 hover:bg-gray-3");
			$(this).removeClass("bg-gray-1 hover:bg-gray-3").addClass("bg-gray-3 text-white");

			$.ajax({
				url: `/api/chat/answer/\${uid}`,
			    method: "GET",
			    success: function (answer) {
			    	$("#answerText").html(`
			        	<div class="flex items-start space-x-2 animate-fadeInUp my-2.5">
					    	<div class="w-8 h-8 bg-[#F1B752] rounded-full flex items-center justify-center flex-shrink-0 p-0.5">
					        	<img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
					        </div>
					        <div class="bg-gray-100 rounded-lg p-3 max-w-xs">
					        	<p class="text-sm text-gray-800">\${answer}</p>
					        </div>
					    </div>
			        `);
			    },
			    error: function () {
			    	$("#answerText").text("답변을 불러오는 데 실패했습니다.");
			    }
			});
		});
	});
</script>
<button
	id="chatbotToggle"
	class="fixed bottom-6 right-6 w-16 h-16 p-2 flex flex-col items-center justify-center bg-[#FFE29E] text-white rounded-full shadow-lg hover:bg-[#F1B752] focus:outline-none focus:ring-4 focus:ring-[#F1B752] z-50 animate-bounce-custom transition-all duration-300 ease-in-out"
	onclick="document.getElementById('chatbotContainer').classList.toggle('hidden')"
>
	<img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
</button>
<!-- 챗봇 UI -->
<div id="chatbotContainer" class="fixed bottom-24 right-6 hidden w-96 bg-white rounded-lg shadow-2xl flex flex-col z-40">
	<!-- 헤더 -->
	<div class="bg-[#FFE29E] p-4 rounded-t-lg flex items-center justify-between">
	    <div class="flex items-center">
	        <div class="w-10 h-10 bg-[#F1B752] rounded-full flex items-center justify-center mr-3 p-0.5">
	            <img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
	      	</div>
	      	<div>
	        	<h1 class="font-semibold text-lg">고객 지원 챗봇</h1>
	      	</div>
	  	</div>
	  	<button
	  		id="closeChatbot"
	  		class="text-gray-700 hover:text-white transition-colors"
			onclick="document.getElementById('chatbotContainer').classList.add('hidden')"
	  	>
	        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
	            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
	        </svg>
	    </button>
	</div>
	
	<!-- 채팅 메시지 영역 -->
	<div id="chatMessages" class="overflow-y-scroll flex-1 flex flex-col p-4">
	    <!-- 초기 환영 메시지 -->
	  	<div class="flex items-start space-x-2 animate-fadeInUp mb-2.5">
	      	<div class="w-8 h-8 bg-[#F1B752] rounded-full flex items-center justify-center flex-shrink-0 p-0.5">
	      		<img id="chatIcon" src="${cpath}/resources/images/chatbot.png" alt="chatbot" class="w-full h-full transition-all duration-200" />
	        </div>
	        <div class="bg-gray-100 rounded-lg p-3 max-w-xs">
	        	<p class="text-sm text-gray-800">안녕하세요! 문의 카테고리를 선택해주세요.</p>
	        </div>
	    </div>
	    <div class="grid grid-cols-2 grid-rows-2 animate-fadeInUp gap-1 mb-5">
	    	<button data-category="ALL" class="category-btn w-full bg-gray-1 hover:bg-gray-3 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold text-lg py-1">전체조회</button>
	        <button data-category="GAME" class="category-btn w-full bg-gray-1 hover:bg-gray-3 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold text-lg py-1">게임</button>
	        <button data-category="POINT" class="category-btn w-full bg-gray-1 hover:bg-gray-3 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold text-lg py-1">포인트</button>
	        <button data-category="ETC" class="category-btn w-full bg-gray-1 hover:bg-gray-3 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold text-lg py-1">기타</button>
	    </div>
	    <div id="subCategoryButtons"></div>
	    <div id="questionList"></div>
	    <div id="answerText"></div>
	</div>
</div>