<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="games" class="tab-content w-full flex flex-col">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-5">게임 이름</span>
		<span>결과</span>
		<span class="col-span-3">포인트 변동</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 grid-rows-10 border-b-2 border-gray-7 mb-6">
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1">
			<span class="font-light">1</span>
			<span class="col-span-5">Coin Toss</span>
			<span class="text-blue-1">승리</span>
			<div class="col-span-3 ">
				<span class="font-light">3000</span>
				<span class="text-blue-1">(+1000)</span>
			</div>
			<span class="col-span-2 font-light">2025.06.25</span>
		</div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1">
			<span class="font-light">2</span>
			<span class="col-span-5">Turtle Run</span>
			<span class="text-red-1">패배</span>
			<div class="col-span-3 ">
				<span class="font-light">3000</span>
				<span class="text-red-1">(-3000)</span>
			</div>
			<span class="col-span-2 font-light">2025.06.25</span>
		</div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 text-center border-b border-gray-1"></div>
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