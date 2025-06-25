<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="points" class="tab-content w-full flex flex-col mb-20">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-3">내역</span>
		<span class="col-span-3">잔액</span>
		<span>종류</span>
		<span class="col-span-2">비고</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 grid-rows-10 border-b-2 border-gray-7 mb-6">
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1">
			<span class="font-light">1</span>
			<span class="col-span-3 text-blue-1">1000</span>
			<span class="col-span-3 font-light">11000</span>
			<span class="text-blue-1">충전</span>
			<span class="col-span-2 font-light"></span>
			<span class="col-span-2 font-light">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1">
			<span class="font-light">2</span>
			<span class="col-span-3 text-red-1">2000</span>
			<span class="col-span-3 font-light">9000</span>
			<span class="text-red-1">사용</span>
			<span class="col-span-2 font-light">배달의 민족</span>
			<span class="col-span-2 font-light">2025.06.24</span>
		</div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1">
			<span class="font-light">3</span>
			<span class="col-span-3 text-blue-1">4000</span>
			<span class="col-span-3 font-light">13000</span>
			<span class="text-blue-1">승리</span>
			<span class="col-span-2 font-light">Coin Toss</span>
			<span class="col-span-2 font-light">2025.06.25</span>
		</div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1">
			<span class="font-light">4</span>
			<span class="col-span-3 text-red-1">3000</span>
			<span class="col-span-3 font-light">10000</span>
			<span class="text-red-1">패배</span>
			<span class="col-span-2 font-light">Turtle Run</span>
			<span class="col-span-2 font-light">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
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