<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃 헤더"%>

<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<script type="text/javascript">
$(document).ready(function () {
	const token = localStorage.getItem('accessToken');
	if (!token) return;

	function getUserInfo(accessToken) {
		return $.ajax({
			url: '/api/user/me',
			method: 'GET',
			headers: {
				'Authorization': 'Bearer ' + accessToken
			},
			xhrFields: { withCredentials: true }
		});
	}

	function reissueToken(oldAccessToken) {
		return $.ajax({
			url: '/api/auth/reissue',
			method: 'POST',
			headers: {
				'Authorization': 'Bearer ' + oldAccessToken
			},
			xhrFields: { withCredentials: true }
		});
	}

	getUserInfo(token)
		.done(function (user) {
			renderUser(user);
		})
		.fail(function (xhr) {
			if (xhr.status === 401) {
				// accessToken 만료 → refreshToken으로 재발급
				reissueToken(token)
					.done(function (data) {
						localStorage.setItem('accessToken', data.accessToken);
						// 새 토큰으로 다시 사용자 정보 요청
						getUserInfo(data.accessToken)
							.done(function (user) {
								renderUser(user);
							})
							.fail(function () {
								console.warn('재시도 실패');
							});
					})
					.fail(function () {
						console.warn('토큰 재발급 실패');
					});
			} else {
				console.warn('기타 오류', xhr);
			}
		});

	function renderUser(user) {
		console.log(user);
		if (!user || !user.username) return;
		const html = `
			<a href="/mypage" class="text-black no-underline cursor-pointer hover:font-semibold">\${user.username} 님</a>
			<a href="/logout" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">로그아웃</a>
		`;
		$('#userMenu').html(html);
	}
});

</script>
<c:choose>
	<c:when test="${pageType ne 'ingame'}">
		<header class="bg-white shadow-[0_2px_10px_rgba(0,0,0,0.1)]">
			<div class="relative w-full bg-white text-center py-3.5 border border-gray-1 flex site-title-box">
				<span class="grow text-ts-28">Betting Point</span>
				<div class="absolute right-[1.438rem] top-0 h-full flex justify-center items-center gap-x-6" id="userMenu">
					<a href="/signup" class="text-black no-underline cursor-pointer hover:font-semibold">회원가입</a>
					<a href="/login" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">로그인</a>
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
							<a href="/solo" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">개인게임</a>
							<a href="/team" class="no-underline text-black text-base transition-colors duration-300 hover:text-blue-1 hover:font-semibold">단체게임</a>
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