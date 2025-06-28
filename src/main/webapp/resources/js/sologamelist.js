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
	            console.log(games);	
	            games.forEach(function(game) {
	                const gameHtml = `
                    <div class="w-40 flex flex-col items-center border rounded-lg p-4 shadow hover:shadow-md transition cursor-pointer"
	                			onclick="location.href='/solo/${game.name}'">
                        <img src="${s3BaseUrl}${game.game_img}" alt="${game.name}" width="200" height="200" class="w-full h-24 object-cover rounded mb-2" />
                        <span class="text-center text-sm font-semibold">${game.name}</span>
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
