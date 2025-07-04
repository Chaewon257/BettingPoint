<%@ tag language="java" pageEncoding="UTF-8"%>

<div class="w-full flex flex-col justify-between">
	<div class="text-bold text-lg mb-4">비밀번호 찾기</div>
	<div class="w-full mb-4">
		<div class="w-full flex items-center gap-x-2 mb-2">
			<input type="email" id="findemail" name="findemail" class="grow px-10 py-4 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="사용자 ID(Email)" required>
			<button id="requestVerificationBtn" class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">인증번호요청</button>
		</div>
		<div class="w-full flex items-center gap-x-2 mb-2">
			<input type="text" id="verificationCodeInput" name="verificationCodeInput" class="grow px-10 py-4 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="인증번호 입력" required>
			<button id="verifyCodeBtn" class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">인증번호확인</button>
		</div>
		<input id="emailVerified" type="checkbox" class="absolute w-0 h-0">
	</div>
	<span id="errorMessage" class="grow text-xs h-5 text-red-600 pl-2"></span>
	<button id="findIdSubmit" class="w-full px-10 py-3 outline-none bg-blue-3 rounded-full text-white text-lg hover:bg-blue-1">비밀번호 찾기</button>
</div>
<script type="text/javascript">
	/* 이메일 인증번호 요청 */
	document.getElementById('requestVerificationBtn').addEventListener('click', function () {
		const emailInput = document.getElementById('findemail');
		const emailVal = emailInput.value.trim();
		const error = document.getElementById('errorMessage');
	
		if (!emailVal) {
			error.textContent = "이메일을 입력해주세요.";
			emailInput.classList.add("border-red-600");
			return;
		} else {
			emailInput.classList.remove("border-red-600");
			emailInput.classList.add("border-gray-5");
		}
	
		$.ajax({
			url: '/api/email/request',
			type: 'POST',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({ email: emailVal }),
			success: function (res) {
				alert(res); // "인증번호가 이메일로 발송되었습니다." 표시
			},
			error: function () {
				error.textContent = "인증번호 요청 중 오류가 발생했습니다.";
			}
		});
	});
	
	/* 이메일 인증번호 확인 */
	document.getElementById('verifyCodeBtn').addEventListener('click', function () {
		const emailInput = document.getElementById('email');
		const codeInput = document.getElementById('verificationCodeInput');
		const emailVerified = document.getElementById('emailVerified');
		const error = document.getElementById('errorMessage');
	
		const emailVal = emailInput.value.trim();
		const codeVal = codeInput.value.trim();
	
		if (!codeVal) {
			error.textContent = "인증번호를 입력해주세요.";
			codeInput.classList.add("border-red-600");
			return;
		} else {
			codeInput.classList.remove("border-red-600");
			codeInput.classList.add("border-gray-5");
		}
	
		$.ajax({
			url: '/api/email/verify',
			type: 'POST',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({ email: emailVal, code: codeVal }),
			success: function (res) {
				alert(res); // "이메일 인증이 완료되었습니다."
				emailVerified.checked = true;
			},
			error: function () {
				error.textContent = "인증번호 확인 중 오류가 발생했습니다.";
			}
		});
	});
	
	document.getElementById('findIdSubmit').addEventListener('click', function (e) {
		e.preventDefault();
		const error = document.getElementById('errorMessage');
		error.textContent = "";
		
		const emailVerified = document.getElementById('emailVerified');
		
		if (!emailVerified.checked) {
			error.textContent = "이메일 인증을 완료해야 합니다.";
			return;
		}
		
		console.log("이메일 인증 여부: ", emailVerified.checked);
	});
</script>