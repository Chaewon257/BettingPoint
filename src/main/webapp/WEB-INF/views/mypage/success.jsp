<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 성공 페이지</title>
<link rel="icon" href="https://static.toss.im/icons/png/4x/icon-toss-logo.png" />
</head>
<body>
	<div class="box_section" style="width: 600px">
	  <img width="100px" src="https://static.toss.im/illusts/check-blue-spot-ending-frame.png" />
	  <h2>결제를 완료했어요</h2>

	  <div class="p-grid typography--p" style="margin-top: 50px">
	    <div class="p-grid-col text--left"><b>결제금액</b></div>
	    <div class="p-grid-col text--right" id="amount"></div>
	  </div>
	  <div class="p-grid typography--p" style="margin-top: 10px">
	    <div class="p-grid-col text--left"><b>주문번호</b></div>
	    <div class="p-grid-col text--right" id="orderId"></div>
	  </div>
	  <div class="p-grid typography--p" style="margin-top: 10px">
	    <div class="p-grid-col text--left"><b>paymentKey</b></div>
	    <div class="p-grid-col text--right" id="paymentKey" style="white-space: initial; width: 250px"></div>
	  </div>
	  <div class="p-grid" style="margin-top: 30px">
	    <button class="button p-grid-col5" onclick="location.href='https://docs.210.com/guides/v2/payment-widget/integration';">연동 문서</button>
	    <button class="button p-grid-col5" onclick="location.href='/support';" style="background-color: #e8f3ff; color: #1b64da">실시간 문의</button>
	  </div>
	</div>

	<div class="box_section" style="width: 600px; text-align: left">
	  <b>Response Data :</b>
	  <div id="response" style="white-space: initial"></div>
	</div>

	<script>
	  // 쿼리 파라미터 값을 서버로 전달해 결제 요청할 때 보낸 데이터와 동일한지 반드시 확인하세요.
	  // 클라이언트에서 결제 금액을 조작하는 행위를 방지할 수 있습니다.
	  const urlParams = new URLSearchParams(window.location.search);

	  // 서버로 결제 승인에 필요한 결제 정보를 보내세요.
	  async function confirm() {
	    var requestData = {
	      payment_key: urlParams.get("paymentKey"),
	      order_uid: urlParams.get("orderId"),
	      amount: urlParams.get("amount"),
	    };

		const token = localStorage.getItem("accessToken");

	    // 실제 API 들어갈 부분
	    const response = await fetch("/api/payment/confirm", {
	      method: "POST",
	      headers: {
	        "Content-Type": "application/json",
			  "Authorization": "Bearer " + token
	      },
	      body: JSON.stringify(requestData),
	    });

	    const json = await response.json();

	    if (!response.ok) {
	      throw { message: json.message, code: json.code };
	    }

	    return json;
	  }

	  confirm()
	    .then(function (data) {
	      // TODO: 결제 승인에 성공했을 경우 UI 처리 로직을 구현하세요.
	      //document.getElementById("response").innerHTML = `<pre>${JSON.stringify(data, null, 4)}</pre>`;

	      // 2) 결제 성공 시 UI 처리 or 페이지 이동
	      // → 성공 페이지로 리다이렉트하면서 주문정보를 쿼리스트링으로 넘기기
	      window.location.href = `\${currentURL}success.jsp?orderId=\${encodeURIComponent(data.orderId)}&amount=${data.amount}`;
	    })
	    .catch((err) => {
	      // TODO: 결제 승인에 실패했을 경우 UI 처리 로직을 구현하세요.
	      // 3) 결제 승인 혹은 서버 검증 실패 시
		  console.error('결제 처리 중 에러:', err);
		  window.location.href = `\${currentURL}fail.jsp?message=\${encodeURIComponent(err.message)}`;
	    });

	  const paymentKeyElement = document.getElementById("paymentKey");
	  const orderIdElement = document.getElementById("orderId");
	  const amountElement = document.getElementById("amount");

	  orderIdElement.textContent = urlParams.get("orderId");
	  amountElement.textContent = urlParams.get("amount") + "원";
	  paymentKeyElement.textContent = urlParams.get("paymentKey");
	</script>
</body>
</html>