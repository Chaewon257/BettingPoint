<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>

 <ui:layout pageName="Coin Toss" pageType="ingame"> 
	<jsp:attribute name="bodyContent">
		<input type="hidden" id="gameUid"  value="${gameUid}"> 
		<script src="${cpath}/resources/js/cointoss.js" defer></script>
		<div class="custom-container">
			<div class="header">
				<h1 class="title">🪙 Coin Toss</h1>
				<button class="move-home" onclick="location.href='/'">홈으로 이동하기
				</button>
			</div>
	
			<div class="card horizontal-layout">
				<!-- 왼쪽 패널 -->
				<div class="left-panel">
					<div class="balance-info">
						<div class="balance-label">
						 <span id="userNickname">사용자</span>님의 보유 포인트
						</div>
						<div class="balance-amount" id="balance">연결 전</div>
					</div>
	
					<div class="difficulty-section">
						<h3 class="section-title">🎯 난이도 선택</h3>
						<div class="difficulty-options">
							<div class="difficulty-option" data-difficulty="hard">
								<div class="difficulty-name">상</div>
								<div class="difficulty-chance">연결 전</div>
								<div class="difficulty-payout">연결 전</div>
							</div>
							<div class="difficulty-option selected" data-difficulty="normal">
								<div class="difficulty-name">중</div>
								<div class="difficulty-chance">연결 전</div>
								<div class="difficulty-payout">연결 전</div>
							</div>
							<div class="difficulty-option" data-difficulty="easy">
								<div class="difficulty-name">하</div>
								<div class="difficulty-chance">연결 전</div>
								<div class="difficulty-payout">연결 전</div>
							</div>
						</div>
					</div>
	
					<div class="betting-section">
						<div class="section-header">
							<h3 class="section-title">💰 배팅 금액</h3>
							<a class="input-error" id="input-error"></a>
						</div>
						<div class="bet-input-container">
							<input type="number" class="bet-input" id="bet-amount"
								placeholder="배팅할 포인트 입력" min="1" />
	
						</div>
						<div class="bet-buttons">
							<button class="bet-preset" data-amount="1000">1000</button>
							<button class="bet-preset" data-amount="10000">10000</button>
							<button class="bet-preset" data-amount="50000">50000</button>
							<button class="bet-preset" data-amount="all">ALL IN</button>
						</div>
					</div>
				</div>
	
				<!-- 오른쪽 패널 -->
				<div class="right-panel">
					<div class="stats-container">
						<div class="stat-item">
							<div class="stat-label">현재 배팅</div>
							<div class="stat-value" id="current-bet">0</div>
						</div>
						<div class="stat-item">
							<div class="stat-label">연속 성공</div>
							<div class="stat-value" id="streak">0</div>
						</div>
						<div class="stat-item">
							<div class="stat-label">예상 획득</div>
							<div class="stat-value" id="potential-win">0</div>
						</div>
					</div>
	
					<div class="coin-container">
						<div class="coin heads" id="coin">
							<div class="coin-symbol"></div>
						</div>
	
						<div class="result-message" id="result-message"></div>
	
						<div class="game-buttons">
							<button class="game-button btn-primary" id="start-btn">게임
								시작</button>
							<button class="game-button btn-success hidden" id="go-btn">GO</button>
							<button class="game-button btn-danger hidden" id="stop-btn">STOP</button>
						</div>
	
						<div class="start-error-message" id="start-error-message"></div>
					</div>
				</div>
			</div>
		</div>
	</jsp:attribute>
</ui:layout>