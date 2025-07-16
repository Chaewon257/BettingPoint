<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<%@ attribute name="modalId" required="true" %>

<ui:modal modalId="${modalId}" title="포인트 충전 결제">
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

		<div id="successModal" style="
		  display:none;
		  position: fixed; top: 50%; left: 50%;
		  transform: translate(-50%, -50%);
		  background: #F7F7F7;
		  border-radius: 16px;
		  width: 360px;
		  height: 420px;
		  text-align: center;
		  padding: 40px 20px;
		  color: #222;
		  z-index: 10000;
		  user-select: none;
		  flex-direction: column;
		  justify-content: center;
		  align-items: center;
		">
			<svg width="96" height="96" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" style="margin-bottom: 40px;">
				<circle cx="12" cy="12" r="12" fill="#2F80ED"/>
				<polyline points="18 6 9 17 5 12" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
			</svg>
			<div style="font-weight: 700; font-size: 1.5rem; line-height: 1.3;">
				결제를 완료했어요
			</div>
		</div>

		<div id="failModal" style="
		  display:none;
		  position: fixed; top: 50%; left: 50%;
		  transform: translate(-50%, -50%);
		  background: #F7F7F7;
		  border-radius: 16px;
		  width: 360px;
		  height: 420px;
		  text-align: center;
		  padding: 40px 20px;
		  color: #222;
		  z-index: 10000;
		  user-select: none;
		  flex-direction: column;
		  justify-content: center;
		  align-items: center;
		">
			<svg width="96" height="96" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" style="margin-bottom: 40px;">
				<circle cx="12" cy="12" r="12" fill="#FFC84B"/>
				<rect x="11" y="6" width="2" height="8" rx="1" fill="#000"/>
				<rect x="11" y="16" width="2" height="2" rx="1" fill="#000"/>
			</svg>
			<div style="font-weight: 700; font-size: 1.5rem; line-height: 1.3;">
				결제를 실패했어요
			</div>
		</div>
	</jsp:attribute>
</ui:modal>	
<script type="text/javascript">
	$(document).ready(function () {
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

			$("#modalContainer").css("width", `${newWidth}px`);
		}

		// 처음 실행
		adjustWidth();

		// 리사이즈 시 다시 적용
		$(window).resize(function() {
			adjustWidth();
		});

		// 포인트 값 업데이트 함수
		function updateAmountDisplay() {
			const point = parseInt($("#point").val(), 10) || 0;
			const payment = Math.floor(point * 1.1);

			$("#amountDisplay").text(payment.toLocaleString());
		}

		// input 변경 시
		$("#point").on("input", function () {
			updateAmountDisplay();
		});

		// 버튼 클릭 시
		$(".point-btn").click(function () {
			const addPoint = parseInt($(this).data("value"), 10) || 0;
			const currentPoint = parseInt($("#point").val(), 10) || 0;
			const newPoint = currentPoint + addPoint;

			$("#point").val(newPoint);
			updateAmountDisplay();
		});
	});

	// 모달 닫힐 때 input 초기화
	$(`#${modalId} > div > button`).on("click", function () {
		$("#point").val('');
		$("#amountDisplay").text('');
	});

	function openSuccessModal() {
		const $modal = $("#successModal");
		$modal.stop(true, true)
				.css("display", "flex")   // flex로 display 설정
				.hide()                  // 우선 숨긴 뒤
				.fadeTo(200, 1);         // 0 -> 1로 페이드 인

		setTimeout(() => {
			closeSuccessModal();
		}, 3000);
	}

	function closeSuccessModal() {
		const $modal = $("#successModal");
		$modal.stop(true, true)
				.fadeTo(200, 0, function() {
					$modal.css("display", "none");  // 투명도 0되면 display:none 처리
				});
	}

	function openFailModal() {
		const $modal = $("#failModal");
		$modal.stop(true, true)
				.css("display", "flex")
				.hide()
				.fadeTo(200, 1);

		setTimeout(() => {
			closeFailModal();
		}, 3000);
	}

	function closeFailModal() {
		const $modal = $("#failModal");
		$modal.stop(true, true)
				.fadeTo(200, 0, function() {
					$modal.css("display", "none");
				});
	}
	
	

	  const currentURL = window.location.href.replace(/[^/]*$/, '');

	  main();

	  async function main() {		
	    const button = document.getElementById("payment-button");
	    const coupon = document.getElementById("coupon-box");
		
	    // ------  결제위젯 초기화 ------
      // TODO: clientKey는 개발자센터의 결제위젯 연동 키 > 클라이언트 키로 바꾸세요.
      // TODO: 구매자의 고유 아이디를 불러와서 customerKey로 설정하세요. 이메일・전화번호와 같이 유추가 가능한 값은 안전하지 않습니다.
      // @docs https://docs.tosspayments.com/sdk/v2/js#토스페이먼츠-초기화
	    const clientKey = "test_gck_docs_Ovk5rk1EwkEbP0W43n07xlzm";
	    const customerKey = generateRandomString();

	    // 1) 사용자가 입력/버튼으로 설정한 포인트를 가져와서
	    const rawPoint = parseInt(document.getElementById("point").value, 10) || 0;
	    // 2) 1.1배 수수료 적용
	    const parsedAmount = Math.floor(rawPoint * 1.1);

	    const amount = {
	      currency: "KRW",
	      value: parsedAmount,
	    };

	    // TossPayments 초기화 (v2 standard SDK 방식)
	    const tossPayments = TossPayments(clientKey);
	    const widgets = tossPayments.widgets({
	      customerKey: customerKey,
	    });

	 	// ------  주문서의 결제 금액 설정 ------
      // TODO: 위젯의 결제금액을 결제하려는 금액으로 초기화하세요.
      // TODO: renderPaymentMethods, renderAgreement, requestPayment 보다 반드시 선행되어야 합니다.
      // @docs https://docs.tosspayments.com/sdk/v2/js#widgetssetamount
	    await widgets.setAmount(amount);

	    // 결제수단 및 약관 UI 렌더링
	    await Promise.all([
	      widgets.renderPaymentMethods({
	        selector: "#payment-method",
	     	// 렌더링하고 싶은 결제 UI의 variantKey
          // 결제 수단 및 스타일이 다른 멀티 UI를 직접 만들고 싶다면 계약이 필요해요.
          // @docs https://docs.tosspayments.com/guides/v2/payment-widget/admin#새로운-결제-ui-추가하기
	        variantKey: "DEFAULT",
	      }),
	   // ------  이용약관 UI 렌더링 ------
	      widgets.renderAgreement({
	        selector: "#agreement",
	        variantKey: "AGREEMENT",
	      }),
	    ]);

	 	// ------ '결제하기' 버튼 누르면 결제창 띄우기 ------
	    button.addEventListener("click", async function () {
	      try {
	    	  
	    	// 1) 화면 입력값(포인트)을 읽어서 동적 amount 계산
	        const rawPoint = parseInt(document.getElementById("point").value, 10) || 0;
	        const dynamicValue = Math.floor(rawPoint * 1.1);
	  
	        // 2) 위젯에 최신 금액 재설정
	        await widgets.setAmount({
	          currency: "KRW",
	          value: dynamicValue,
	        });

	    	// 결제를 요청하기 전에 orderId, amount를 서버에 저장하세요.
          // 결제 과정에서 악의적으로 결제 금액이 바뀌는 것을 확인하는 용도입니다.
	        const paymentResult = await widgets.requestPayment({
	        	orderId: generateRandomString(),
		        orderName: "[Betting Point] 포인트 충전"
	        });

		  	// 서버로 결제 승인에 필요한 결제 정보를 보내세요.
		    async function confirm() {
				var requestData = {
					payment_key: paymentResult.paymentKey,
					order_uid: paymentResult.orderId,
					amount: paymentResult.amount.value
				};

				const token = localStorage.getItem("accessToken");
				const response = await fetch("/api/payment/confirm", {
				  method: "POST",
				  headers: {
					  "Content-Type": "application/json",
					  "Authorization": "Bearer " + token,
				  },
				  body: JSON.stringify(requestData),
				});

			    const json = await response.json();

				if(!response.ok) {
					openFailModal();
					return;
				}

				return json
			}

		    confirm()
			  .then(function () {
				  openSuccessModal();
			  })
			  .catch(() => {
				  openFailModal();
			  });

	      } catch (err) {
	    	  console.error("결제 요청 중 에러 발생:", err);
			  openFailModal();
	      }
	    });
	  }
	  
	// 랜덤 문자열 생성 함수
  function generateRandomString() {
  	return window.btoa(Math.random()).slice(0, 20);
  }
</script>