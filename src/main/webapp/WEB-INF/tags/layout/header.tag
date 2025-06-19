<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃 헤더"%>

<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<c:choose>
	<c:when test="${pageType ne 'ingame'}">
		<header class="bg-white shadow-[0_2px_10px_rgba(0,0,0,0.1)]">
			<div class="relative w-full bg-white py-1 md:py-2.5 border border-gray-1 flex items-center justify-center site-title-box">
			  <!-- 사이트 제목 -->
			  <span class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">Betting Point</span>
			
			  <!-- 로그인/회원가입 or 로그아웃 (PC에서만 보임) -->
			  <div class="hidden md:flex md:items-center md:gap-x-6 absolute right-5 top-1/2 -translate-y-1/2 ">
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
				<div class="bg-white transition-all duration-300 ease-in-out z-[999] nav-bar">
					<div class="relative flex justify-center items-center py-1 md:py-7 md:pl-44 md:pr-16 lg:pl-60 lg:pr-24">
						<div class="md:absolute md:left-12">
							<a href="/">
								<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" class="h-12 md:h-16"/>
							</a>
						</div>
						<button id="hamburgerButton" class="absolute left-6 top-1/2 -translate-y-1/2 text-2xl md:hidden">
							&#9776; <!-- ☰ -->
						</button>
						<nav id="mobileMenu" class="hidden absolute top-full right-0 flex flex-col z-40 w-full py-6 gap-y-8 items-center bg-white shadow-md md:static md:py-0 md:gap-y-auto md:grow md:flex md:flex-row md:justify-between md:shadow-none">
							<a href="/cointoss" class="text-black text-base hover:text-blue-1 hover:font-semibold">개인게임</a>
							<a href="/gameroom" class="text-black text-base hover:text-blue-1 hover:font-semibold">단체게임</a>
							<a href="/board" class="text-black text-base hover:text-blue-1 hover:font-semibold">게시판</a>
							<a href="/support" class="text-black text-base hover:text-blue-1 hover:font-semibold">고객지원</a>
							<a href="/mypage" class="text-black text-base hover:text-blue-1 hover:font-semibold">마이페이지</a>
						</nav>
					</div>
				</div>
				<script type="text/javascript">
					document.addEventListener("DOMContentLoaded", function () {
					  const button = document.getElementById("hamburgerButton");
					  const mobileMenu = document.getElementById("mobileMenu");

					  if (button && mobileMenu) {
					    button.addEventListener("click", () => {
					      mobileMenu.classList.toggle("hidden");
					    });
					  }
					});
				</script>
			</c:if>
		</header>
	</c:when>
</c:choose>