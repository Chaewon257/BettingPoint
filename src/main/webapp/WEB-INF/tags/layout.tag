<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃"%>

<%@ attribute name="pageName" required="true"%>
<%@ attribute name="bodyContent" fragment="true"%>
<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<html>
<head>
<meta charset="UTF-8">
<title>${pageName}</title>
<link rel="stylesheet" href="${cpath}/resources/css/styles.css">
<script src="https://cdn.tailwindcss.com"></script>
<script type="text/javascript">
	tailwind.config = {
		theme : {
			extend : {
				colors : {
					'gray-1' : '#D8D8D8',
					'gray-2' : '#E7E5E4',
					'gray-3' : '#828688',
					'gray-4' : '#F7F7F7',
					'gray-5' : '#D4D4D4',
					'blue-1' : '#4A90E2',
				},
				screens : {
					'max-1350': { 'max': '1350px' },
					'max-1300': { 'max': '1300px' },
					'max-1250': { 'max': '1250px' },
					'max-1200': { 'max': '1200px' },
				}
			}
		}
	}
</script>
</head>
<body>
	<c:choose>
		<c:when test="${pageType ne 'ingame'}">
			<header class="header">
				<div class="site-title-box">
					<span>Betting Point</span>
					<div>
						<c:choose>
							<c:when test="${not empty sessionScope.loginUser}">
								<a href="/signup" class="site-title-signup">${sessionScope.loginUser.username} 님</a>
								<a href="/" class="site-title-login">로그아웃</a>
							</c:when>
							<c:otherwise>
								<a href="/signup" class="site-title-signup">회원가입</a>
								<a href="${cpath}/login" class="site-title-login">로그인</a>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<c:if test="${pageType eq 'main'}">
					<div class="nav-bar">
						<div class="container">
							<div class="logo">
								<a href="/game/"> <img
									src="${cpath}/resources/images/logo.png"
									alt="Betting Point Logo" height="40" />
								</a>
							</div>
							<nav class="nav">
								<a href="/game/solo" class="nav-item">개인게임</a>
								<a href="/game/team" class="nav-item">단체게임</a>
								<a href="/board" class="nav-item">게시판</a>
								<a href="/support" class="nav-item">고객지원</a>
								<a href="/mypage" class="nav-item">마이페이지</a>
							</nav>
						</div>
					</div>
				</c:if>
			</header>
		</c:when>
	</c:choose>
	
	<main class="container">
		<jsp:invoke fragment="bodyContent" />
	</main>
	
	<c:choose>
		<c:when test="${pageType eq 'main'}">
			<footer class="footer">
				<div class="container">
					<p>&copy; 2025 Betting Point. All rights reserved.</p>
				</div>
			</footer>
			<script src="${cpath}/resources/js/layout.js"></script>
		</c:when>
	</c:choose>
</body>
</html>
