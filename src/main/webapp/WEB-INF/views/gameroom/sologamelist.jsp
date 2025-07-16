<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Point 개인 게임" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<script src="${cpath}/resources/js/sologamelist.js"></script>
		<div class="grow p-4">
			<div class="w-full h-full p-4 flex flex-col gap-y-4 rounded-2xl bg-blue-4">
				<div class="flex gap-x-2">
					<span class="grow text-start text-gray-7 text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">개인 게임</span>
					<button class="h-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60 py-2" onclick="location.href = '/'">홈으로 이동하기</button>
				</div>
				<div class="relative grow">
					<div class="w-full h-full grow grid grid-cols-1 md:grid-cols-2 grid-rows-6 md:grid-rows-3 gap-4">
						<div class="min-h-36 bg-blue-6 rounded-lg"></div>
						<div class="min-h-36 bg-blue-6 rounded-lg"></div>
						<div class="min-h-36 bg-blue-6 rounded-lg"></div>
						<div class="min-h-36 bg-blue-6 rounded-lg"></div>
						<div class="min-h-36 bg-blue-6 rounded-lg"></div>
						<div class="min-h-36 bg-blue-6 rounded-lg"></div>
					</div>
					<div id="soloGameList" class="absolute top-0 right-0 w-full h-full grid grid-cols-1 md:grid-cols-2 grid-rows-6 md:grid-rows-3 gap-4">
					</div>
				</div>
				<div class="flex items-center justify-center gap-x-12 sm:gap-x-20 md:gap-x-28 lg:gap-x-36">
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">&lt;</button>
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">&gt;</button>
				</div>
			</div>
		</div>
	</jsp:attribute>
</ui:layout>