<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<link rel="icon" href="https://static.toss.im/icons/png/4x/icon-toss-logo.png" />
<script src="https://js.tosspayments.com/v2/standard"></script>
<div data-content="info" class="tab-content w-full flex flex-col gap-y-8 my-4">
	<div class="w-full flex flex-col gap-y-5 md:flex-row md:gap-x-5 lg:gap-x-10 rounded-lg bg-gray-10 p-4 sm:p-6 md:p-8 lg:p-10">
		<div class="flex flex-col gap-x-4 items-center md:col-span-2 gap-y-5 lg:gap-y-10">
			<div class="w-full sm:w-64 md:w-72 lg:w-80 aspect-square rounded-full bg-white flex justify-center overflow-hidden">
				<img id="profileImage" alt="default profile image" src="/resources/images/profile_default_image.png">
			</div>
			<div class="grow w-full flex items-center">
				<div class="w-full flex flex-col items-center gap-y-2 rounded-xl bg-blue-4 p-4 font-extrabold text-xl lg:text-3xl">
					<div class="w-full flex items-center justify-between text-gray-6">
						<img alt="money box" src="${cpath}/resources/images/money_box.png" class="w-7 lg:w-12">
						<div id="pointBalance" class="grow text-center">00000</div>
						<div>P</div>
					</div>
					<div class="w-full h-px bg-gray-1"></div>
					<button class="grow w-full rounded lg:rounded-xl text-gray-6 hover:text-white hover:bg-blue-3" 
							onclick="document.getElementById('chargePointModal').classList.remove('hidden')">충전하기</button>
				</div>
			</div>
		</div>
		<div class="grow flex flex-col justify-between gap-y-4">
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">이메일</span>
				<input type="email" id="email" name="email" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="이메일" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">비밀번호</span>
				<input type="password" id="password" name="password" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="비밀번호" required>
			</div>
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">비밀번호 확인</span>
				<input type="password" id="passwordCheck" name="passwordCheck" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="비밀번호 확인" required>
			</div>
			<div class="flex flex-col items-start gap-y-1">
				<span class="text-xs text-gray-6 pl-1">이름</span>
				<input type="text" id="name" name="name" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="이름" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">닉네임</span>
				<input type="text" id="nickname" name="nickname" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="닉네임" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
				<span class="text-xs text-gray-6 pl-1">생년월일</span>
				<input type="date" id="birthDate" name="birthDate" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="생년월일" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
				<span class="text-xs text-gray-6 pl-1">전화번호</span>
 				<input type="text" id="phoneNumber" name="phoneNumber" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="전화번호(010-0000-0000)" required>
			</div>
		</div>				
	</div>
	<div class="w-full flex flex-col items-end">
		<button class="h-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-full md:w-60 py-2">수정하기</button>
	</div>
</div>

<ui:modal modalId="chargePointModal" title="포인트 결제창">
	<jsp:attribute name="content">
		<!-- 주문서 영역 -->
		<div id="modalContainer" class="overflow-y-scroll grid md:grid-cols-4 mx-auto">
			<div class="bg-gray-4 p-4 flex flex-col justify-between">
				<div class="w-full">
					<div class="text-bold text-lg mb-2">충전 포인트</div>
					<input type="number" id="point" name="point" class="w-full px-2 md:px-4 py-1 md:py-2.5 text-xs outline-none bg-white rounded-full border border-gray-9 mb-4" placeholder="충전할 포인트를 입력해주세요" required>
					<div class="w-full flex flex-row items-center justify-center md:flex-col gap-2 mb-8">
						<button data-value="1000" class="point-btn w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold py-2">
							1,000 P
						</button>
						<button data-value="5000" class="point-btn w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold py-2">
							5,000 P
						</button>
						<button data-value="10000" class="point-btn w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold py-2">
							10,000 P
						</button>
						<button data-value="50000" class="point-btn w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold py-2">
							50,000 P
						</button>
						<button data-value="100000" class="point-btn w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold py-2">
							100,000 P
						</button>
					</div>
				</div>
				<div class="w-full flex flex-col">
					<div class="text-bold text-lg mb-2">결제금액</div>
					<div class="flex justify-end gap-2">
						<div id="amountDisplay" class="font-extrabold text-2xl text-red-600"></div>
						<div class="font-extrabold text-2xl">원</div>
					</div>
				</div>
			</div>
			<!-- 첫 번째 결제 위젯 영역 -->
			<div class="md:col-span-3 bg-white rounded-[10px] pb-[20px] text-center">
		    	<!-- 결제 UI -->
		    	<div id="payment-method"></div>
			    <!-- 이용약관 UI -->
			    <div id="agreement"></div>		    
			    <!-- 결제하기 버튼 -->
			    <button id="payment-button"
						class="mt-[20px] mx-[15px] px-4 py-3 w-[250px] text-white bg-blue-500 font-semibold text-[15px] rounded hover:bg-blue-700 transition">
			      결제하기
			    </button>
		  	</div>
		</div>
		<script src="${cpath}/resources/js/chargemodal.js"></script>
	</jsp:attribute>
</ui:modal>


<script type="text/javascript">
	$(document).ready(function () {
		const token = localStorage.getItem('accessToken');
		
		if (!token) {
	        alert("로그인이 필요합니다.");
	        window.location.href = "/"
	        return;
	    }
	
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
			.done(renderUserInfo)
			.fail(function (xhr) {
				if (xhr.status === 401) {
					// 401일 경우, GlobalExceptionHandler에서 보낸 에러 메시지를 확인
					const error = xhr.responseJSON?.error || "";
					const message = xhr.responseJSON?.message || "로그인이 필요합니다.";
						
					console.warn(`[${error}] ${message}`);
						
					if (error === "SESSION_EXPIRED" || error === "INVALID_TOKEN") {
						// 재발급 시도
						reissueToken(token)
							.done(function (data) {
							localStorage.setItem('accessToken', data.accessToken);
							// 재요청
							getUserInfo(data.accessToken)
								.done(renderUserInfo)
								.fail(function () {
								alert("다시 로그인해주세요.");
								window.location.href = "/";
							});
						})
						.fail(function () {
							alert("세션이 만료되었습니다. 다시 로그인해주세요.");
							localStorage.removeItem('accessToken');
							window.location.href = "/";
						});
					} else {
						alert(message);
						window.location.href = "/";
					}
				} else {
						alert("사용자 정보를 불러오는 데 실패했습니다.");
						window.location.href = "/";
				}
			});
	
		function renderUserInfo(user) {
			if (!user) return;
			
			const birthDate = new Date(user.birth_date);

			// yyyy-MM-dd 포맷으로 변환
			const yyyy = birthDate.getFullYear();
			const mm = String(birthDate.getMonth() + 1).padStart(2, '0');
			const dd = String(birthDate.getDate()).padStart(2, '0');
			const formattedDate = `\${yyyy}-\${mm}-\${dd}`;
			
			$("#email").val(user.email);
            $("#name").val(user.user_name);
            $("#nickname").val(user.nickname);
            $("#birthDate").val(formattedDate);
            $("#phoneNumber").val(user.phone_number);
            $("#pointBalance").text(user.point_balance || "0");
            $("#profileImage").attr("src", user.profile_img || "/resources/images/profile_default_image.png");
		}
		
		// 화면 너비 계산
		function adjustWidth() {
		    let screenWidth = $(window).width();
		    let newWidth;

		    if (screenWidth >= 1280) {
		        newWidth = screenWidth * 0.7;
		    } else if (screenWidth >= 1024) {
		        newWidth = screenWidth * 0.8;
		    } else if (screenWidth >= 768) {
		        newWidth = screenWidth * 0.9;
		    } else {
		        newWidth = screenWidth - 32;
		    }

		    $("#modalContainer").css("width", `\${newWidth}px`);
		}

		// 처음 실행
		adjustWidth();

		// 리사이즈 시 다시 적용
		$(window).resize(function() {
		    adjustWidth();
		});
		
		// 포인트 값 업데이트 함수
	    function updateAmountDisplay() {
	        let point = parseInt($("#point").val().replace(/,/g, "")) || 0;
	        let payment = Math.floor(point * 1.1);
	        
	        $("#amountDisplay").text(payment.toLocaleString());
	    }

	    // input 변경 시
	    $("#point").on("input", function () {
	        updateAmountDisplay();
	    });

	    // 버튼 클릭 시
	    $(".point-btn").click(function () {
	        const addPoint = parseInt($(this).data("value"));
	        let currentPoint = parseInt($("#point").val().replace(/,/g, "")) || 0;
	        let newPoint = currentPoint + addPoint;
	        $("#point").val(newPoint);
	        updateAmountDisplay();
	    });
	});
</script>