<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="free" class="tab-content w-full flex flex-col mb-20 text-xs sm:text-sm">
	<div class="p-4 grid grid-cols-12 text-center text-gray-3 font-semibold border-b-2 border-gray-7 border-double">
		<span>번호</span>
		<span class="col-span-3">제목</span>
		<span class="col-span-2">좋아요</span>
		<span class="col-span-2">조회</span>
		<span class="col-span-2">작성자</span>
		<span class="col-span-2">날짜</span>
	</div>
	<div class="grid grid-cols-1 grid-rows-10 border-b-2 border-gray-7 mb-6">
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1 font-light">
			<span>1</span>
			<span class="col-span-3 truncate">이것이 자유다 정말!!</span>
			<div class="col-span-2 flex items-center justify-center gap-x-2">
				<img alt="service image" src="${cpath}/resources/images/like.png" class="w-4">
				<span>100</span>
			</div>
			<div class="col-span-2 flex items-center justify-center gap-x-2">
				<img alt="service image" src="${cpath}/resources/images/view.png" class="w-4">
				<span>100</span>
			</div>
			<span class="col-span-2">부자가될끄야</span>
			<span class="col-span-2">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1 font-light">
			<span>2</span>
			<span class="col-span-3 truncate">이것이 자유다 정말!!</span>
			<div class="col-span-2 flex items-center justify-center gap-x-2">
				<img alt="service image" src="${cpath}/resources/images/like.png" class="w-4">
				<span>100</span>
			</div>
			<div class="col-span-2 flex items-center justify-center gap-x-2">
				<img alt="service image" src="${cpath}/resources/images/view.png" class="w-4">
				<span>100</span>
			</div>
			<span class="col-span-2">부자가될끄야</span>
			<span class="col-span-2">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1 font-light">
			<span>3</span>
			<span class="col-span-3 truncate">이것이 자유다 정말!!</span>
			<div class="col-span-2 flex items-center justify-center gap-x-2">
				<img alt="service image" src="${cpath}/resources/images/like.png" class="w-4">
				<span>100</span>
			</div>
			<div class="col-span-2 flex items-center justify-center gap-x-2">
				<img alt="service image" src="${cpath}/resources/images/view.png" class="w-4">
				<span>100</span>
			</div>
			<span class="col-span-2">부자가될끄야</span>
			<span class="col-span-2">2025.06.23</span>
		</div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
		<div class="p-4 grid grid-cols-12 items-center text-center border-b border-gray-1"></div>
	</div>
	<div class="w-full flex justify-end items-center mb-4">
		<a href="/board/write" class="text-black no-underline cursor-pointer py-1.5 px-[1.625rem] border-2 border-black rounded-full transition-all duration-300 ease-in-out hover:bg-gray-2">글쓰기</a>
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