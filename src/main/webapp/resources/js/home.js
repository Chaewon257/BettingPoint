document.addEventListener("DOMContentLoaded", function () {
	let totalBannerSlides = 0;
	
    fetch('/api/content/banner/list')
        .then(response => response.json())
        .then(data => {
            const container = $('#bannerContainer');
            const indicator = $('#bannerIndicators');
            totalBannerSlides = data.length;

            data.forEach((banner, index) => {
                // 배너 생성
                const bannerDiv = document.createElement('div');
                bannerDiv.className = "flex-none w-full h-full flex items-center justify-center";
               
                bannerDiv.innerHTML = `
                    <a href="${banner.banner_link_url}" class="block w-full h-full">
                		<img src="${banner.image_path}" alt="${banner.title}" class="w-full h-full object-cover" />
                	</a>
                `;
                container.appendChild(bannerDiv);

                // 인디케이터 생성
                const dot = document.createElement('button');
                dot.className = 'banner-dot w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-75 transition-all';
                dot.dataset.slide = index;                
                
                indicator.appendChild(dot);
            });

            // 이후에 슬라이드 관련 스크립트 init 함수 호출 
            // 슬라이더 동작 연결 (기존 코드 재사용)
            bindBannerEvents();
            showBannerSlide(0);
            startBannerAutoSlide();
        })
        .catch(error => console.error("배너 로딩 실패:", error));
});
