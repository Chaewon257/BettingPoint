<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Poing 회원가입" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<div class="fixed top-0 left-0 flex items-center justify-center h-screen w-full px-10 md:px-0 pt-11 md:pt-16 lg:pt-20">
	  		<div class="w-full flex items-end justify-center gap-x-5">
	  			<img class="hidden md:block max-w-[14rem] min-w-[8rem]" src="${cpath}/resources/images/auth_fox.png" alt="Fox Character" />
	  			<div class="flex min-w-[22rem] max-w-[56.063rem] grow bg-white rounded-3xl shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
	  				<div class="relative hidden xl:block w-[17.125rem] overflow-hidden">
		  				<img alt="Login Side Background" src="${cpath}/resources/images/login-side-bg.png" class="h-full max-w-[274px]"/>
		  				<a href="/" class="absolute top-10 end-1/2 translate-x-1/2">
		  					<img src="${cpath}/resources/images/logo.png" alt="Betting Point Logo" width="178" />
						</a>
		  			</div>
		  			<div class="flex flex-col min-w-[22rem] grow items-center justify-center p-4">
	  				<div class="text-ts-24 mb-4">회원가입</div>
		  				<div id="registerForm" class="w-full flex flex-col mb-4">
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">이메일</span>
		  						<div class="w-full flex items-center gap-x-2 mb-2">
		  							<input type="email" id="email" name="email" class="grow px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="사용자 ID(Email)" required>
		  							<button id="verifyEmailbtn" class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">중복검사</button>
		  							<input id="verifyEmail" type="checkbox" class="w-0 h-0" >
		  						</div>
								<div class="w-full flex items-center gap-x-2 mb-2">
									<button id="requestVerificationBtn" type="button"
											class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">
										인증번호 요청
									</button>
								</div>
								<div id="verificationSection" class="w-full flex items-center gap-x-2 mb-2 hidden">
									<input type="text" id="verificationCodeInput"
										   class="grow px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5"
										   placeholder="인증번호 입력">
									<button id="verifyCodeBtn" type="button"
											class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">
										인증 확인
									</button>
									<input id="emailVerified" type="checkbox" class="w-0 h-0">
								</div>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">비밀번호</span>
		  						<input type="password" id="password" name="password" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="비밀번호" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">비밀번호 확인</span>
		  						<input type="password" id="passwordCheck" name="passwordCheck" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="비밀번호 확인" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">이름</span>
		  						<input type="text" id="name" name="name" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="이름" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">닉네임</span>
		  						<div class="w-full flex items-center gap-x-2 mb-2">
		  							<input type="text" id="nickname" name="nickname" class="grow px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="닉네임" required>
		  							<button id="verifyNicknamebtn" class="px-3 py-2 text-xs rounded-full border border-blue-3 bg-blue-3 text-white hover:border-blue-2 hover:bg-blue-1">중복검사</button>
		  							<input id="verifyNickname" type="checkbox" class="w-0 h-0" >
		  						</div>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">생년월일</span>
		  						<input type="date" id="birthDate" name="birthDate" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="생년월일" required>
		  					</div>
		  					<div class="flex flex-col items-start gap-y-1">
		  						<span class="text-xs text-gray-6 pl-1">전화번호</span>
		  						<input type="text" id="phoneNumber" name="phoneNumber" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 mb-2" placeholder="전화번호(010-0000-0000)" required>
		  					</div>
		  					<div class="flex items-center justify-end px-2 mb-2">
			  					<span id="errorMessage" class="grow text-xs h-5 text-red-600 text-base"></span>
			  					<div id="fakeCheckBox" class="flex items-center justify-end gap-x-2 text-gray-6">
			  						<div id="fakeCheckIcon" class="w-4 h-4 border border-gray-6 rounded-full flex items-center justify-center">&#x2713;</div>
			  						<span>개인정보 수집 및 이용 동의</span>
			  						<input id="agreePrivacy" type="checkbox" class="w-0 h-0" >
			  					</div>
			  					<button class="text-sm underline text-gray-6" onclick="document.getElementById('agreePrivacyInfoModal').classList.remove('hidden')">보기</button>
		  					</div>
		  					<button id="registerSubmit" type="submit" class="w-full py-2 outline-none bg-blue-2 rounded-full border border-blue-2 text-white text-md hover:bg-blue-1">회원가입</button>
		  				</div>
		  			</div>
	  			</div>
	  			<img class="hidden md:block max-w-[14rem] min-w-[8rem]" src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" />  			
	  		</div>
	  	</div>
	  	<ui:modal modalId="agreePrivacyInfoModal" title="개인정보 수집 및 이용 안내">
	  		<jsp:attribute name="content">
	  			<div class="max-h-[35rem] overflow-y-scroll max-w-[25rem] text-xs">
	  				개인정보보호법에 따라 베팅포인트에 회원가입 신청하시는 분께 수집하는 개인정보의 항목, 개인정보의 수집 및 이용목적, 개인정보의 보유 및 이용기간, 동의 거부권 및 동의 거부 시 불이익에 관한 사항을 안내 드리오니 자세히 읽은 후 동의하여 주시기 바랍니다.<br/>
				    <br/>
				    <span class="text-xl font-semibold">1. 수집하는 개인정보</span><br/>
				    <br/>
				    이용자는 회원가입을 하지 않아도 게시글 보기 등 대부분의 베팅포인트 서비스를 회원과 동일하게 이용할 수 있습니다. 이용자가 게임 등 개인화 혹은 회원제 서비스를 이용하기 위해 회원가입을 할 경우, 베팅포인트는 서비스 이용을 위해 필요한 최소한의 개인정보를 수집합니다.<br/>
				    <strong>회원가입 시점에 베팅포인트가 이용자로부터 수집하는 개인정보는 아래와 같습니다.</strong><br/>
				    <br/>
				    - 회원 가입 시 필수항목으로 이메일, 비밀번호, 이름, 생년월일, 휴대전화번호를 수집합니다.<br/>
				    <br/>
				    <strong>서비스 이용 과정에서 이용자로부터 수집하는 개인정보는 아래와 같습니다.</strong><br/>
				    - 서비스 이용 과정에서 IP 주소, 쿠키, 서비스 이용 기록, 기기정보가 생성되어 수집될 수 있습니다.<br/>
				    <br/>
				    <span class="text-xl font-semibold">2. 수집한 개인정보의 이용</span><br/>
				    <br/>
				    베팅포인트는 회원관리, 서비스 제공 및 향상, 안전한 인터넷 이용환경 구축 등 아래의 목적으로만 개인정보를 이용합니다.<br/>
				    - 회원 가입 의사 확인, 이용자 본인 확인, 이용자 식별, 회원탈퇴 의사의 확인 등 회원관리를 위하여 개인정보를 이용합니다.<br/>
				    - 콘텐츠 등 기존 서비스 제공(광고 포함), 신규 서비스 개발 및 맞춤 서비스 제공을 위하여 개인정보를 이용합니다.<br/>
				    - 법령 및 이용약관을 위반하는 회원에 대한 제재, 계정도용 및 부정거래 방지 등 서비스 운영을 위하여 개인정보를 이용합니다.<br/>
				    - 유료 서비스 제공에 따른 본인인증, 구매 및 요금 결제, 상품 및 서비스의 배송을 위하여 개인정보를 이용합니다.<br/>
				    <br/>
				    <span class="text-xl font-semibold">3. 개인정보 보관기간</span><br/>
				    <br/>
				    베팅포인트는 원칙적으로 이용자의 개인정보를 회원 탈퇴 시 지체없이 파기하고 있습니다. 단, 법령에서 일정 기간 정보보관 의무를 부과하는 경우에는 해당 기간 동안 개인정보를 안전하게 보관합니다.<br/>
				    - 계약 또는 청약철회 등에 관한 기록: 5년 보관<br/>
				    - 대금결제 및 재화 등의 공급에 관한 기록: 5년 보관<br/>
				    - 소비자의 불만 또는 분쟁처리에 관한 기록: 3년 보관<br/>
				    - 로그인 기록: 3개월 보관<br/>
				    <br/>
				    <span class="text-xl font-semibold">4. 개인정보 수집 및 이용 동의를 거부할 권리</span><br/>
				    <br/>
				    이용자는 개인정보의 수집 및 이용 동의를 거부할 권리가 있습니다. 회원가입 시 수집하는 필수 항목에 대한 수집 및 이용 동의를 거부하실 경우, 회원가입이 어려울 수 있습니다.
	  			</div>
	  		</jsp:attribute>
	  	</ui:modal>
	  	<script type="text/javascript">
	  		/* 개인정보 수집 및 이용 동의 스타일 이벤트 JS */
		  	const realCheckBox = document.getElementById('agreePrivacy');
		  	const fakeCheckIcon = document.getElementById('fakeCheckIcon');
		    const fakeCheckBox = document.getElementById('fakeCheckBox');
		    
		    document.getElementById('fakeCheckBox').addEventListener('click', function () {
		    	realCheckBox.checked = !realCheckBox.checked;
		    	
		    	if (realCheckBox.checked) {
		    		fakeCheckBox.classList.remove("text-gray-6");
		    		fakeCheckBox.classList.add("text-blue-1");
		    		fakeCheckIcon.classList.remove("border-gray-6");
		    		fakeCheckIcon.classList.add("border-blue-1");
		    		fakeCheckIcon.classList.add("bg-blue-1");
		    		fakeCheckIcon.classList.add("text-white");
		    	} else {
		    		fakeCheckBox.classList.remove("text-blue-1");
		    		fakeCheckBox.classList.add("text-gray-6");
		    		fakeCheckIcon.classList.remove("border-blue-1");
		    		fakeCheckIcon.classList.remove("bg-blue-1");
		    		fakeCheckIcon.classList.remove("text-white");
		    		fakeCheckIcon.classList.add("border-gray-6");
		    	}
		    });
		    
		    /* 이메일 중복 확인 이벤트 */
		   	document.getElementById('verifyEmailbtn').addEventListener('click', function (e) {
		        const error = document.getElementById('errorMessage');
		        error.textContent = "";

		        const email = document.getElementById('email');
		        const verifyEmail = document.getElementById('verifyEmail');

		        const emailVal = email.value.trim();

		        if (!emailVal) {
		            error.textContent = "이메일을 입력해주세요.";
		            email.classList.add("border-red-600");
		            return;
		        }

		        $.ajax({
		            url: '/api/auth/check-email',
		            method: 'GET',
		            data: { email: emailVal },
		            success: function (res) {
		                if (res.duplicate) {
		                    // 중복된 이메일
		                    email.classList.remove("border-gray-5");
		                    email.classList.add("border-red-600");
		                    error.textContent = "이미 사용 중인 이메일입니다.";
		                    verifyEmail.checked = false;
		                } else {
		                    // 사용 가능한 이메일
		                    email.classList.remove("border-red-600");
		                    email.classList.add("border-gray-5");
		                    verifyEmail.checked = true;
		                    alert("사용 가능한 이메일입니다.");
		                }
		            },
		            error: function () {
		                error.textContent = "이메일 확인 중 오류가 발생했습니다.";
		            }
		        });
		    });

			/* 이메일 인증번호 요청 */
			document.getElementById('requestVerificationBtn').addEventListener('click', function () {
				const emailInput = document.getElementById('email');
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
						document.getElementById('requestVerificationBtn').style.display = 'none';
						document.getElementById('verificationSection').classList.remove('hidden');
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
		    
		    /* 닉네임 중복 확인 이벤트 */
		    document.getElementById('verifyNicknamebtn').addEventListener('click', function (e) {
		        const error = document.getElementById('errorMessage');
		        error.textContent = "";

		        const nickname = document.getElementById('nickname');
		        const verifyNickname = document.getElementById('verifyNickname');

		        const nicknameVal = nickname.value.trim();

		        if (!nicknameVal) {
		            error.textContent = "닉네임을 입력해주세요.";
		            nickname.classList.add("border-red-600");
		            return;
		        }

		        $.ajax({
		            url: '/api/auth/check-nickname',
		            method: 'GET',
		            data: { nickname: nicknameVal },
		            success: function (res) {
		                if (res.duplicate) {
		                    // 중복된 닉네임
		                    nickname.classList.remove("border-gray-5");
		                    nickname.classList.add("border-red-600");
		                    error.textContent = "이미 사용 중인 닉네임입니다.";
		                    verifyNickname.checked = false;
		                } else {
		                    // 사용 가능한 닉네임
		                    nickname.classList.remove("border-red-600");
		                    nickname.classList.add("border-gray-5");
		                    verifyNickname.checked = true;
		                    alert("사용 가능한 닉네임입니다.");
		                }
		            },
		            error: function () {
		                error.textContent = "닉네임 확인 중 오류가 발생했습니다.";
		            }
		        });
		    });
		    
		    /* 회원가입 입력 유효성 검사 */
		    document.getElementById('registerSubmit').addEventListener('click', function (e) {
			    e.preventDefault();
			    const error = document.getElementById('errorMessage');
			    error.textContent = "";
		
			    const email = document.getElementById('email');
		    	const verifyEmail = document.getElementById('verifyEmail');
			    const password = document.getElementById('password');
			    const passwordCheck = document.getElementById('passwordCheck');
			    const name = document.getElementById('name');
			    const nickname = document.getElementById('nickname');
			    const verifyNickname = document.getElementById('verifyNickname');
			    const birthDate = document.getElementById('birthDate');
			    const birthDateVal = new Date(birthDate.value);
			    const phoneNumber = document.getElementById('phoneNumber');
			    const agreePrivacy = document.getElementById('agreePrivacy');
				const age = new Date().getFullYear() - birthDateVal.getFullYear();
				const emailVerified = document.getElementById('emailVerified');

				if (!emailVerified.checked) {
					error.textContent = "이메일 인증을 완료해야 합니다.";
					return;
				}

				if (!verifyEmail.checked) {
		        	error.textContent = "이메일 중복 검사를 해야합니다.";
		        	return;
		        }

				if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{6,}$/.test(password.value)) {
					password.classList.remove("border-gray-5");
					password.classList.add("border-red-600");
		    		
		        	error.textContent = "비밀번호는 6자 이상, 대소문자, 특수문자를 포함해야 합니다.";
		        	return;
		        } else {
		        	password.classList.remove("border-red-600");
		        	password.classList.add("border-gray-5");
		    	};
		
		        if (password.value !== passwordCheck.value) {
		        	passwordCheck.classList.remove("border-gray-5");
		        	passwordCheck.classList.add("border-red-600");
		        	
		        	error.textContent = "비밀번호가 일치하지 않습니다.";
		        	return;
		        } else {
		        	passwordCheck.classList.remove("border-red-600");
		        	passwordCheck.classList.add("border-gray-5");
		        }
		        
		        if(name.value === '') {
		        	name.classList.remove("border-gray-5");
		        	name.classList.add("border-red-600");
		        	
		        	error.textContent = "이름을 입력해야합니다.";
		        	return;
		        } else {
		        	name.classList.remove("border-red-600");
		        	name.classList.add("border-gray-5");
		        }
		        
		        if (!verifyNickname.checked) {
		        	error.textContent = "닉네임 중복 검사를 해야합니다.";
		        	return;
		        }
		
		      	if (age < 19) {
		      		birthDate.classList.remove("border-gray-5");
		      		birthDate.classList.add("border-red-600");
		      		
		        	error.textContent = "만 19세 이상만 가입할 수 있습니다.";
		        	return;
		        } else {
		        	birthDate.classList.remove("border-red-600");
		        	birthDate.classList.add("border-gray-5");
		        }
		
		        if (!/^010-\d{4}-\d{4}$/.test(phoneNumber.value)) {
		        	phoneNumber.classList.remove("border-gray-5");
		        	phoneNumber.classList.add("border-red-600");
		        	
		        	error.textContent = "전화번호 형식이 올바르지 않습니다.";
		        	return;
		        }  else {
		        	phoneNumber.classList.remove("border-red-600");
		        	phoneNumber.classList.add("border-gray-5");
		        }
		
		        if (!agreePrivacy) {
		        	error.textContent = "개인정보 수집에 동의해야 합니다.";
		        	return;
		        }
		        
		     	// 요청 객체 구성
		    	const requestBody = {
		    		user_name: name.value,
		    		password: password.value,
		    		password_check: passwordCheck.value,
		    		nickname: nickname.value,
		    		email: email.value,
		    		birth_date: birthDateVal,
		    		phone_number: phoneNumber.value,
		    		agree_privacy: agreePrivacy.checked
		    	};
		        
		        $.ajax({
		        	url: '/api/auth/register',
		        	type: 'POST',
		        	contentType: 'application/json; charset=utf-8',
		        	data: JSON.stringify(requestBody),
		        	success: function (response) {
		            	window.location.href = '/'; // 성공 시 이동
		          	},
		          	error: function (xhr) {
		    			const message = xhr.responseText || '회원가입 실패';
		    			error.textContent = message;
		    		}
		        });
		    });
	  	</script>
	</jsp:attribute>
</ui:layout>
