<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Poing 로그인" pageType="lobby">
	<jsp:attribute name="bodyContent">
	  	<div class="fixed top-0 left-0 flex items-center justify-center h-screen w-full">
	  		<div class="w-full h-[32.813rem] flex items-end justify-center gap-x-2.5">
	  			<img class="w-[14rem] max-1350:w-[12.5rem] max-1300:w-[11.25rem] max-1250:w-[9.375rem] max-1200:hidden" src="${cpath}/resources/images/auth_fox.png" alt="Fox Character" />
	  			<div class="h-full min-w-[56.063rem] bg-white rounded-3xl shadow-[2px_2px_8px_rgba(0,0,0,0.15)] flex">
		  			<div class="relative w-[17.125rem] overflow-hidden">
		  				<img alt="Login Side Background" src="${cpath}/resources/images/login-side-bg.png" width="274"/>
		  				<a href="/" class="absolute top-12 left-12">
		  					<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" width="178" />
						</a>
		  			</div>
	  				<div class="grow px-[3.75rem] pt-[6.75rem] flex flex-col justify-items-start">
	  					<form class="w-full" action="/login" method="post">
	  						<input type="password" name="userpw" class="w-full px-10 py-4 outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="비밀번호">
	  						
	  					</form>
	  				</div>
	  			</div>
	  			<img class="w-[14rem] max-1350:w-[12.5rem] max-1300:w-[11.25rem] max-1250:w-[9.375rem] max-1200:hidden" src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" width="220" />	  			
	  		</div>
	  	</div>
	</jsp:attribute>
</ui:layout>