<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Point 로비" pageType="ingame">
	<jsp:attribute name="bodyContent">
		<div class="grow p-2 md:p-4">
			<div class="w-full h-full grid grid-cols-7">
				<div class="col-span-5 bg-blue-4 rounded-s-2xl p-2 md:p-4 flex flex-col justify-between gap-y-2 md:gap-y-4">
					<div class="flex flex-col justify-between md:flex-row md:gap-x-4">
						<span class="truncate text-start text-gray-7 font-extrabold text-lg md:text-xl lg:text-2xl xl:text-3xl">포인트 이빠이 가즈아~~</span>
						<div class="grow flex md:justify-end gap-x-2">
							<button class="h-full bg-blue-3 hover:bg-blue-2 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl w-full md:min-w-24 md:max-w-56 py-1" onclick="document.getElementById('createGameRoomModal').classList.remove('hidden')">방정보 수정</button>
							<button class="h-full bg-gray-4 hover:bg-gray-2 rounded-lg text-gray-9 shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl w-full md:min-w-24 md:max-w-56 py-1" onclick="history.back()">나가기</button>
						</div>
					</div>
					<div class="relative w-full grid grid-cols-4 grid-rows-2 gap-2 md:gap-4 justify-items-stretch">
						<!-- 배경 요소 -->
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<!-- 플레이어 요소 -->
						<div class="absolute top-0 right-0 w-full h-full grid grid-cols-4 grid-rows-2 gap-2 md:gap-4 justify-items-stretch">
							<!-- 게임방 호스트 -->
							<div class="relative aspect-square rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)] flex justify-center items-center overflow-hidden p-2 md:p-4">
								<img id="mainTurtleImage" src="${cpath}/resources/images/turtle0.png" alt="Turtle Character" class="h-full" />
								<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 bg-white blur rounded-full"></div>
								<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 flex justify-center items-center font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl text-blue-5">방 장</div>
							</div>
							<!-- 준비 완료 상태 -->
							<div class="relative aspect-square rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)] flex justify-center items-center overflow-hidden p-2 md:p-4">
								<img src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" class="h-full" />
								<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 bg-white blur rounded-full"></div>
								<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 flex justify-center items-center font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl text-red-600">준비 완료</div>
							</div>
							<!-- 준비 미완료 상태 -->
							<div class="relative aspect-square rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)] flex justify-center items-center overflow-hidden p-2 md:p-4">
								<img src="${cpath}/resources/images/auth_turtle.png" alt="Turtle Character" class="h-full" />
								<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 bg-white blur rounded-full"></div>
								<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 flex justify-center items-center font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl text-gray-9">준비 완료</div>
							</div>
						</div>					
					</div>
					<div class="grow px-4 py-2 md:py-4 rounded-xl bg-black bg-opacity-10">
						<div class="h-full max-h-8 md:max-h-28 flex flex-col items-start overflow-y-scroll text-gray-7 text-xs md:text-sm font-light">
							<span>“부자가될그야"님이 입장하셨습니다.</span>
							<span>“부자가될그야"님이 입장하셨습니다.</span>
							<span>“부자가될그야"님이 입장하셨습니다.</span>
						</div>
					</div>	
				</div>
				<div class="col-span-2 flex flex-col items-start justify-between md:gap-4 bg-blue-3 rounded-e-2xl p-2 md:p-4 text-gray-6">
					<div class="w-full flex flex-col items-start gap-y-1 md:gap-y-4">
						<div class="font-extrabold text-sm md:text-lg lg:text-xl xl:text-2xl">거북이 선택</div>
						<div class="w-full grid grid-cols-3 grid-rows-3 gap-2 md:gap-4">
							<input type="hidden" id="turtle" name="turtle" value="none" />
							<button data-turtle="one" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle1.png" alt="Turtle1" class="w-full" />
							</button>
							<button data-turtle="two" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle2.png" alt="Turtle2" class="w-full" />
							</button>
							<button data-turtle="three" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle3.png" alt="Turtle3" class="w-full" />
							</button>
							<button data-turtle="four" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle4.png" alt="Turtle4" class="w-full" />
							</button>
							<button data-turtle="five" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle5.png" alt="Turtle5" class="w-full" />
							</button>
							<button data-turtle="six" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle6.png" alt="Turtle6" class="w-full" />
							</button>
							<button data-turtle="seven" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle7.png" alt="Turtle7" class="w-full" />
							</button>
							<button data-turtle="eight" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle8.png" alt="Turtle8" class="w-full" />
							</button>
							<button data-turtle="random" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle0.png" alt="Turtle0" class="w-full" />
							</button>
						</div>
						<div class="w-full flex flex-col items-start md:gap-2">
							<div class="flex flex-col items-start">
								<div class="font-extrabold text-sm md:text-lg lg:text-xl xl:text-2xl">베팅 포인트 입력</div>
								<div class="w-full flex justify-start gap-x-2 font-light text-gray-7 text-xs md:text-sm">
									<span>보유 포인트:</span>
									<strong>10000</strong>
									<span>P</span>	
								</div>
							</div>
							<input type="number" id="bet_point" name="bet_point" class="w-full px-2 md:px-4 py-1 md:py-2.5 text-xs outline-none bg-gray-4 rounded-full border border-gray-9" placeholder="베팅할 금액 입력해주세요" required>
							<div id="errorMessage" class="h-4 font-light text-red-600 text-xs md:text-sm"></div>
						</div>
					</div>
					<button class="w-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4">게임 시작</button>
				</div>
			</div>
		</div>
		<!-- 가로 모드 권유 오버레이 -->
		<div id="landscapeNotice" class="fixed inset-0 bg-white z-[9999] flex flex-col justify-center items-center text-center hidden">
		  <p class="text-gray-7 text-lg sm:text-xl md:text-2xl font-bold">더 나은 화면을 위해<br>기기를 가로 모드로 전환해주세요.</p>
		</div>
		<script type="text/javascript">
			function checkOrientation() {
				if (window.innerHeight > window.innerWidth) {
			    	// 세로 모드 → 오버레이 표시
			    	$("#landscapeNotice").removeClass("hidden");
			  	} else {
			    	// 가로 모드 → 오버레이 숨김
			    	$("#landscapeNotice").addClass("hidden");
			  	}
			}

			$(document).ready(function () {
				checkOrientation(); // 최초 실행
			  	$(window).on("resize orientationchange", checkOrientation); // 창 크기나 회전 시 다시 검사
			});
		
			$(".turtle-btn").on("click", function () {
				let selectedTurtle = $(this).data("turtle");

			    // "random" 선택 시 다른 버튼 중 하나를 무작위 선택
			    if (selectedTurtle === "random") {
			        // random 버튼 제외하고 나머지 turtle-btn 가져오기
			        const buttons = $(".turtle-btn").not('[data-turtle="random"]');
			        const randomIndex = Math.floor(Math.random() * buttons.length);
			        const randomBtn = buttons.eq(randomIndex);

			        // 스타일 업데이트
			        $(".turtle-btn").removeClass("border-blue-2").addClass("border-transparent");
			        randomBtn.removeClass("border-transparent").addClass("border-blue-2");
					
			     	// 선택된 이미지 src 가져오기
			        const imgSrc = randomBtn.find("img").attr("src");
			        $("#mainTurtleImage").attr("src", imgSrc);
			        
			        // 선택된 turtle 데이터
			        selectedTurtle = randomBtn.data("turtle");
			    } else {
			        // 스타일 업데이트
			        $(".turtle-btn").removeClass("border-blue-2").addClass("border-transparent");
			        $(this).removeClass("border-transparent").addClass("border-blue-2");
			        
			     	// 선택된 이미지 src 가져오기
			        const imgSrc = $(this).find("img").attr("src");
			        $("#mainTurtleImage").attr("src", imgSrc);
			    }
			    
			 	// ✅ 숨겨진 turtle input 값 변경
				$("#turtle").val(selectedTurtle);
			});
		</script>
	</jsp:attribute>
</ui:layout>