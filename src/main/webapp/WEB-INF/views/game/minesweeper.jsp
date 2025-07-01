<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<ui:layout pageName="Minesweeper" pageType="ingame">
<jsp:attribute name="bodyContent">
<input type="hidden" id="gameUid" value="${gameUid}">
<script src="${cpath}/resources/js/minesweeper.js" defer></script>
<link rel="stylesheet" href="${cpath}/resources/css/minesweeper.css">

<div class="w-4/5 max-w-screen-xl mx-auto min-w-80 h-3/5 xl:w-3/4 xl:max-w-screen-2xl">
  <div class="relative mb-8 text-center">
    <h1 class="text-xl font-bold text-blue-900 sm:text-2xl lg:text-3xl xl:text-4xl">
      💎 지뢰찾기 게임
    </h1>
    <button class="absolute top-0 right-0 bg-blue-200 text-blue-900 border-none py-2 px-4 rounded-lg font-bold cursor-pointer text-xs transition-colors duration-300 hover:bg-blue-300 sm:text-sm"
      onclick="location.href='/solo'">개인게임 리스트로 이동하기</button>
  </div>

  <div class="bg-white rounded-2xl p-6 border border-blue-200 min-h-96 flex flex-col gap-5 md:flex-row xl:p-12 xl:min-h-[600px]">
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
        <div class="grid grid-cols-[repeat(auto-fit,minmax(80px,1fr))] gap-3">
          <div class="difficulty-option py-4 px-2 border-2 border-blue-200 rounded-xl bg-white text-center cursor-pointer hover:bg-blue-50" data-difficulty="hard">
            <div class="text-sm font-bold mb-1.5 sm:text-base">상</div>
            <div class="text-xs mb-1 sm:text-sm difficulty-chance">연결 전</div>
            <div class="text-sm font-bold text-orange-600 sm:text-base difficulty-payout">연결 전</div>
          </div>
          <div class="difficulty-option py-4 px-2 border-2 border-blue-200 rounded-xl bg-white text-center cursor-pointer hover:bg-blue-50" data-difficulty="normal">
            <div class="text-sm font-bold mb-1.5 sm:text-base">중</div>
            <div class="text-xs mb-1 sm:text-sm difficulty-chance">연결 전</div>
            <div class="text-sm font-bold text-orange-600 sm:text-base difficulty-payout">연결 전</div>
          </div>
          <div class="difficulty-option py-4 px-2 border-2 border-blue-200 rounded-xl bg-white text-center cursor-pointer hover:bg-blue-50" data-difficulty="easy">
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
          <input type="number" class="flex-1 p-3 border-2 border-blue-400 rounded-lg text-sm text-center focus:outline-none focus:border-blue-600 sm:text-base" id="bet-amount" placeholder="배팅할 포인트 입력" min="1" />
        </div>
        <div class="grid grid-cols-[repeat(auto-fit,minmax(60px,1fr))] gap-2">
          <button class="bet-preset py-3 px-2 rounded-lg bg-blue-200 text-blue-900 font-bold hover:bg-blue-400 text-xs sm:text-sm" data-amount="1000">1000</button>
          <button class="bet-preset py-3 px-2 rounded-lg bg-blue-200 text-blue-900 font-bold hover:bg-blue-400 text-xs sm:text-sm" data-amount="10000">10000</button>
          <button class="bet-preset py-3 px-2 rounded-lg bg-blue-200 text-blue-900 font-bold hover:bg-blue-400 text-xs sm:text-sm" data-amount="50000">50000</button>
          <button class="bet-preset py-3 px-2 rounded-lg bg-blue-200 text-blue-900 font-bold hover:bg-blue-400 text-xs sm:text-sm" data-amount="all">ALL IN</button>
        </div>
      </div>
    </div>

    <!-- 오른쪽 패널 -->
    <div class="flex-1 flex flex-col gap-5 pt-5 md:pl-6 md:pt-0 xl:pl-16">
      <div class="grid grid-cols-[repeat(auto-fit,minmax(80px,1fr))] gap-3">
        <div class="text-center p-2.5 bg-blue-50 rounded-lg h-20">
          <div class="text-xs text-slate-600 mb-1 sm:text-sm">현재 배팅</div>
          <div class="text-sm font-bold sm:text-xl" id="current-bet">0</div>
        </div>
        <div class="text-center p-2.5 bg-blue-50 rounded-lg h-20">
          <div class="text-xs text-slate-600 mb-1 sm:text-sm">발견한 보석</div>
          <div class="text-sm font-bold sm:text-xl" id="gems-found">0</div>
        </div>
        <div class="text-center p-2.5 bg-blue-50 rounded-lg h-20">
          <div class="text-xs text-slate-600 mb-1 sm:text-sm">예상 획득</div>
          <div class="text-sm font-bold sm:text-xl" id="potential-win">0</div>
        </div>
      </div>

      <div class="mt-2.5 flex flex-col items-center">
        <div class="grid grid-cols-5 gap-2 mb-4 p-4 bg-blue-50 rounded-xl" id="gameBoard">
          <!-- 타일 생성 -->
        </div>

        <div class="result-message p-2.5 rounded-lg text-center font-bold text-sm hidden sm:text-base" id="result-message">
          난이도와 베팅 금액을 선택하고 게임을 시작하세요!
        </div>

        <div class="mt-6 flex gap-3 flex-wrap">
          <button class="game-button py-3 px-6 rounded-xl text-sm font-bold bg-blue-200 text-blue-900 hover:bg-blue-300 sm:text-base" id="start-btn">게임 시작</button>
          <button class="game-button btn-success hidden py-3 px-6 rounded-xl text-sm font-bold bg-green-500 text-white hover:bg-green-700 sm:text-base" id="cashout-btn">현금화</button>
        </div>

        <div class="start-error-message p-2.5 rounded-lg text-center mt-4 font-bold text-sm hidden text-red-700 sm:text-base" id="start-error-message"></div>
      </div>
    </div>
  </div>
</div>

</jsp:attribute>
</ui:layout>
