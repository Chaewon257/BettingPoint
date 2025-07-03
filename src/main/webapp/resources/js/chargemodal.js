
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

	    const amount = {
	      currency: "KRW",
	      value: 50000,
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

	 	// ------  주문서의 결제 금액이 변경되었을 경우 결제 금액 업데이트 ------
	    coupon.addEventListener("change", async function () {
	      const discountAmount = coupon.checked ? amount.value - 5000 : amount.value;
	      await widgets.setAmount({
	        currency: "KRW",
	        value: discountAmount,
	      });
	    });

	 	// ------ '결제하기' 버튼 누르면 결제창 띄우기 ------
	    button.addEventListener("click", async function () {
	      try {
	    	// 결제를 요청하기 전에 orderId, amount를 서버에 저장하세요.
            // 결제 과정에서 악의적으로 결제 금액이 바뀌는 것을 확인하는 용도입니다.
	        await widgets.requestPayment({
	          orderId: generateRandomString(),
	          orderName: "토스 티셔츠 외 2건",
	          successUrl: currentURL + "success.jsp",
	          failUrl: currentURL + "fail.jsp",
	          customerEmail: "customer123@gmail.com",
	          customerName: "김토스",
	          // 가상계좌 안내, 퀵계좌이체 휴대폰 번호 자동 완성에 사용되는 값입니다. 필요하다면 주석을 해제해 주세요.
	          // customerMobilePhone: "01012341234", // 필요 시 활성화
	        });
	      } catch (err) {
	        console.error("결제 요청 중 에러 발생:", err);
	      }
	    });
	  }
	
	    // 랜덤 문자열 생성 함수
	    function generateRandomString() {
	      	return "7HBEHt9msR-pAbwhBYdus";
	    	//return window.btoa(Math.random()).slice(0, 20);
	    }