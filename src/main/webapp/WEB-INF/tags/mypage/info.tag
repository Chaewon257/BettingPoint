<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="info" class="tab-content w-full flex flex-col gap-y-8">
	<div class="w-full flex flex-row gap-10 rounded-lg bg-gray-10 p-10">
		<div class="flex flex-col gap-y-10">
			<div class="w-72 h-72 rounded-full bg-white flex justify-center overflow-hidden">
				<img id="profileImage" alt="default profile image" src="">
			</div>
			<div class="grow flex flex-col items-center gap-y-2 rounded-xl bg-blue-4 p-4">
				<div class="w-full flex items-center justify-between text-gray-6 text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">
					<img alt="money box" src="${cpath}/resources/images/money_box.png" class="w-12">
					<div id="pointBalance" class="grow text-center">00000</div>
					<div>P</div>
				</div>
				<div class="w-full h-px bg-gray-1"></div>
				<button class="grow w-full rounded-xl text-gray-6 hover:text-white text-ts-28 hover:bg-blue-3">충전하기</button>
			</div>
		</div>
		<div class="grow flex flex-col justify-between gap-y-4">
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">이메일</span>
				<input type="email" id="email" name="email" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="이메일" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">비밀번호</span>
				<input type="password" id="password" name="password" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="비밀번호" required>
			</div>
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">비밀번호 확인</span>
				<input type="password" id="passwordCheck" name="passwordCheck" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="비밀번호 확인" required>
			</div>
			<div class="flex flex-col items-start gap-y-1">
				<span class="text-xs text-gray-6 pl-1">이름</span>
				<input type="text" id="name" name="name" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="이름" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
			  	<span class="text-xs text-gray-6 pl-1">닉네임</span>
				<input type="text" id="nickname" name="nickname" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="닉네임" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
				<span class="text-xs text-gray-6 pl-1">생년월일</span>
				<input type="date" id="birthDate" name="birthDate" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5 cursor-not-allowed" placeholder="생년월일" required readonly>
			</div>
			<div class="flex flex-col items-start gap-y-1">
				<span class="text-xs text-gray-6 pl-1">전화번호</span>
 				<input type="text" id="phoneNumber" name="phoneNumber" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="전화번호(010-0000-0000)" required>
			</div>
		</div>				
	</div>
	<div class="w-full flex flex-col items-end">
		<button class="h-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60 py-2">수정하기</button>
	</div>
</div>
