<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div class="box_section" style="width: 600px">
	    <img width="100px" src="https://static.toss.im/illusts/check-blue-spot-ending-frame.png" />
	    <h2>결제를 완료했어요</h2>
	
	    <div class="p-grid typography--p" style="margin-top: 50px">
	        <div class="p-grid-col text--left"><b>결제금액</b></div>
	        <div class="p-grid-col text--right" id="amount">\${totalAmount}</div>
	    </div>
	    <div class="p-grid typography--p" style="margin-top: 10px">
	        <div class="p-grid-col text--left"><b>주문번호</b></div>
	        <div class="p-grid-col text--right" id="orderId">\${orderId}</div>
	    </div>
	    <div class="p-grid typography--p" style="margin-top: 10px">
	        <div class="p-grid-col text--left"><b>paymentKey</b></div>
	        <div class="p-grid-col text--right" id="paymentKey" style="white-space: initial; width: 250px">\${paymentKey}</div>
	    </div>
	    <div class="p-grid" style="margin-top: 30px">
	        <button class="button p-grid-col5" onclick="location.href='https://docs.tosspayments.com/guides/payment/integration';">연동 문서</button>
	        <button class="button p-grid-col5" onclick="location.href='https://discord.gg/A4fRFXQhRu';" style="background-color: #e8f3ff; color: #1b64da">실시간 문의</button>
	    </div>
	</div>
	
	<div class="box_section" style="width: 600px; text-align: left">
	    <b>Response Data :</b>
	    <div id="response">
	        <pre>
	            
	        </pre>
	    </div>
	</div>
</body>
</html>