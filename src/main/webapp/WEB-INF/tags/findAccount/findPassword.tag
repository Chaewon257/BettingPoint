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
	if (typeof verificationRequested === "undefined") {
		let verificationRequested = false;
	}

	/* 이메일 입력 시 버튼 및 상태 초기화 */
	document.getElementById('findemail').addEventListener('input', function () {
		const requestBtn = document.getElementById('requestVerificationBtn');
		verificationRequested = false;
		requestBtn.disabled = false;
	});

	/* 이메일 인증번호 요청 */
	document.getElementById('requestVerificationBtn').addEventListener('click', function () {
		const emailInput = document.getElementById('findemail');
		const emailVal = emailInput.value.trim();
		const error = document.getElementById('errorMessage');
		const requestBtn = document.getElementById('requestVerificationBtn');

		if (!emailVal) {
			error.textContent = "이메일을 입력해주세요.";
			emailInput.classList.add("border-red-600");
			return;
		} else {
			error.textContent = "";
			emailInput.classList.remove("border-red-600");
			emailInput.classList.add("border-gray-5");
		}

		// 이미 요청된 상태면 중복 요청 방지
		if (verificationRequested) {
			error.textContent = "이미 인증번호가 요청되었습니다. 이메일을 수정 후 다시 시도하세요.";
			return;
		}

		requestBtn.disabled = true; // 클릭 시 즉시 비활성화

		$.ajax({
			url: '/api/email/find/request',
			type: 'POST',
			contentType: 'application/json; charset=utf-8',
			data: JSON.stringify({ email: emailVal }),
			success: function (res) {
				alert(res); // "인증번호가 이메일로 발송되었습니다." 표시
				verificationRequested = true; // 요청 완료 상태로 변경
			},
			error: function (xhr) {
				error.textContent = xhr.responseJSON?.message || "인증번호 요청 중 오류가 발생했습니다.";
				requestBtn.disabled = false; // 오류 시 다시 활성화
			}
		});
	});

	/* 이메일 인증번호 확인 */
	document.getElementById('verifyCodeBtn').addEventListener('click', function () {
		const emailInput = document.getElementById('findemail');
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
			error.textContent = "";
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

				// 인증 완료 시 이메일/버튼/인증입력 비활성화
				emailInput.disabled = true;
				document.getElementById('requestVerificationBtn').disabled = true;
				codeInput.disabled = true;
				document.getElementById('verifyCodeBtn').disabled = true;
			},
			error: function () {
				error.textContent = "인증번호 확인 중 오류가 발생했습니다.";
			}
		});
	});

	/* 비밀번호 찾기 */
	document.getElementById('findIdSubmit').addEventListener('click', function (e) {
		e.preventDefault();
		const error = document.getElementById('errorMessage');
		error.textContent = "";

		const emailVerified = document.getElementById('emailVerified');
		const emailInput = document.getElementById('findemail');

		if (!emailVerified.checked) {
			error.textContent = "이메일 인증을 완료해야 합니다.";
			return;
		}

		$.ajax({
			type: 'POST',
			url: '/api/email/password',
			data: JSON.stringify({ email: emailInput.value }),
			contentType: 'application/json',
			success: function (response) {
				alert(response); // "임시 비밀번호가 이메일로 발송되었습니다."
			},
			error: function (xhr) {
				console.error(xhr);
				error.textContent = "임시 비밀번호 발급 요청 중 오류가 발생했습니다.";
			}
		});
	});
</script>