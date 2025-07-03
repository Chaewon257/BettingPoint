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
		<script src="${cpath}/resources/js/chargemodal.js"></script>
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