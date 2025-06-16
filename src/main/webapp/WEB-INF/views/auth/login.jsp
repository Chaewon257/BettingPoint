<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Poing 로그인" pageType="lobby">
	<jsp:attribute name="bodyContent">
	  	<div class="login-content">
	  		<div class="content-layout">
	  			<img class="auth-character" src="${cpath}/resources/images/auth_fox.png" alt="Fox Character" width="220" />
	  			<div class="login-box">
		  			<div class="login-box-side">
		  				<img alt="Login Side Background" src="${cpath}/resources/images/login-side-bg.png" width="274"/>
		  				<a href="/">
		  					<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" width="178" />
						</a>
		  			</div>
	  			</div>
	  			<img class="auth-character" src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" width="220" />	  			
	  		</div>
	  	</div>
	</jsp:attribute>
</ui:layout>