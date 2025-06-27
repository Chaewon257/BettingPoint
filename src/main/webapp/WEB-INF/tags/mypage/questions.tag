<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<div data-content="questions" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-5">문의 내용</span>
		<span class="col-span-2">상태</span>
		<span class="col-span-2">상세</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 grid-rows-10 border-b-2 border-gray-7 mb-6">
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
			<span class="font-light">1</span>
			<span class="col-span-5 truncate">Betting Point 게임이 이렇게 재미있어도 되는건가요? 이거 만든 사람들 누구?</span>
			<span class="col-span-2 font-light">대기중</span>
			<button class="col-span-2 underline">상세보기</button>
			<span class="col-span-2 font-light">2025.06.25</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
			<span class="font-light">2</span>
			<span class="col-span-5 truncate">돈을 다 잃었는데 어째요...ㅠ</span>
			<span class="col-span-2 font-light">대기중</span>
			<button class="col-span-2 underline">상세보기</button>
			<span class="col-span-2 font-light">2025.06.24</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
			<span class="font-light">3</span>
			<span class="col-span-5 truncate">게임 방법은 어떻게 확인하나요</span>
			<span class="col-span-2 font-light">답변완료</span>
			<button class="col-span-2 underline">상세보기</button>
			<span class="col-span-2 font-light">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1">
			<span class="font-light">4</span>
			<span class="col-span-5 truncate">포인트 충전을 어떻게 해야하나요??</span>
			<span class="col-span-2 font-light">답변완료</span>
			<button class="col-span-2 underline" onclick="document.getElementById('questionsDetailModal').classList.remove('hidden')">상세보기</button>
			<span class="col-span-2 font-light">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
	</div>
	<div class="flex justify-center items-center">
		<div class="flex items-center">
			<button class="w-8 h-8 rounded-s border border-gray-1 text-gray-1 hover:bg-gray-2"><</button>
			<button class="w-8 h-8 bg-gray-2 border border-gray-1">1</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">2</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">3</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">4</button>
			<button class="w-8 h-8 border border-gray-1 hover:bg-gray-2">5</button>
			<button class="w-8 h-8 rounded-e border border-gray-1 hover:bg-gray-2">></button>
		</div>
	</div>
</div>
<ui:modal modalId="questionsDetailModal" title="문의내역 상세보기">
	<jsp:attribute name="content">
		<div class="py-4 px-2 sm:w-[36rem] md:w-[48rem] min-w-72 flex flex-col gap-y-4">
			<div class="text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">
				포인트 충전을 어떻게 해야하나요??
			</div>
			<div class="w-full overflow-y-scroll">
				<div class="p-6 bg-white rounded-xl shadow-md border border-gray-200 text-gray-800">
					<p class="text-base mb-4">
						안녕하세요 😊<br>
				    	포인트 충전은 아래의 방법으로 간편하게 하실 수 있습니다:
				  	</p>
				  	<ol class="list-decimal list-inside space-y-2 mb-6">
				    	<li>
				    		<strong>마이페이지 접속</strong><br>
				    		화면 상단 메뉴에서 <strong>마이페이지</strong>를 클릭해주세요.
				    	</li>
				    	<li>
				    		<strong>충전하기 버튼 클릭</strong><br>
				    		마이페이지 내 프로필 영역에 있는 <strong>충전하기</strong> 버튼을 눌러주세요.
				    	</li>
				    	<li>
				      		<strong>충전 금액 입력 및 결제 진행</strong><br>
				      		원하는 포인트 금액을 입력하신 후, 결제 수단을 선택하여 충전을 완료하시면 됩니다.
				    	</li>
				  	</ol>
					<div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 text-sm text-gray-700">
						<p class="font-bold mb-2">✅ 주의사항</p>
					    <ul class="list-disc list-inside space-y-1">
					    	<li>충전한 포인트는 즉시 사용 가능합니다.</li>
					      	<li>충전 후 <strong>취소는 불가</strong>하니 신중하게 입력해 주세요.</li>
					    </ul>
					</div>
				</div>
			</div>
		</div>
	</jsp:attribute>
</ui:modal>