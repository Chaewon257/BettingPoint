<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Turtle Run" pageType="ingame">
	<jsp:attribute name="bodyContent">
		<link rel = "stylesheet"  href="${cpath}/resources/css/turtlerun.css" >			
		<div id="gameRoot" class="bg-white w-[1200px] h-[900px] rounded-[36px] shadow-lg
	      md:w-[900px] md:h-[700px] md:rounded-[22px] md:shadow-md flex flex-col mx-auto my-auto
	      sm:w-full sm:h-full sm:rounded-none sm:shadow-none transition-all duration-300 relative">
			<div id="trackViewport" class="flex flex-col flex-1 w-full h-full overflow-hidden">
				<div class="crowd-repeat w-full" style="height: 16vh; min-height: 56px; z-index: 2; pointer-events: none;"></div>
				<div class="crowd-stand w-full" style="height: 2vh; min-height: 10px; z-index: 2;"></div>
				<div id="trackContainer" class="track-container flex-1 relative w-full min-h-0 p-0 border-0"></div>
			</div>
			<!-- 결과 모달 -->
			<div class="absolute z-[1001] left-0 top-0 w-full h-full bg-black/50 hidden flex justify-center items-center" id="resultModal">
				<div class="bg-white rounded-xl p-5 shadow-lg relative max-w-[90%] w-[400px]">
					<span class="absolute top-2 right-3 text-2xl cursor-pointer text-gray-600 hover:text-black" id="modalClose">&times;</span>
					<h2 id="winnerText"></h2>
					<div id="resultImage" class="flex justify-center"></div>
					<p id="resultMessage"></p>
					<p id="pointSummary" class="font-bold text-lg mt-2"></p>
					<p id="countdownText" class="mt-3 text-sm text-gray-600 w-full text-center"></p>
				</div>
			</div>
		</div>
		<script> var roomId = "${roomId}";</script> 
		<script src="${cpath}/resources/js/turtlerun.js"></script>
	</jsp:attribute>
</ui:layout>