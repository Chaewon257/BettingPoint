<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Poing 로그인" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<div class="grow flex items-center justify-center w-full px-10 md:px-0 ">
			<div class="w-full flex items-end justify-center gap-x-2.5">
	  			<img class="hidden md:block max-w-[14rem] min-w-[8rem]" src="${cpath}/resources/images/auth_fox.png" alt="Fox Character" />
	  			<div class="flex min-w-[22rem] max-w-[56.063rem] h-1/2 grow bg-white rounded-3xl shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
	  				<div class="relative hidden xl:block w-[17.125rem] overflow-hidden">
		  				<img alt="Login Side Background" src="${cpath}/resources/images/login-side-bg.png" class="h-full max-w-[274px]"/>
		  				<a href="/" class="absolute top-10 end-1/2 translate-x-1/2">
		  					<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" width="178" />
						</a>
		  			</div>
		  			<div class="flex flex-col min-w-[22rem] grow items-center justify-center p-4">
		  				<div class="w-full md:w-10/12 flex flex-col justify-items-start mb-4">
		  					<span class="text-ts-28 pl-1.5 mb-16">로그인</span>
		  					<input type="email" id="email" name="userid" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="사용자 ID (Email)" required>
		  					<input type="password" id="password" name="userpw" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="비밀번호" required>
		  					<span id="errorMessage" class="text-xs w-full h-5 text-red-600 mb-2 ml-2"></span>
		  					<button id="loginSubmitbtn" class="w-full px-10 py-3 outline-none bg-blue-2 rounded-full border border-blue-2 text-white text-lg hover:bg-blue-1">로그인</button>
		  				</div>
		  				<div class="w-full md:w-10/12 flex gap-x-8 text-gray-3 justify-end px-4 mb-8">
		  					<a href="/register" class="hover:text-gray-6">회원가입</a>
		  					|
		  					<button class="hover:text-gray-6" onclick="document.getElementById('findAccountModal').classList.remove('hidden')">ID/PW찾기</button>
		  				</div>
		  			</div>
	  			</div>
	  			<img class="hidden md:block max-w-[14rem] min-w-[8rem]" src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" />  			
	  		</div>
	  	</div>
	  	<ui:modal modalId="findAccountModal" title="아이디/비밀번호 찾기">
	  		<jsp:attribute name="content">
	  			<div id="modalContainer" class="overflow-y-scroll flex flex-col items-center justify-center p-4">
	  				<button data-tab="findId" class="tab-btn w-full px-10 py-3 outline-none bg-blue-3 rounded-full text-white text-lg hover:bg-blue-1 my-4">아이디 찾기</button>
	  				<button data-tab="findPassword" class="tab-btn w-full px-10 py-3 outline-none bg-blue-3 rounded-full text-white text-lg hover:bg-blue-1 mb-4">비밀번호 찾기</button>
	  			</div>
	  		</jsp:attribute>
	  	</ui:modal>
	  	<script type="text/javascript">
	  		document.getElementById('loginSubmitbtn').addEventListener('click', function (e) {
		  	    e.preventDefault(); // 기본 제출 막기
		  	    
			  	const errorElement = document.getElementById('errorMessage');
			  	errorElement.textContent = "";
	
		  	    const emailInput = document.getElementById('email');
				const emailVal = emailInput.value.trim();
			    const passwordInput = document.getElementById('password');
				const passwordVal = passwordInput.value;

		  	  	if (!emailVal) {
		  	  		errorElement.textContent = "이메일을 입력해주세요.";
					emailInput.classList.add("border-red-600");
					return;
				} else {
					emailInput.classList.remove("border-red-600");
					emailInput.classList.add("border-gray-5");
				}
		  	  	
		  	  	if (!passwordVal) {
		  			errorElement.textContent = "비밀번호를 입력해주세요.";
					passwordInput.classList.add("border-red-600");
					return;
				} else {
					passwordInput.classList.remove("border-red-600");
					passwordInput.classList.add("border-gray-5");
				}
		  	  	
		  	  	const requestBody = {
		  	  		email: emailVal,
		  	  		password: passwordVal
		  	  	}
		  	    
		  	    $.ajax({
		  	    	url: '/api/auth/login',
		  	    	type: 'POST',
		  	    	contentType: 'application/json',
		  	    	data: JSON.stringify(requestBody),
		  	    	xhrFields: {
		  				withCredentials: true  // ✅ 쿠키 포함 허용
		  			},
		  	    	success: function (response) {
		  	        	// 토큰 저장
		  	        	localStorage.setItem('accessToken', response.accessToken);
		  	        	
		  	        	alert(response.message);
		  	        	
		  	        	window.location.href = '/'; // 성공 시 이동
		  	      	},
		  	    	error: function (xhr) {
		  	    		let message = "로그인 실패";

			  	    	try {
			  	    		const json = JSON.parse(xhr.responseText);
			  	    	    if (json.message) {
			  	    	      message = json.message;
			  	    	    }
			  	    	} catch (e) {
			  	    	    // JSON 파싱 실패 시 기본 메시지 사용
			  	    	    message = xhr.responseText || message;
			  	    	}
	
			  	    	errorElement.textContent = message;
		  			},
		  		});
		  	});
	  	
		 	// 화면 너비 계산
			function adjustWidth() {
			    let screenWidth = $(window).width();
			    let newWidth;
	
			    if (screenWidth >= 1280) {
			        newWidth = screenWidth * 0.3;
			    } else if (screenWidth >= 1024) {
			        newWidth = screenWidth * 0.4;
			    } else if (screenWidth >= 768) {
			        newWidth = screenWidth * 0.5;
			    } else if (screenWidth >= 640) {
			        newWidth = screenWidth * 0.6;
			    } else {
			        newWidth = screenWidth - 32;
			    }
	
			    $("#modalContainer").css("width", `\${newWidth}px`);
			}
	
			
			// 탭 버튼 이벤트 바인딩 함수
			function bindTabBtnEvents() {
				// 아이디/비밀번호 찾기 버튼 클릭
				$(".tab-btn").on("click", function () {
					const selectedTab = $(this).data("tab");
					
					// 콘텐츠 영역 비우고 로딩
					const contentContainer = $("#modalContainer");
					contentContainer.html('<div class="text-center py-8 text-gray-5">로딩 중...</div>');
					
					// 선택된 탭에 따라 콘텐츠 요청
					$.ajax({
						url: `/\${selectedTab}`,
						type: 'GET',
						success: function (html) {
							contentContainer.html(html);
						},
						error: function () {
							contentContainer.html('<div class="text-red-500">콘텐츠 로딩 실패</div>');
						}
					});
				});
			}
			
			$(document).ready(function () {
				// 처음 실행
				adjustWidth();
			    bindTabBtnEvents();

				// 리사이즈 시 다시 적용
				$(window).resize(function() {
				    adjustWidth();
				});
				
			    // 초기 컨텐츠를 변수에 저장
			    const initialContent = $("#modalContainer").html();

			    // 모달을 감시하는 MutationObserver 생성
			    const targetNode = document.getElementById("findAccountModal");

			    const observer = new MutationObserver(function (mutationsList, observer) {
			        for (const mutation of mutationsList) {
			            if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
			                const isHidden = $(targetNode).hasClass("hidden");
			                if (isHidden) {
			                    // hidden 되었을 때 초기화
			                    $("#modalContainer").html(initialContent);
			                    
			                 	// 초기화 후 다시 바인딩
			                    adjustWidth();
			                    bindTabBtnEvents();
			                }
			            }
			        }
			    });

			    // observer 옵션 설정
			    observer.observe(targetNode, { attributes: true });
			});
	  	</script>
	</jsp:attribute>
</ui:layout>