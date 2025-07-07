<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>
<ui:layout pageName="TurtleRun 게임 대기방" pageType="ingame">
	<jsp:attribute name="bodyContent">
		<div class="grow p-2 md:p-4">
			<div class="w-full h-full grid grid-cols-7">
				<div class="col-span-5 bg-blue-4 rounded-s-2xl p-2 md:p-4 flex flex-col justify-between gap-y-2 md:gap-y-4">
					<div class="flex flex-col justify-between md:flex-row md:gap-x-4">
						<div>
							<span id="room-title" class="truncate text-start text-gray-7 font-extrabold text-lg md:text-xl lg:text-2xl xl:text-3xl"></span>
						</div>
						<div class="grow flex md:justify-end gap-x-2">
							<button class="h-full bg-blue-3 hover:bg-blue-2 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl w-full md:min-w-24 md:max-w-56 py-1" onclick="document.getElementById('createGameRoomModal').classList.remove('hidden')">방정보 수정</button>
							<button class="h-full bg-gray-4 hover:bg-gray-2 rounded-lg text-gray-9 shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl w-full md:min-w-24 md:max-w-56 py-1" onclick="location.href='/gameroom'">나가기</button>
						</div>
					</div>
					<div class="relative w-full grid grid-cols-4 grid-rows-2 gap-2 md:gap-4 justify-items-stretch">
						<!-- 배경 요소 -->
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<div class="aspect-square bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)]"></div>
						<!-- 플레이어 요소 -->
						<div id="player-list" class="absolute top-0 right-0 w-full h-full grid grid-cols-4 grid-rows-2 gap-2 md:gap-4 justify-items-stretch">

						</div>
					</div>
					<div id="chat-box" class="grow px-4 py-2 md:py-4 rounded-xl bg-black bg-opacity-10">
						<div class="h-full max-h-8 md:max-h-28 flex flex-col items-start overflow-y-scroll text-gray-7 text-xs md:text-sm font-light">
							<%-- 입/퇴장 메시지 --%>
						</div>
					</div>
				</div>
				<div class="col-span-2 flex flex-col items-start justify-between md:gap-4 bg-blue-3 rounded-e-2xl p-2 md:p-4 text-gray-6">
					<div class="w-full flex flex-col items-start gap-y-1 md:gap-y-4">
						<div class="font-extrabold text-sm md:text-lg lg:text-xl xl:text-2xl">거북이 선택</div>
						<div class="w-full grid grid-cols-3 grid-rows-3 gap-2 md:gap-4">
							<input type="hidden" id="turtle" name="turtle" value="none" />
							<button data-turtle="one" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle1.png" alt="Turtle1" class="w-full" />
							</button>
							<button data-turtle="two" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle2.png" alt="Turtle2" class="w-full" />
							</button>
							<button data-turtle="three" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle3.png" alt="Turtle3" class="w-full" />
							</button>
							<button data-turtle="four" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle4.png" alt="Turtle4" class="w-full" />
							</button>
							<button data-turtle="five" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle5.png" alt="Turtle5" class="w-full" />
							</button>
							<button data-turtle="six" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle6.png" alt="Turtle6" class="w-full" />
							</button>
							<button data-turtle="seven" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle7.png" alt="Turtle7" class="w-full" />
							</button>
							<button data-turtle="eight" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle8.png" alt="Turtle8" class="w-full" />
							</button>
							<button data-turtle="random" class="turtle-btn aspect-square bg-white rounded-xl hover:shadow-[2px_2px_8px_rgba(0,0,0,0.15)] p-2 overflow-hidden border-2 md:border-4 border-transparent">
								<img src="${cpath}/resources/images/turtle0.png" alt="Turtle0" class="w-full" />
							</button>
						</div>
						<div class="w-full flex flex-col items-start md:gap-2">
							<div class="flex flex-col items-start">
								<div class="font-extrabold text-sm md:text-lg lg:text-xl xl:text-2xl">베팅 포인트 입력</div>
								<div class="w-full flex justify-start gap-x-2 font-light text-gray-7 text-xs md:text-sm">
									<span>현재 보유 포인트:</span>
									<strong id="user-point"></strong>
									<span>P</span>
								</div>
								<div class="w-full flex justify-start gap-x-2 font-light text-gray-7 text-xs md:text-sm">
									<span>최소 베팅 포인트:</span>
									<strong id="min-bet"></strong>
									<span>P</span>
								</div>
							</div>
							<input type="number" id="bet_point" name="bet_point" class="w-full px-2 md:px-4 py-1 md:py-2.5 text-xs outline-none bg-gray-4 rounded-full border border-gray-9" placeholder="베팅할 금액 입력해주세요" required>
								<div id="errorMessage" class="h-4 font-light text-red-600 text-xs md:text-sm"></div>
						</div>
					</div>
					<!-- 게임 시작 버튼 -->
					<button id="start-game-btn" class="w-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4 disabled:bg-blue-2 disabled:opacity-60 disabled:cursor-not-allowed">
						게임 시작
					</button>

					<!-- 준비 버튼 -->
					<button id="ready-btn" class="w-full bg-blue-2 hover:bg-blue-5 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4">
						게임 준비
					</button>
				</div>
			</div>
		</div>
		<!-- 가로 모드 권유 오버레이 -->
		<div id="landscapeNotice" class="fixed inset-0 bg-white z-[9999] flex flex-col justify-center items-center text-center hidden">
		  <p class="text-gray-7 text-lg sm:text-xl md:text-2xl font-bold">더 나은 화면을 위해<br>기기를 가로 모드로 전환해주세요.</p>
		</div>
		<script>
			let socket;
			let minBet = 0;
			let userId;
			let point_balance = 0;
			let hostId;
            let playerCount = 0;
			const turtleMap = {
				one: 1,
				two: 2,
				three: 3,
				four: 4,
				five: 5,
				six: 6,
				seven: 7,
				eight: 8
			};

			// 게임방 웹소켓 연결
			function connectGameWebSocket(roomId) {
				if (socket && socket.readyState === WebSocket.OPEN) {
					socket.close(); // 기존 소켓이 있으면 닫고 새로 연결
				}

				const token = localStorage.getItem("accessToken");
				if(!token) {
					alert("로그인이 필요합니다.");
					return;
				}

				socket = new WebSocket(`ws://\${location.host}/ws/game/turtleroom/\${roomId}?token=\${encodeURIComponent(token)}`);

				socket.onopen = () => {};

				socket.onmessage = (event) => {
					const msg = JSON.parse(event.data);

					switch (msg.type) {
						case "enter":
						case "exit":
							if(msg.hostId) {
								hostId = msg.hostId;
							}

							updatePlayerList(msg.players);
							updateButtons();

							showSystemMessage(`\${msg.userId} 님이 \${msg.type == 'enter' ? '입장' : '퇴장'}했습니다.`);
							break;
						case "update":
							updatePlayerList(msg.players);
							break;
						case "start":
							const targetUrl = msg.target;
							window.location.href = targetUrl;
							break;
						default:
							break;
					}
				};

				socket.onclose = (event) => {
					console.log(`웹소켓 종료 - 코드: \${event.code}, 이유: \${event.reason}, wasClean: \${event.wasClean}`);
				};

				socket.onerror = (error) => {
					console.error("웹소켓 에러 발생:", error);
				};

				function showSystemMessage(message) {
					const $chatBox = $("#chat-box");
					const $msg = $(`<span>\${message}</span><br>`);
					$chatBox.append($msg);
				}
			}

			// 사용자 정보 요청
			function userInfo(callback) {
				const token = localStorage.getItem("accessToken");
				if (!token) {
					alert("로그인이 필요합니다.");
					return;
				}

				$.ajax({
					url: '/api/user/me',
					type: 'GET',
					headers: {
						'Authorization': 'Bearer ' + token
					},
					success: function(user) {
						userId = user.uid;
						point_balance = user.point_balance;
						$("#user-point").text(point_balance.toLocaleString());
						callback(userId);
					}
				});
			}

			// 플레이어 정보 요청
			function players(room, roomPlayers) {
				return $.ajax({
					url: `/api/player/detail/\${room.uid}`,
					method: "GET",
					success: function (players) {
						roomPlayers.push(...players);
					}
				});
			}

			// 게임방 상세 정보 요청
			function gameRoomDetail (roomId) {
				$.ajax({
					url: `/api/gameroom/detail/\${roomId}`,
					method: "GET",
					success: function (room) {
						minBet = room.min_bet;
						hostId = room.host_uid;
						level = room.level;

						connectGameWebSocket(roomId);
						updateTurtleButtonsByLevel(level);
						renderGameRoomDetail(room);

						let roomPlayers = [];
						players(room, roomPlayers).done(function() {
							updatePlayerList(roomPlayers);
						});
					}
				});
			};

			// 플레이어 목록 갱신
			function updatePlayerList(players) {
				const $playerList = $("#player-list");
				$playerList.empty(); // 기존 플레이어 목록 초기화

				let isAllReady = true;
                playerCount = players.length;

				players.forEach(player => {
					const turtleId = player.turtle_id ?? 0;
					const isReady = player.ready;
					const isHost = player.user_uid === hostId;
					const nickname = player.nickname;

					const stateColor = isReady ? "text-red-600" : "text-gray-400";
					const labelText = isHost ? "방 장" : "준비 완료";
					const labelColor = isHost ? "text-blue-500" : stateColor;

					const html = `
            <div class="relative aspect-square rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.1)] flex justify-center items-center overflow-hidden p-2 md:p-4">
                <img src="/resources/images/turtle\${turtleId}.png" alt="Turtle Character" class="h-full" />
                <div class="absolute text-gray-7 left-0 top-0 w-20 h-10 md:h-14 flex justify-center items-center font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl">
                    <span>\${nickname}</span>
                </div>
				<div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 bg-white blur rounded-full"></div>
                <div class="absolute left-1/2 bottom-0 -translate-x-1/2 w-20 md:w-32 h-10 md:h-14 flex justify-center items-center font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl \${labelColor}">
                    <span>\${labelText}</span>
                </div>
            </div>
        `;
					$playerList.append(html);

					if(!player.ready && !isHost) {
						isAllReady = false;
					}
				});

				// 게임 시작 버튼 활성화/비활성화
				if (isAllReady) {
					$("#start-game-btn").prop("disabled", false); // 모든 플레이어가 준비되면 버튼 활성화
				} else {
					$("#start-game-btn").prop("disabled", true); // 준비되지 않으면 버튼 비활성화
				}
			}

			// 게임방 상세 정보 렌더링(임시)
			function renderGameRoomDetail(room) {
				$("#room-title").text(`\${room.title}`);
				$("#min-bet").text(room.min_bet.toLocaleString());

				userInfo(function() {
					updateButtons();
				});
			}

			function updateButtons() {
				if(hostId === userId) {
					$("#start-game-btn").show();
					$("#ready-btn").hide();
				} else {
					$("#start-game-btn").hide();
					$("#ready-btn").show();
				}
			}

			function checkOrientation() {
				if (window.innerHeight > window.innerWidth) {
			    	// 세로 모드 → 오버레이 표시
			    	$("#landscapeNotice").removeClass("hidden");
			  	} else {
			    	// 가로 모드 → 오버레이 숨김
			    	$("#landscapeNotice").addClass("hidden");
			  	}
			}

			$(document).ready(function () {
				checkOrientation(); // 최초 실행
			  	$(window).on("resize orientationchange", checkOrientation); // 창 크기나 회전 시 다시 검사
			});

			// 거북이 선택, 포인트 베팅, 준비 상태 변경
			function bindGameEvents() {
				let isReady = false;

				$(".turtle-btn").on("click", function () {
					let selectedTurtle = $(this).data("turtle");

					if (selectedTurtle === "random") {
						// 현재 활성화된 거북이 버튼들 중에서만 랜덤 선택
						const enabledButtons = $(".turtle-btn").not('[data-turtle="random"]').filter(function() {
							return !$(this).prop("disabled");
						});

						if (enabledButtons.length === 0) {
							alert("선택 가능한 거북이가 없습니다.");
							return;
						}

						const randomIndex = Math.floor(Math.random() * enabledButtons.length);
						const randomBtn = enabledButtons.eq(randomIndex);

						// 스타일 업데이트
						$(".turtle-btn").removeClass("border-blue-2").addClass("border-transparent");
						randomBtn.removeClass("border-transparent").addClass("border-blue-2");

						// 선택된 이미지 src 변경
						const imgSrc = randomBtn.find("img").attr("src");
						$("#mainTurtleImage").attr("src", imgSrc);

						// 선택된 turtle 데이터
						selectedTurtle = randomBtn.data("turtle");
					} else {
						$(".turtle-btn").removeClass("border-blue-2").addClass("border-transparent");
						$(this).removeClass("border-transparent").addClass("border-blue-2");

						// 선택된 이미지 src 변경
						const imgSrc = $(this).find("img").attr("src");
						$("#mainTurtleImage").attr("src", imgSrc);
					}

					$("#turtle").val(selectedTurtle);

					const turtleId = turtleMap[selectedTurtle] ?? 0;

					socket.send(JSON.stringify({
						type: "choice",
						turtle_id: turtleId
					}));
				});

				$(document).on('blur', '#bet_point', function() {
				    let point = parseInt($(this).val(), 10);
				    if (isNaN(point) || point <= 0) {
					  $(this).val('');
					  return;
				    }

				    point = Math.floor(point / 100) * 100;
				    $(this).val(point);

				    if (!point || point <= 0) {
					  $("#errorMessage").text('베팅 포인트를 입력하세요.');
					  return;
				    }

					if(point < minBet) {
						$("#errorMessage").text(`최소 베팅은 \${minBet} 포인트 입니다.`);
						return;
					}

					if(point > point_balance) {
						$("#errorMessage").text(`보유 포인트가 부족합니다.`);
						return;
					}

					$("#errorMessage").text('');

					socket.send(JSON.stringify({
						type: "betting",
						betting_point: point
					}));
				});

				$(document).on('click', '#ready-btn', function() {
					const selectedTurtle = $("#turtle").val();
					const point = $('#bet_point').val();

					if(selectedTurtle === "none") {
						alert("거북이를 선택해주세요.");
						return;
					}

					if(point <= 0) {
						alert("포인트를 베팅해주세요.");
						return;
					}

					isReady = !isReady;
					const $btn = $(this);
					$btn.text(isReady ? '준비 완료' : '게임 준비');

                    // 준비 상태일 때 선택 및 입력 비활성화
                    $('.turtle-btn').prop('disabled', isReady);
                    $('#bet_point').prop('disabled', isReady);

					socket.send(JSON.stringify({
						type: "ready",
						isReady: isReady
					}));
				});
			}

			// 게임 시작 버튼 클릭 이벤트
			$("#start-game-btn").click(function () {
				const selectedTurtle = $("#turtle").val();
				const point = $('#bet_point').val();

				if(selectedTurtle === "none") {
					alert("거북이를 선택해주세요.");
					return;
				}

				if(point <= 0) {
					alert("포인트를 베팅해주세요.");
					return;
				}

                if(playerCount < 2) {
                    alert("최소 플레이 인원은 2명입니다.");
                    return;
                }

				$.ajax({
					url: `/api/gameroom/start/${roomId}`,
					method: "POST",
					contentType: "application/json",
					data: JSON.stringify({ status: "PLAYING" }),
					success: function () {
						// 게임 페이지로 리다이렉션
						socket.send(JSON.stringify({
							type: "start"
						}));
					},
					error: function () {
						alert("게임 시작에 실패했습니다.");
					}
				});
			});

			function updateTurtleButtonsByLevel(level) {
				// 각 레벨별 활성화 가능한 turtle 번호 배열 (1~8)
				const levelMap = {
					"EASY": [1, 2, 3, 4],
					"NORMAL": [1, 2, 3, 4, 5, 6],
					"HARD": [1, 2, 3, 4, 5, 6, 7, 8]
				};

				const allowed = levelMap[level] || [];

				$(".turtle-btn").each(function() {
					const turtleName = $(this).data("turtle");

					// "random" 버튼은 항상 활성화 상태로 유지하려면 아래 조건문 추가 가능
					if(turtleName === "random") {
						$(this).prop("disabled", false).removeClass("opacity-40 cursor-not-allowed");
						return;
					}

					// turtleName을 숫자로 바꿔야 비교 가능 (예: "one" → 1)
					const turtleNumMap = {
						one: 1,
						two: 2,
						three: 3,
						four: 4,
						five: 5,
						six: 6,
						seven: 7,
						eight: 8
					};

					const num = turtleNumMap[turtleName] || 0;

					if(allowed.includes(num)) {
						// 활성화
						$(this).prop("disabled", false).removeClass("opacity-40 cursor-not-allowed");
					} else {
						// 비활성화
						$(this).prop("disabled", true).addClass("opacity-40 cursor-not-allowed");
					}
				});
			}
		</script>
		<script>
			const roomId = "${roomId}";
			gameRoomDetail(roomId);
			bindGameEvents();
		</script>
	</jsp:attribute>
</ui:layout>