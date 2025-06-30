<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Point 로비" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<div class="grow p-4">
			<div class="w-full h-full p-4 flex flex-col gap-y-4 rounded-2xl bg-blue-4">
				<!-- 상단 -->
				<div class="flex gap-x-2">
					<span class="grow text-start text-gray-7 text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">Betting Point</span>
					<button class="h-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60" onclick="document.getElementById('createGameRoomModal').classList.remove('hidden')">방만들기</button>
					<button class="h-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60" onclick="location.href='/'">홈으로 이동하기</button>
				</div>

				<!-- 방 목록 -->
				<div class="relative grow">
					<div class="w-full h-full grid grid-cols-1 md:grid-cols-2 grid-rows-6 md:grid-rows-3 gap-4">
						<%-- 기본 배경용 박스 --%>
						<c:forEach var="i" begin="1" end="6">
							<div class="min-h-36 bg-blue-6 rounded-lg"></div>
						</c:forEach>
					</div>
					<div id="room-container" class="absolute top-0 right-0 w-full h-full grid grid-cols-1 md:grid-cols-2 grid-rows-6 md:grid-rows-3 gap-4">
						<!-- 방 리스트 출력 -->
					</div>
				</div>

				<!-- 페이지네이션 -->
				<div class="flex items-center justify-center gap-x-12 sm:gap-x-20 md:gap-x-28 lg:gap-x-36">
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">&lt;</button>
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">&gt;</button>
				</div>
			</div>
		</div>

		<!-- 방 생성 모달 -->
		<ui:modal modalId="createGameRoomModal" title="방 만들기">
			<jsp:attribute name="content">
				<div class="py-4 sm:w-[36rem] md:w-[48rem] min-w-72 overflow-y-scroll flex flex-col gap-y-4">
					<input type="text" id="roomName" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="방 이름" required>

					<div id="gameGrid" class="grid grid-cols-3 gap-x-2"></div>

					<div class="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-0">
						<div class="grid grid-cols-3 gap-4">
							<button class="bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5">상</button>
							<button class="bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5">중</button>
							<button class="bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5">하</button>
						</div>
						<div class="flex items-center justify-end text-gray-7 text-xl font-bold">
							<span>배당률:</span>
							<span class="w-36 text-center text-black">500</span>
							<span>%</span>
						</div>
					</div>

					<input type="number" id="min_bet" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="최소 베팅 금액" required>
					
					<div class="flex justify-end">
						<span id="errorMessage" class="grow text-xs h-5 text-red-600"></span>
						<button id="createGameRoomBtn" class="h-full py-1 bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60">방만들기</button>
					</div>
				</div>
			</jsp:attribute>
		</ui:modal>

		<script type="text/javascript">
			$(function () {
				let gamerooms = [];
				let socket;

				const getLevelText = (level) => ({ HARD: '상', NORMAL: '중', EASY: '하' }[level] || '-');

				function renderGameRooms(rooms) {
					const container = $("#room-container").empty();
					rooms.forEach(room => {
						const html = `
							<div data-room-id="${room.uid}" data-status="${room.status}" class="game-room min-h-36 flex flex-col justify-between p-4 bg-gray-8 rounded-lg hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
								<div class="flex items-center justify-between gap-x-4">
									<div class="w-7 sm:w-8 md:w-9 lg:w-10 h-7 sm:h-8 md:h-9 lg:h-10 rounded-full bg-blue-3 flex items-center justify-center text-ts-18 sm:text-ts-20 md:text-ts-24 text-red-1">
										${getLevelText(room.level)}
									</div>
									<div class="grow text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 font-bold truncate">${room.title}</div>
									<div class="min-w-12 text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 font-bold text-gray-9">${room.count} / 8</div>
								</div>
								<div class="w-full text-start text-xl md:text-2xl text-blue-2 font-bold">${room.game_name}</div>
								<div class="w-full grid grid-cols-2 items-center">
									<div class="flex justify-between text-gray-7 text-base md:text-lg">
										<span>최소 베팅 금액</span><span class="text-black">${room.min_bet}</span><span>point</span>
									</div>
									<div class="w-full text-end text-lg md:text-xl text-blue-2 font-bold">${room.status}</div>
								</div>
							</div>`;
						container.append(html);
					});

					$(".game-room").on("click", function () {
						const status = $(this).data("status");
						if (status !== "PLAYING") {
							window.location.href = `/gameroom/detail/${$(this).data("room-id")}`;
						} else {
							alert("진행중인 게임방입니다.");
						}
					});
				}

				function connectGameWebSocket() {
					if (socket && socket.readyState === WebSocket.OPEN) socket.close();

					socket = new WebSocket(`ws://${location.host}/ws/gameroom`);
					socket.onmessage = (e) => {
						const msg = JSON.parse(e.data);
						if (msg.gamerooms) gamerooms = msg.gamerooms;
						if (["insert", "delete", "enter", "exit"].includes(msg.type)) renderGameRooms(gamerooms);
					};
					socket.onerror = (e) => console.error("❌ 웹소켓 에러", e);
				}

				function loadGameRooms() {
					$.ajax({
						url: "/api/gameroom/list",
						method: "GET",
						success: function (data) {
							gamerooms = data;
							connectGameWebSocket();
							renderGameRooms(gamerooms);
						}
					});
				}

				function loadGameList() {
					$.ajax({
						url: '/api/game/list/type',
						type: 'GET',
						data: { type: "MULTI" },
						success: function (games) {
							const grid = $('#gameGrid').empty();
							games.forEach(game => {
								grid.append(`
									<button class="game-select aspect-square bg-blue-4 rounded-md overflow-hidden hover:shadow-[2px_2px_8px_rgba(0,0,0,0.2)]" data-uid="/${game.uid}">
										<img alt="game image" src="https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/${game.game_img}" class="w-full h-full object-cover">
									</button>
								`);
							});
							const fill = (3 - (games.length % 3)) % 3;
							for (let i = 0; i < fill; i++) grid.append(`<div class="aspect-square bg-blue-4 rounded-md"></div>`);
						},
						error: () => $('#gameGrid').html('<div class="col-span-3 text-red-500 text-center">게임 목록 불러오기 실패</div>')
					});
				}

				$('#createGameRoomBtn').on('click', function () {
					const error = $('#errorMessage').text('');
					const roomName = $('#roomName').val().trim();
					const minBet = $('#min_bet').val().trim();
					if (!roomName) return error.text('방 제목을 입력해주세요.');
					if (!minBet || isNaN(minBet) || Number(minBet) <= 0) return error.text('유효한 최소 베팅 금액을 입력해주세요.');

					console.log("방 생성 요청:", roomName, minBet);
				});

				loadGameRooms();
				loadGameList();
			});
		</script>
	</jsp:attribute>
</ui:layout>