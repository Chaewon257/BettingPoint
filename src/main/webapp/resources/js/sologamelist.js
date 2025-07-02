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
	                	<div class="bg-gray-4 rounded-lg p-2.5 md:p-4 flex items-center gap-x-4 hover:shadow-[2px_2px_8px_rgba(0,0,0,0.2)]" onclick="location.href='/solo/${game.name}'">
    						<div class="w-28 md:w-36 aspect-square overflow-hidden rounded flex items-center justify-center flex-shrink-0">
                        		<img src="${s3BaseUrl}${game.game_img}" alt="${game.name}" class="w-full rounded" />
                        	</div>
                        	<div class="h-full flex flex-col items-start py-2 justify-between">
                        		<span class="flex items-center text-ts-14 sm:text-ts-18 md:text-ts-20 lg:text-ts-24">${game.name}</span>
                        		<span class="line-clamp-2 font-light text-xs sm:text-sm md:text-base">${game.description}</span>
                        	</div>
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
