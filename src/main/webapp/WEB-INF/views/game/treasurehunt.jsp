<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<ui:layout pageName="Minesweeper" pageType="ingame">
<jsp:attribute name="bodyContent">
<input type="hidden" id="gameUid" value="${gameUid}">
<script src="${cpath}/resources/js/treasurehunt.js" defer></script>
<link rel="stylesheet" href="${cpath}/resources/css/treasurehunt.css">

<div class="w-full max-w-screen-xl mx-auto px-4 sm:px-6 md:px-8">
  <div class="relative mb-8 text-center">
    <h1 class="text-xl font-bold text-blue-900 sm:text-2xl lg:text-3xl xl:text-4xl">
      <img src="${cpath}/resources/images/treasure.png" alt="보물" 
        class="inline-block h-9 sm:h-11 lg:h-13 xl:h-13 mr-2 bg-transparent object-contain">
      Treasure Hunt
    </h1>      
    <button
      class="absolute right-0 top-0 sm:top-0 top-8  /* 모바일에서 top-10(3rem)로 아래로 내림 */
             bg-blue-200 text-blue-900 border-none py-2 px-4 rounded-lg font-bold cursor-pointer text-xs transition-colors duration-300 hover:bg-blue-300 sm:text-sm"
      onclick="location.href='/solo'">
      뒤로가기
    </button>
  </div>

  <div class="bg-white sm:h-[570px] max-sm:h-auto max-sm:min-h-[800px] rounded-2xl p-6 border border-blue-200 flex flex-col gap-5 md:flex-row xl:p-12">
    <!-- 왼쪽 패널 -->
    <div class="flex-1 flex flex-col gap-5 border-b-2 border-blue-100 pb-5 md:border-b-0 md:border-r-2 md:pr-6 md:pb-0 xl:pr-16">
      <!-- 유저 포인트 -->
      <div class="bg-blue-200 p-5 rounded-xl text-center text-blue-900">
        <div class="text-sm opacity-90">
          <span id="userNickname" class="font-bold">사용자</span>님의 보유 포인트
        </div>
        <div class="text-xl font-bold sm:text-2xl lg:text-3xl" id="balance">연결 전</div>
      </div>

      <!-- 난이도 선택 -->
      <div>
        <h3 class="text-base font-bold mb-3 leading-tight text-blue-900 sm:text-lg">
          <img src="${cpath}/resources/images/difficulty.png" alt="난이도" class="inline-block h-5 sm:h-7 lg:h-8 xl:h-13 mr-2">
          난이도 선택
        </h3>
        <div class="grid grid-cols-3 gap-3">
          <div class="difficulty-option py-4 px-2 border-2 border-blue-200 rounded-xl bg-white text-center cursor-pointer transition-all duration-300 hover:bg-blue-50" data-difficulty="hard">
            <div class="text-sm font-bold mb-1.5 sm:text-base">상</div>
            <div class="text-xs mb-1 sm:text-sm difficulty-chance">연결 전</div>
            <div class="text-sm font-bold text-orange-600 sm:text-base difficulty-payout">연결 전</div>
          </div>
          <div class="difficulty-option py-4 px-2 border-2 border-blue-200 rounded-xl bg-white text-center cursor-pointer transition-all duration-300 hover:bg-blue-50" data-difficulty="normal">
            <div class="text-sm font-bold mb-1.5 sm:text-base">중</div>
            <div class="text-xs mb-1 sm:text-sm difficulty-chance">연결 전</div>
            <div class="text-sm font-bold text-orange-600 sm:text-base difficulty-payout">연결 전</div>
          </div>
          <div class="difficulty-option py-4 px-2 border-2 border-blue-200 rounded-xl bg-white text-center cursor-pointer transition-all duration-300 hover:bg-blue-50" data-difficulty="easy">
            <div class="text-sm font-bold mb-1.5 sm:text-base">하</div>
            <div class="text-xs mb-1 sm:text-sm difficulty-chance">연결 전</div>
            <div class="text-sm font-bold text-orange-600 sm:text-base difficulty-payout">연결 전</div>
          </div>
        </div>
      </div>

      <!-- 배팅 금액 -->
      <div>
        <div class="flex gap-2.5 mb-3">
          <h3 class="text-base font-bold leading-tight text-blue-900 sm:text-lg">
            <img src="${cpath}/resources/images/betting-money.png" alt="배팅금액" class="inline-block h-3 sm:h-5 lg:h-6 xl:w-7 mr-2">
            배팅 금액
          </h3>
          <span class="input-error hidden text-red-700" id="input-error"></span>
        </div>
        <div class="flex items-center gap-3 mb-2.5">
          <input type="number" class="flex-1 p-3 border-2 border-blue-400 rounded-lg text-sm text-center min-w-0 focus:outline-none focus:border-blue-600 sm:text-base" id="bet-amount" placeholder="배팅할 포인트 입력" min="1" />
        </div>
        <div class="grid grid-cols-4 gap-2">
          <button class="bet-preset py-3 px-2 border-none rounded-lg bg-blue-200 text-blue-900 font-bold cursor-pointer transition-colors duration-300 text-xs hover:bg-blue-400 sm:text-sm" data-amount="1000">1000</button>
          <button class="bet-preset py-3 px-2 border-none rounded-lg bg-blue-200 text-blue-900 font-bold cursor-pointer transition-colors duration-300 text-xs hover:bg-blue-400 sm:text-sm" data-amount="10000">10000</button>
          <button class="bet-preset py-3 px-2 border-none rounded-lg bg-blue-200 text-blue-900 font-bold cursor-pointer transition-colors duration-300 text-xs hover:bg-blue-400 sm:text-sm" data-amount="50000">50000</button>
          <button class="bet-preset py-3 px-2 border-none rounded-lg bg-blue-200 text-blue-900 font-bold cursor-pointer transition-colors duration-300 text-xs hover:bg-blue-400 sm:text-sm" data-amount="all">ALL IN</button>
        </div>
      </div>
    </div>

    <!-- 오른쪽 패널 -->
    <div class="flex-1 flex flex-col gap-5 pt-5 md:pl-6 md:pt-0 xl:pl-16">
      <div class="grid grid-cols-3 gap-3">
        <div class="text-center p-2.5 bg-blue-50 rounded-lg h-20">
          <div class="text-xs text-slate-600 mb-1 sm:text-sm">현재 배팅</div>
          <div class="text-sm font-bold sm:text-xl" id="current-bet">0</div>
        </div>
        <div class="text-center p-2.5 bg-blue-50 rounded-lg h-20">
          <div class="text-xs text-slate-600 mb-1 sm:text-sm">찾은 보석</div>
          <div class="text-sm font-bold sm:text-xl" id="gems-found">0</div>
        </div>
        <div class="text-center p-2.5 bg-blue-50 rounded-lg h-20">
          <div class="text-xs text-slate-600 mb-1 sm:text-sm">예상 획득</div>
          <div class="text-sm font-bold sm:text-xl" id="potential-win">0</div>
        </div>
      </div>

      <div class="mt-2.5 flex flex-col items-center">
  <div id="gameBoard" class="grid grid-cols-5 
                            gap-1 sm:gap-2 md:gap-1
                            w-full 
                            max-w-[250px] sm:max-w-[280px] md:max-w-[300x]
                            mx-auto 
                            p-1 sm:p-3 md:p-3 
                            bg-blue-50 rounded-xl">
  <!-- 타일 생성 -->
</div>

        <div class="result-message" id="result-message">
        </div>

        <div class="mt-6 flex gap-3 flex-wrap">
          <button class="game-button py-3 px-6 border-none rounded-xl text-sm font-bold cursor-pointer transition-all duration-300 bg-blue-200 text-blue-900 hover:bg-blue-300 sm:text-base disabled:bg-gray-400 disabled:cursor-not-allowed" id="start-btn">게임 시작</button>
          <button class="game-button btn-success hidden py-3 px-6 border-none rounded-xl text-sm font-bold cursor-pointer transition-all duration-300 bg-red-500 text-white min-w-20 hover:bg-red-700 sm:text-base disabled:bg-gray-400 disabled:cursor-not-allowed" id="stop-btn">STOP</button>
        </div>

        <div class="start-error-message text-red-700 mt-2 sm:text-base" id="start-error-message"></div>
      </div>
    </div>
  </div>
</div>

</jsp:attribute>
</ui:layout>