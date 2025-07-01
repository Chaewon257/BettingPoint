<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="Betting Point 로비" pageType="lobby">
	<jsp:attribute name="bodyContent">
		<div class="grow p-4">
			<div class="w-full h-full p-4 flex flex-col gap-y-4 rounded-2xl bg-blue-4">
				<div class="flex gap-x-2">
					<span class="grow text-start text-gray-7 text-ts-18 sm:text-ts-20 md:text-ts-24 lg:text-ts-28">Betting Point</span>
					<button id="createGameRoomModalOpen" class="h-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60" onclick="document.getElementById('createGameRoomModal').classList.remove('hidden')">방만들기</button>
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
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">&lt;</button>
					<button class="w-8 h-8 rounded-md text-blue-2 border border-blue-3 hover:bg-blue-3">&gt;</button>
				</div>
			</div>
		</div>
		<ui:modal modalId="createGameRoomModal" title="방 만들기">
			<jsp:attribute name="content">
				<div class="py-4 sm:w-[36rem] md:w-[48rem] min-w-72 overflow-y-scroll flex flex-col gap-y-4">
					<input type="text" id="roomName" name="roomName" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="방 이름" required>
					<div id="gameBtn" class="grid grid-cols-3 gap-x-2">
						<!-- 게임 이미지 버튼 -->
					</div>
					<input type="hidden" id="gameUid" name="gameUid" value="none" />
					<div class="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-0">
						<div class="grow grid grid-cols-3 gap-4">
							<button data-level="HARD" class="level-tab bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5 md:py-0.5">상</button>
							<button data-level="NORMAL" class="level-tab bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5 md:py-0.5">중</button>
							<button data-level="EASY" class="level-tab bg-gray-4 rounded-full border-2 border-gray-5 text-xs py-1.5 md:py-0.5">하</button>
						</div>
						<div class="grow flex items-center justify-end text-gray-7 text-xl font-bold md:ml-4">
							<span>배당률:</span>
							<span id="game_reward" class="w-36 text-center text-black">000</span>
							<span>%</span>
						</div>
					</div>
					<input type="hidden" id="gameLevelUid" name="gameLevelUid" value="none" />
					<input type="number" id="min_bet" name="min_bet" class="w-full px-4 py-2 text-xs outline-none bg-gray-4 rounded-full border border-gray-5" placeholder="최소 베팅 금액" required>
					<div class="flex items-center justify-between">
						<span id="errorMessage" class="grow text-xs h-5 text-red-600"></span>
						<button id="createGameRoomBtn" class="h-full py-1 bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24 w-24 sm:w-32 md:w-48 lg:w-60">방만들기</button>
					</div>
				</div>
			</jsp:attribute>
		</ui:modal>
		<script type="text/javascript">
			$(document).ready(function () {
		    	let gamerooms = []; // 게임방 리스트
		    	let playerCounts = {}; // 각 게임방 플레이어 수
		    	let socket;
		       
		    	// 레벨 텍스트 변환 함수
				const getLevelText = (level) => ({ HARD: '상', NORMAL: '중', EASY: '하' }[level] || '-');
			
				// 게임방 목록 렌더링
		    	function renderGameRooms(gamerooms) {
		      		const container = $("#room-container").empty();
		
		      		gamerooms.forEach(room => {
		        	const html = `
		          		<div data-room-id="\${room.uid}" data-status="$\{room.status}" class="game-room min-h-36 flex flex-col justify-between p-4 bg-gray-8 rounded-lg hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)]">
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
		              				<div class="w-full text-end text-lg md:text-xl text-blue-2 font-bold">
		              					\${room.status}
		              				</div>
		            			</div>
		          			</div>`;
		 
		        		container.append(html);
		      		});
		
		      		$(".game-room").on("click", function () {
				  		const roomStatus = $(this).data("status");
				  		
				  		if(roomStatus !== "PLAYING") {
					  		const roomId = $(this).data("room-id");
					  		window.location.href = `/gameroom/detail/\${roomId}`;
				  		} else {
					  		alert("진행중인 게임방입니다.");
				  		}
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
		            			renderGameRooms(gamerooms);
		            			break;
		          			default:
		            			console.warn("알 수 없는 메시지 타입", msg.type);
		        		}
		      		};
		
		      		socket.onclose = () => {
		                console.log("🔌 웹소켓 연결 종료");
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
		            		connectGameWebSocket();
		            		renderGameRooms(responseData);
		        		}
		      		});
		    	}
		    	
		    	// ✅ 화면 렌더링 시 실행
		        loadGameRooms();
		  	});
		  
			$('#createGameRoomModalOpen').on('click', function () {				
				$.ajax({
					url: '/api/game/list/type',
				    type: 'GET',
				    data: { type: "MULTI" },
				    success: function (games) {
				    	const gameBtn = $('#gameBtn').empty();

				      	// 게임 목록 생성
				      	games.forEach(game => {
				      		gameBtn.append(`
				          		<button data-uid="\${game.uid}" class="game-select aspect-square bg-blue-4 rounded-md overflow-hidden border-2 border-transparent hover:shadow-[2px_2px_8px_rgba(0,0,0,0.2)]">
				            		<img alt="game image" src="\${game.game_img}" class="w-full h-full object-cover">
				          		</button>
				          	`);
				      	});

				      	// 3개 단위로 맞추기 위한 빈 박스 추가
				      	const fill = (3 - (games.length % 3)) % 3;
				      	for (let i = 0; i < fill; i++) {
				      		gameBtn.append(`<div class="aspect-square bg-blue-4 rounded-md"></div>`);
				      	}
				    },
				    error: function () {
				    	// 실패 시 모달 닫고 경고문 띄우기
				    	$("#createGameRoomModal").addClass("hidden");
				    	alert("게임 목록을 불러오지 못했습니다.");
				    }
				});
			});
			
			let currentGameLevels = []; // 선택된 게임의 난이도 리스트
			
			// 게임 이미지 버튼 클릭
			$(document).on("click", ".game-select", function () {
				const selectedGame = $(this).data("uid");
				
				// 스타일 초기화
				$(".game-select").removeClass("border-blue-2").addClass("border-transparent");
				$(this).removeClass("border-transparent").addClass("border-blue-2");
	
				$('#gameUid').val(selectedGame);
				
				// 선택한 게임에 대한 난이도 리스트 요청
			    $.ajax({
			        url: `/api/game/levels/by-game/\${selectedGame}`,
			        type: 'GET',
			        success: function(levels) {
			            currentGameLevels = levels;
			        },
			        error: function() {
			            currentGameLevels = [];
			            alert("게임 난이도 정보를 불러오지 못했습니다.");
			        }
			    });
			});
			
			// 난이도 버튼 클릭
			$(document).on("click", ".level-tab", function () {
				const selectedLevel = $(this).data("level");
			 	
			 	if($('#gameUid').val() === 'none') {
			 		alert("게임을 선택해주세요");
			 		return;
			 	}
			 	
			 	// 스타일 초기화
				$(".level-tab").removeClass("border-gray-7").addClass("border-gray-5");
				$(this).removeClass("border-gray-5").addClass("border-gray-7");
			 	
				// currentGameLevels 에서 level.level === selectedLevel 인 객체 찾기
			    const levelInfo = currentGameLevels.find(l => l.level === selectedLevel);

			    if (!levelInfo) {
			        $('#game_reward').text("해당 난이도 정보가 없습니다.");
			        return;
			    }
			    
			    $('#gameLevelUid').val(levelInfo.uid);

			    // levelInfo.uid를 이용해 상세 정보 요청
			    $.ajax({
			        url: `/api/game/level/\${levelInfo.uid}`,
			        type: 'GET',
			        success: function(detail) {
			        	$("#game_reward").text(detail.reward);
			        },
			        error: function() {
			            $("#game_reward").text("000");
			            alert("배당률 정보를 불러오지 못했습니다.");
			        }
			    });
			});
			
			// 게임방 생성 버튼
			$('#createGameRoomBtn').on('click', function () {
				const error = document.getElementById('errorMessage');
			    error.textContent = "";
		
		      	const roomName = $('#roomName').val().trim();
		      	const minBet = $('#min_bet').val().trim();
		
		      	if (!roomName) {
		      		error.textContent = '방 제목을 입력해주세요';
		        	return;
		      	}
		      	if (!minBet || isNaN(minBet) || Number(minBet) <= 0) {
		      		error.textContent = '유효한 최소 베팅 금액을 입력해주세요.';
		        	return;
		      	}
		      	
		      	const payload = {
		        		title: roomName,
		                min_bet: minBet,
		                game_uid: $('#gameUid').val(),
		                game_level_uid: $('#gameLevelUid').val()
		       		};
		      	
		      	const token = localStorage.getItem("accessToken");
		      	
		      	$.ajax({
		        	url: '/api/gameroom/insert',
		            type: 'POST',
		            contentType: 'application/json',
		            data: JSON.stringify(payload),
		            headers: {
		                'Authorization': 'Bearer ' + token
		            },
		            success: function(roomId) {
		                location.href = '/gameroom/detail/' + roomId;
		            },
		            error: function() {
		                alert("다시 시도하세요.");
		            }
		        });
		    });
		</script>
	</jsp:attribute>
</ui:layout>