<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Point 로비" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<div class="grow p-4">
			<div class="w-full h-full p-4 flex flex-col gap-y-4 rounded-2xl bg-blue-4">
				<div class="flex gap-x-2">
					<span class="grow text-start text-gray-7 text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">Betting Point</span>
					<button class="h-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60" onclick="document.getElementById('createGameRoomModal').classList.remove('hidden')">방만들기</button>
					<button class="h-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60" onclick="location.href = '/'">홈으로 이동하기</button>
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
					<div id="room-container" class="absolute top-0 right-0 w-full h-full grid grid-cols-1 md:grid-cols-2 grid-rows-6 md:grid-rows-3 gap-4">
						<!-- 방 리스트 목록 들어가는 자리 -->						
					</div>
				</div>
				<div class="flex items-center justify-center gap-x-12 sm:gap-x-20 md:gap-x-28 lg:gap-x-36">
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3"><</button>
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">></button>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(function () {
				let gameRooms = []; // 게임방 리스트
				let games = {}; // 게임 정보
				let playerCounts = {}; // 각 게임방 플레이어 수
						
				function getLevelText(level) {
					switch (level) {
						case 'HARD':
					    	return '상';
					    case 'NORMAL':
					      	return '중';
					    case 'EASY':
					      	return '하';
					    default:
					      	return '-';
					}
				}
						
				// 게임 상세 정보 요청
				function gameDetail(room, games) {
				    return $.ajax({
				        url: `/api/game/detail/\${room.game_uid}`,
				        method: "GET",
				        success: function (gameData) {
				            games[room.game_uid] = gameData;
				        }
				    });
				}
						
				// 전체 플레이어 수 요청
				function countPlayers(playerCounts) {
				    return $.ajax({
				        url: "/api/player/count",
				        method: "GET",
				        success: function (countData) {
				            Object.assign(playerCounts, countData);
				        }
				    });
				}
						
				// 게임방 리스트 요청
			    $.ajax({
			        url: "/api/gameroom/list",
			        method: "GET",
			        success: function (responseData) {
			        	gameRooms = responseData;
								
			            // 게임 상세 정보 요청
			            let detailReq = gameRooms.map(room => gameDetail(room, games));

			            // 플레이어 수 요청
			            let countReq = countPlayers(playerCounts);

			            Promise.all([...detailReq, countReq]).then(() => {
			                const container = $("#room-container");
			                container.empty();

			                gameRooms.forEach(room => {
			                    const count = playerCounts[room.uid] || 0;
			                    const game = games[room.game_uid];
					                    
			                    const roomHtml = `
			                    	<div data-room-id="\${room.uid}" class="game-room min-h-36 flex flex-col justify-between p-4 bg-gray-8 rounded-lg hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
										<div class="flex items-center justify-between gap-x-4">
											<div class="w-7 sm:w-8 md:w-9 lg:w-10 h-7 sm:h-8 md:h-9 lg:h-10 rounded-full bg-blue-3 flex items-center justify-center text-ts-18 sm:text-ts-20 md:text-ts-24 text-red-1">\${getLevelText(game.level)}</div>
											<div class="grow text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 font-bold truncate">\${room.title}</div>
											<div class="min-w-12 text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 font-bold text-gray-9">\${count} / 8</div>
										</div>
										<div class="w-full text-start text-xl md:text-2xl text-blue-2 font-bold">\${game.name}</div>
										<div class="w-full grid grid-cols-2 items-center">
											<div class="flex items-center sm:min-w-56 justify-between text-gray-7 text-base md:text-lg">
												<span>최소 베팅 금액</span>
												<span class="text-black">\${room.min_bet}</span>
												<span>point</span>
											</div>
											<div class="w-full text-end text-lg md:text-xl text-blue-2 font-bold">\${room.status}</div>
										</div>
									</div>
			                    `;

			                    container.append(roomHtml);
			                });

			                $(".game-room").on("click", function () {
			                    const roomId = $(this).data("room-id");
			                    window.location.href = `/gameroom/detail/\${roomId}`;
			                });
			            });
			        }
			    });
			});
		</script>
	</jsp:attribute>
</ui:layout>