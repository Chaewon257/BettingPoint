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
		<ui:modal modalId="createGameRoomModal" title="방 만들기">
			<jsp:attribute name="content">
				<div class="py-4 sm:w-[36rem] md:w-[48rem] min-w-72 overflow-y-scroll flex flex-col gap-y-4">
					<input type="text" id="roomName" name="roomName" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="방 이름" required>
					<div id="gameGrid" class="grid grid-cols-3 gap-x-2">
					</div>
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-0">
						<div class="grow grid grid-cols-3 gap-4">
							<button class="bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5 md:py-0.5">상</button>
							<button class="bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5 md:py-0.5">중</button>
							<button class="bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5 md:py-0.5">하</button>
						</div>
						<div class="grow flex items-center justify-end text-gray-7 text-xl font-bold md:ml-4">
							<span>배당률:</span>
							<span class="w-36 text-center text-black">500</span>
							<span>%</span>
						</div>
					</div>
					<input type="number" id="min_bet" name="min_bet" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="최소 베팅 금액" required>
					<div class="flex justify-end">
						<span id="errorMessage" class="grow text-xs h-5 text-red-600"></span>
						<button id="createGameRoomBtn" class="h-full py-1 bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60">방만들기</button>
					</div>
				</div>
			</jsp:attribute>
		</ui:modal>
		<script type="text/javascript">
		  $(function () {
		    let gamerooms = []; // 게임방 리스트
		    let games = {};    // 게임 정보
		    let levels = {};   // 게임 난이도 리스트
		    let playerCounts = {}; // 각 게임방 플레이어 수
		    let socket;
		
		    function getLevelText(level) {
		      const levels = { HARD: '상', NORMAL: '중', EASY: '하' };
		      return levels[level] || '-';
		    }
		
		    function fetchGameDetail(room) {
		      return $.ajax({
		        url: `/api/game/detail/\${room.game_uid}`,
		        method: "GET",
		        success: function (gameData) {
		          games[room.game_uid] = gameData;
		        }
		      });
		    }
		
		    function renderGameRooms() {
		      const container = $("#room-container").empty();
		
		      gamerooms.forEach(room => {
		        const html = `
		          <div data-room-id="${room.uid}" class="game-room min-h-36 flex flex-col justify-between p-4 bg-gray-8 rounded-lg hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
		            <div class="flex items-center justify-between gap-x-4">
		              <div class="w-7 sm:w-8 md:w-9 lg:w-10 h-7 sm:h-8 md:h-9 lg:h-10 rounded-full bg-blue-3 flex items-center justify-center text-ts-18 sm:text-ts-20 md:text-ts-24 text-red-1">
		                \${getLevelText(room.level)}
		              </div>
		              <div class="grow text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28 font-bold truncate">
		                \${room.title}
		              </div>
		              <div class="min-w-12 text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 font-bold text-gray-9">
		                \${room.count} / 8
		              </div>
		            </div>
		            <div class="w-full text-start text-xl md:text-2xl text-blue-2 font-bold">\${room.game_name}</div>
		            <div class="w-full grid grid-cols-2 items-center">
		              <div class="flex items-center sm:min-w-56 justify-between text-gray-7 text-base md:text-lg">
		                <span>최소 베팅 금액</span>
		                <span class="text-black">\${room.min_bet}</span>
		                <span>point</span>
		              </div>
		              <div class="w-full text-end text-lg md:text-xl text-blue-2 font-bold">\${room.status}</div>
		            </div>
		          </div>`;
		 
		        container.append(html);
		      });
		
		      $(".game-room").on("click", function () {
		        const roomId = $(this).data("room-id");
		        window.location.href = `/gameroom/detail/\${roomId}`;
		      });
		    }
		
		    function connectGameWebSocket() {
		      if (socket && socket.readyState === WebSocket.OPEN) {
		        socket.close();
		      }
		
		      socket = new WebSocket(`ws://\${location.host}/ws/gameroom`);
		
		      socket.onmessage = (event) => {
		        const msg = JSON.parse(event.data);
		
		        if (msg.gamerooms) gamerooms = msg.gamerooms;
		        if (msg.playerCounts) playerCounts = msg.playerCounts;
		
		        switch (msg.type) {
		          case "insert":
		          case "delete":
		          case "enter":
		          case "exit":
		            renderGameRooms();
		            break;
		          default:
		            console.warn("알 수 없는 메시지 타입", msg.type);
		        }
		      };
		
		      socket.onclose = () => {
		      };
		
		      socket.onerror = (error) => {
		        console.error("❌ 웹소켓 에러 발생", error);
		      };
		    }
		
		    function loadGameRooms() {
		      $.ajax({
		        url: "/api/gameroom/list",
		        method: "GET",
		        success: function (responseData) {
		          gamerooms = responseData;
		
		          let gameReqs = gamerooms.map(room => {
		            return levelDetail(room, levels).then(() => {
		              const levelData = levels[room.game_level_uid];
		              return gameDetail(levelData, games);
		            });
		          });
		
		          let countReq = countPlayers(playerCounts);
		
		          Promise.all([...gameReqs, countReq]).then(() => {
		            connectGameWebSocket();
		            renderGameRooms();
		          });
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
		              <div class="aspect-square bg-blue-4 rounded-md overflow-hidden hover:shadow-[2px_2px_8px_rgba(0,0,0,0.2)]">
		                <img alt="game image" src="https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/\${game.game_img}" class="w-full h-full object-cover">
		              </div>`);
		          });
		
		          const fill = (3 - (games.length % 3)) % 3;
		          for (let i = 0; i < fill; i++) {
		            grid.append(`<div class="aspect-square bg-blue-4 rounded-md"></div>`);
		          }
		        },
		        error: function () {
		          $('#gameGrid').html('<div class="col-span-3 text-red-500 text-center">게임 목록을 불러오지 못했습니다.</div>');
		        }
		      });
		    }
		
		    $('#createGameRoomBtn').on('click', function () {
		      const error = $('#errorMessage');
		      error.text('');
		
		      const roomName = $('#roomName').val().trim();
		      const minBet = $('#min_bet').val().trim();
		
		      if (!roomName) {
		        error.text('방 제목을 입력해주세요.');
		        return;
		      }
		      if (!minBet || isNaN(minBet) || Number(minBet) <= 0) {
		        error.text('유효한 최소 베팅 금액을 입력해주세요.');
		        return;
		      }
		
		      console.log("방 생성 요청:", roomName, minBet);
		    });
		
		    loadGameRooms();
		    loadGameList();
		  });
		</script>
	</jsp:attribute>
</ui:layout>