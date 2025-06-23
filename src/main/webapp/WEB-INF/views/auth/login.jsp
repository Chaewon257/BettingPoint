<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Poing 로그인" pageType="lobby">
	<jsp:attribute name="bodyContent">
	  	<div class="grow flex items-center justify-center w-full">
	  		<div class="w-full h-[32.813rem] flex items-end justify-center gap-x-2.5">
	  			<img class="w-[14rem] max-1350:w-[12.5rem] max-1300:w-[11.25rem] max-1250:w-[9.375rem] max-1200:hidden" src="${cpath}/resources/images/auth_fox.png" alt="Fox Character" />
	  			<div class="h-full min-w-[56.063rem] bg-white rounded-3xl shadow-[2px_2px_8px_rgba(0,0,0,0.15)] flex">
		  			<div class="relative w-[17.125rem] overflow-hidden">
		  				<img alt="Login Side Background" src="${cpath}/resources/images/login-side-bg.png" width="274"/>
		  				<a href="/" class="absolute top-12 left-12">
		  					<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" width="178" />
						</a>
		  			</div>
		  			<div class="grow px-[3.75rem] pt-12 flex flex-col">
		  				<form id="loginForm" class=" flex flex-col justify-items-start mb-4">
		  					<span class="text-ts-28 pl-1.5 mb-16">로그인</span>
		  					<input type="email" id="email" name="userid" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="사용자 ID" required>
		  					<input type="password" id="password" name="userpw" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5 mb-4" placeholder="비밀번호" required>
		  					<button type="submit" class="w-full px-10 py-3 outline-none bg-blue-2 rounded-full border border-blue-2 text-white text-lg hover:bg-blue-1">로그인</button>
		  				</form>
		  				<div class="flex gap-x-8 text-gray-3 justify-end px-4 mb-8">
		  					<a href="/register" class="hover:text-gray-6">회원가입</a>
		  					|
		  					<a href="/" class="hover:text-gray-6">ID/PW찾기</a>
		  				</div>
		  				<div class="w-full text-center text-red-600 text-base">
		  					${errorMessage}
		  				</div>
		  			</div>
	  			</div>
	  			<img class="w-[14rem] max-1350:w-[12.5rem] max-1300:w-[11.25rem] max-1250:w-[9.375rem] max-1200:hidden" src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" width="220" />	  			
	  		</div>
	  	</div>
	  	<script src="${cpath}/resources/js/login.js"></script>
	</jsp:attribute>
</ui:layout>