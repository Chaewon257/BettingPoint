<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃 헤더"%>

<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<c:choose>
	<c:when test="${pageType ne 'ingame'}">
		<header class="bg-white shadow-[0_2px_10px_rgba(0,0,0,0.1)]">
			<div class="relative w-full bg-white text-center py-2.5 border border-gray-1 flex items-center site-title-box">
			  <!-- 사이트 제목 -->
			  <span class="grow text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">Betting Point</span>
			
			  <!-- 로그인/회원가입 or 로그아웃 (PC에서만 보임) -->
			  <div class="hidden absolute right-5 top-1/2 -translate-y-1/2 md:flex md:justify-center md:items-center md:gap-x-6">
			    <c:choose>
			      <c:when test="${not empty sessionScope.loginUser}">
			        <a href="/signup" class="text-black no-underline cursor-pointer hover:font-semibold">${sessionScope.loginUser.username} 님</a>
			        <a href="/" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">로그아웃</a>
			      </c:when>
			      <c:otherwise>
			        <a href="/signup" class="text-black no-underline cursor-pointer hover:font-semibold">회원가입</a>
			        <a href="/login" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">로그인</a>
			      </c:otherwise>
			    </c:choose>
			  </div>
			</div>
			
			<c:if test="${pageType eq 'main'}">
				<div class="bg-white transition-all duration-300 ease-in-out z-[999] shadow-none nav-bar">
					<div class="flex justify-center items-center py-8 pl-80 pr-24">
						<div class="absolute left-24">
							<a href="/">
								<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" class="h-16"/>
							</a>
						</div>
						<nav class="grow flex justify-between items-center">
							<a href="/cointoss" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">개인게임</a>
							<a href="/gameroom" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">단체게임</a>
							<a href="/board" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">게시판</a>
							<a href="/support" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">고객지원</a>
							<a href="/mypage" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">마이페이지</a>
						</nav>
					</div>
				</div>
			</c:if>
		</header>
	</c:when>
</c:choose>