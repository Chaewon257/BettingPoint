	// 개인 게임 리스트 렌더링
	function loadSoloGames() {
	    $.ajax({
	        url: `/api/game/list/type`,
	        type: 'GET',
	        data: { type: "SINGLE" },
	        success: function(games) {
	            const container = $('#soloGameList');
	            container.empty();
	            
	            const s3BaseUrl = "https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/";
	            games.forEach(function(game) {
	                const gameHtml = `
						<div class="aspect-[6/7] bg-gray-4 rounded-lg p-2.5 md:p-4 flex flex-col items-center justify-between hover:shadow-[2px_2px_8px_rgba(0,0,0,0.2)]" onclick="location.href='/solo/${game.name}'">
	                		<div class="aspect-square w-full overflow-hidden">
                        		<img src="${s3BaseUrl}${game.game_img}" alt="${game.name}" class="w-full rounded" />
                        	</div>
                        	<span class="grow flex items-center text-2xl font-extrabold">${game.name}</span>
                    	</div>
                `;
	                container.append(gameHtml);
	            });
	        },
	        error: function() {
	            alert("게임 리스트를 불러오는 데 실패했습니다.");
	        }
	    });
	}
	
	// 페이지 로드시 실행
	$(document).ready(function () {
	    loadSoloGames();
	});
