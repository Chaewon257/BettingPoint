<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃 헤더"%>

<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<script type="text/javascript">
	$(document).ready(function () {
		let token = localStorage.getItem('accessToken');

		// 유저 정보 렌더링
		function renderUser(user) {
			if (!user || !user.user_name) return;

			// PC
			$('#userMenu').html(`
				<a href="/mypage" class="text-black hover:font-semibold">\${user.user_name} 님</a>
				<a href="#" onclick="logout();" class="text-black py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">로그아웃</a>
			`);

			// 모바일
			$('#userMobileMenu').html(`
				<span class="text-black"><a href="/mypage" class="underline font-semibold">\${user.user_name}</a> 님 환영합니다</span>
			`);
		}

		// 유저 정보 요청
		function getUserInfo() {
			return $.ajax({
				url: '/api/user/me',
				method: 'GET',
				xhrFields: { withCredentials: true }
			});
		}

		// 페이지 진입 시 유저 정보 로딩
		if (token) {
			getUserInfo()
				.done(renderUser)
				.fail(xhr => {
					console.warn('⚠️ 사용자 정보 요청 실패', xhr);
					if (xhr.status === 401) {
						localStorage.removeItem("accessToken");
					}
				});
		}

		// 보호된 경로 사전 정의
		const protectedRoutes = {
			"/solo": "개인게임",
			"/gameroom": "단체게임",
			"/mypage": "마이페이지"
		};

		// 보호된 링크 클릭 시 토큰 검사 및 이동
		$("a").on("click", function (e) {
			const target = $(this).attr("href");

			if (!protectedRoutes[target]) return;

			e.preventDefault();

			token = localStorage.getItem("accessToken");
			if (!token) {
				alert(`"\${protectedRoutes[target]}"은(는) 로그인 후 이용 가능합니다.`);
				return;
			}

			getUserInfo()
				.done(() => window.location.href = target)
				.fail(() => {
					alert("로그인이 만료되었습니다. 다시 로그인 해주세요.");
					localStorage.removeItem("accessToken");
				});
		});
	});
	function logout() {
		const token = localStorage.getItem("accessToken");
		$.ajax({
			url: "/api/auth/logout",
			method: "POST",
			headers: {
				"Authorization": "Bearer " + token
			}
		}).then(() => {
			localStorage.removeItem("accessToken");
			alert("로그아웃 되었습니다.");
			window.location.href = "/";
		});
	}
</script>
<c:choose>
	<c:when test="${pageType ne 'ingame'}">
		<header class="bg-white shadow-[0_2px_10px_rgba(0,0,0,0.1)]">
			<div
				class="relative w-full bg-white py-1 md:py-2.5 border border-gray-1 flex items-center justify-center site-title-box">
				<!-- 사이트 제목 -->
				<span class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">Betting
					Point</span>

				<!-- 로그인/회원가입 or 로그아웃 (PC에서만 보임) -->
				<div id="userMenu"
					class="hidden md:flex md:items-center md:gap-x-6 absolute right-5 top-1/2 -translate-y-1/2 ">
					<a href="/register"
						class="text-black no-underline cursor-pointer hover:font-semibold">회원가입</a>
					<a href="/login"
						class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">로그인</a>
				</div>
			</div>

			<c:if test="${pageType eq 'main'}">
				<div
					class="bg-white transition-all duration-300 ease-in-out z-[999] nav-bar">
					<div
						class="relative flex justify-center items-center py-1 md:py-7 md:pl-44 md:pr-16 lg:pl-60 lg:pr-24">
						<div class="md:absolute md:left-12">
							<a href="/"> <img src="${cpath}/resources/images/logo.png"
								alt="Betting Point Logo" class="h-12 md:h-16" />
							</a>
						</div>
						<button id="hamburgerButton"
							class="absolute left-6 top-1/2 -translate-y-1/2 text-2xl md:hidden">
							&#9776;
							<!-- ☰ -->
						</button>
						<nav id="mobileMenu"
							class="hidden absolute top-full right-0 flex flex-col z-40 w-full pb-6 gap-y-8 items-center bg-white shadow-md md:static md:py-0 md:gap-y-auto md:grow md:flex md:flex-row md:justify-between md:shadow-none">
							<div id="userMobileMenu"
								class="bg-gray-2 py-5 w-full flex items-center justify-center relative md:hidden">
								<a href="/login" class="text-black"><span
									class="underline font-semibold">로그인</span> 후 다양한 서비스를 이용해보세요</a>
							</div>

							<a href="/solo" class="text-black text-base hover:text-blue-1 hover:font-semibold">개인게임</a>
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