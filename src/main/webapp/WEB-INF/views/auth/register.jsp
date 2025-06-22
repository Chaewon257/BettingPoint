<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Poing 회원가입" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<div class="fixed top-0 left-0 flex items-center justify-center h-screen w-full px-10 md:px-0 pt-11 md:pt-16 lg:pt-20">
	  		<div class="w-full flex items-end justify-center gap-x-5">
	  			<img class="hidden md:block max-w-[14rem] min-w-[8rem]" src="${cpath}/resources/images/auth_fox.png" alt="Fox Character" />
	  			<div class="flex min-w-[22rem] max-w-[56.063rem] grow bg-white rounded-3xl shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
	  				<div class="relative hidden xl:block w-[17.125rem] overflow-hidden">
		  				<img alt="Login Side Background" src="${cpath}/resources/images/login-side-bg.png" class="h-full max-w-[274px]"/>
		  				<a href="/" class="absolute top-10 end-1/2 translate-x-1/2">
		  					<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" width="178" />
						</a>
		  			</div>
		  			<div class="flex flex-col min-w-[22rem] grow items-center justify-center p-4">
	  				<div class="text-ts-24 mb-4">회원가입</div>
		  				<div id="registerForm" class="w-full flex flex-col mb-4">
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">이메일</span>
		  						<div class="w-full flex items-center gap-x-2 mb-2">
		  							<input type="email" id="email" name="email" class="grow px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="사용자 ID(Email)" required>
		  							<button id="verifyEmailbtn" class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">중복검사</button>
		  							<input id="verifyEmail" type="checkbox" class="w-0 h-0" >
		  						</div>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">비밀번호</span>
		  						<input type="password" id="password" name="password" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="비밀번호" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">비밀번호 확인</span>
		  						<input type="password" id="passwordCheck" name="passwordCheck" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="비밀번호 확인" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">이름</span>
		  						<input type="text" id="name" name="name" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="이름" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">닉네임</span>
		  						<div class="w-full flex items-center gap-x-2 mb-2">
		  							<input type="text" id="nickname" name="nickname" class="grow px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="닉네임" required>
		  							<button id="verifyNicknamebtn" class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">중복검사</button>
		  							<input id="verifyNickname" type="checkbox" class="w-0 h-0" >
		  						</div>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">생년월일</span>
		  						<input type="date" id="birthDate" name="birthDate" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="생년월일" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">전화번호</span>
		  						<input type="text" id="phoneNumber" name="phoneNumber" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="전화번호(010-0000-0000)" required>
		  					</div>
		  					<div class="flex items-center justify-between px-2">
			  					<span id="errorMessage" class="text-xs h-5 text-red-600 text-base"></span>
			  					<div id="fakeCheckBox" class="flex items-center justify-end mb-2 gap-x-2 text-gray-6">
			  						<div id="fakeCheckIcon" class="w-4 h-4 border border-gray-6 rounded-full flex items-center justify-center">&#x2713;</div>
			  						<span>개인정보 수집 및 이용 동의</span>
			  						<input id="agreePrivacy" type="checkbox" class="w-0 h-0" >
			  					</div>
		  					</div>
		  					<button id="registerSubmit" type="submit" class="w-full py-2 outline-none bg-blue-2 rounded-full border border-blue-2 text-white text-md hover:bg-blue-1">회원가입</button>
		  				</div>
		  			</div>
	  			</div>
	  			<img class="hidden md:block max-w-[14rem] min-w-[8rem]" src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" />  			
	  		</div>
	  	</div>
	  	<script type="text/javascript">
	  		/* 개인정보 수집 및 이용 동의 스타일 이벤트 JS */
		  	const realCheckBox = document.getElementById('agreePrivacy');
		  	const fakeCheckIcon = document.getElementById('fakeCheckIcon');
		    const fakeCheckBox = document.getElementById('fakeCheckBox');
		    
		    document.getElementById('fakeCheckBox').addEventListener('click', function () {
		    	realCheckBox.checked = !realCheckBox.checked;
		    	
		    	if (realCheckBox.checked) {
		    		fakeCheckBox.classList.remove("text-gray-6");
		    		fakeCheckBox.classList.add("text-blue-1");
		    		fakeCheckIcon.classList.remove("border-gray-6");
		    		fakeCheckIcon.classList.add("border-blue-1");
		    		fakeCheckIcon.classList.add("bg-blue-1");
		    		fakeCheckIcon.classList.add("text-white");
		    	} else {
		    		fakeCheckBox.classList.remove("text-blue-1");
		    		fakeCheckBox.classList.add("text-gray-6");
		    		fakeCheckIcon.classList.remove("border-blue-1");
		    		fakeCheckIcon.classList.remove("bg-blue-1");
		    		fakeCheckIcon.classList.remove("text-white");
		    		fakeCheckIcon.classList.add("border-gray-6");
		    	}
		    });
		    
		    /* 이메일 중복 확인 이벤트 */
		    document.getElementById('verifyEmailbtn').addEventListener('click', function (e) {
		    	const error = document.getElementById('errorMessage');
			    error.textContent = "";
			    
		    	const email = document.getElementById('email');
		    	const verifyEmail = document.getElementById('verifyEmail');
				
		    	const emailCheck = false;
		    	
		    	if (!emailCheck) {
		    		email.classList.remove("border-gray-5");
		    		email.classList.add("border-red-600");
		    		
		    		error.textContent = "이미 사용 중인 이메일입니다.";
		    		
		        	return;
		    	} else {
		    		verifyEmail.checked = true;
		    		email.classList.remove("border-red-600");
		    		email.classList.add("border-gray-5");
		    		return;
		    	};
		    });
		    
		    /* 닉네임 중복 확인 이벤트 */
		    document.getElementById('verifyNicknamebtn').addEventListener('click', function (e) {
		    	const error = document.getElementById('errorMessage');
			    error.textContent = "";
			    
		    	const nickname = document.getElementById('nickname');
		    	const verifyNickname = document.getElementById('verifyNickname');
				
		    	const nicknameCheck = false;
		    	
		    	if (!nicknameCheck) {
		    		nickname.classList.remove("border-gray-5");
		    		nickname.classList.add("border-red-600");
		    		
		    		error.textContent = "이미 사용 중인 닉네임입니다.";
		        	
		    		return;
		    	} else {
		    		verifyNickname.checked = true;
		    		nickname.classList.remove("border-red-600");
		    		nickname.classList.add("border-gray-5");
		    		return;
		    	};
		    });
	  	</script>
	</jsp:attribute>
</ui:layout>