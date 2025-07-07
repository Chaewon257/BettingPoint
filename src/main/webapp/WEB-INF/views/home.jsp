<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<script src="https://js.tosspayments.com/v2/standard"></script>
<ui:layout pageName="홈 페이지" pageType="main">
    <jsp:attribute name="headLink">
        <style>
            .scrollbar-custom::-webkit-scrollbar {
                height: 8px;
            }
            .scrollbar-custom::-webkit-scrollbar-track {
                background: #e5e7eb;
                border-radius: 4px;
            }
            .scrollbar-custom::-webkit-scrollbar-thumb {
                background: #3b82f6;
                border-radius: 4px;
            }
            .scrollbar-custom::-webkit-scrollbar-thumb:hover {
                background: #2563eb;
            }
            .banner-slide {
                transition: transform 0.5s ease-in-out;
            }
        }
        </style>
    </jsp:attribute>

    <jsp:attribute name="bodyContent">
        <div class="grow flex flex-col items-center gap-y-4">
            <div class="w-full lg:grid lg:grid-cols-5">
                <!-- 배너 슬라이더 섹션 -->
                <div class="relative col-span-4 w-full h-56 md:h-96 overflow-hidden">
                	<!-- 배너 영역 -->
                    <div id="bannerContainer" class="flex w-full h-full banner-slide"></div>

                    <!-- 배너 인디케이터 -->
                    <div id="bannerIndicators" class="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2"></div>

                    <!-- 배너 화살표 버튼 -->
                    <button id="bannerPrev" class="absolute left-4 top-1/2 transform -translate-y-1/2 w-10 h-10 rounded-full bg-white bg-opacity-20 hover:bg-opacity-30 flex items-center justify-center transition-all">
                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                        </svg>
                    </button>
                    <button id="bannerNext" class="absolute right-4 top-1/2 transform -translate-y-1/2 w-10 h-10 rounded-full bg-white bg-opacity-20 hover:bg-opacity-30 flex items-center justify-center transition-all">
                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </button>
                </div>

                <div id="userInfoPanel" class="hidden lg:flex bg-gray-8 flex flex-col items-center justify-center gap-y-4 px-4 py-6">
                    <div class="grow flex flex-col items-center justify-center">
                        <div class="text-3xl font-extrabold text-blue-5 mb-2 text-center">Betting Point</div>
                        <div class="text-base font-bold mb-0.5">포인트로 즐기는 짜릿한 한 판!</div>
                        <div class="font-light text-gray-7">포인트를 모아 한층 더 큰 즐거움을 경험하세요.</div>
                    </div>
                    <button onclick="location.href='/login'" class="w-full py-2 outline-none bg-blue-2 rounded-full border border-blue-2 text-white text-lg hover:bg-blue-1">로그인</button>
                    <button onclick="location.href='/register'" class="w-full py-2 outline-none bg-blue-3 rounded-full border border-blue-3 text-white text-lg hover:bg-blue-1">회원가입</button>
                </div>
            </div>
            <div id="mainContainer" class="mx-auto mb-4">
		        <!-- 헤더 섹션 -->
		        <div class="flex items-center justify-between mb-6">
		            <h1 class="text-2xl font-bold text-gray-900">베튜브</h1>
		            <div class="flex gap-2">
		                <button id="prevBtn" class="w-10 h-10 rounded-full border border-gray-300 bg-white flex items-center justify-center hover:bg-gray-50 transition-colors">
		                    <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
		                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
		                    </svg>
		                </button>
		                <button id="nextBtn" class="w-10 h-10 rounded-full border border-gray-300 bg-white flex items-center justify-center hover:bg-gray-50 transition-colors">
		                    <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
		                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
		                    </svg>
		                </button>
		            </div>
		        </div>
		
		        <!-- 카드 컨테이너 -->
		        <div id="cardContainer" class="flex gap-6 overflow-x-auto scrollbar-custom card-container pb-4"></div>
		    </div>
		    <div class="w-full grid grid-cols-1 gap-y-8 md:grid-cols-2 items-center md:gap-x-10 px-4 mb-6">
		    	<div class="w-full grid grid-cols-2 grid-rows-4 gap-2 my-auto">
		    		<div class="col-span-2 row-span-2 overflow-hidden rounded">
		    			<img alt="main image" src="${cpath}/resources/images/main-page.png">
		    		</div>
		    		<button onclick="location.href='/solo/CoinToss'" class="w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4 disabled:bg-blue-2 disabled:opacity-60 disabled:cursor-not-allowed">
						Coin Toss[개인]
					</button>
		    		<button onclick="location.href='/gameroom'" class="w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4 disabled:bg-blue-2 disabled:opacity-60 disabled:cursor-not-allowed">
						Multi Game
					</button>
		    		<button onclick="location.href='/solo/TreasureHunt'" class="w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4 disabled:bg-blue-2 disabled:opacity-60 disabled:cursor-not-allowed">
						Treasure Hunt[개인]
					</button>
		    		<button onclick="location.href='/gameroom'" class="w-full bg-blue-3 hover:bg-blue-1 rounded-lg text-white shadow-[2px_2px_8px_rgba(0,0,0,0.1)] font-extrabold sm:text-base md:text-lg lg:text-xl xl:text-2xl py-2 md:py-4 disabled:bg-blue-2 disabled:opacity-60 disabled:cursor-not-allowed">
						Turtle Run[단체]
					</button>
		    	</div>
		    	<div class="w-full flex flex-col">
		    		<h1 class="text-2xl font-bold text-gray-900 mb-4">공지사항</h1>
		    		<div class="w-full h-[2px] bg-gray-1"></div>
		    		<div id="TopNoticeContainer" class="grid grid-cols-1 grid-rows-5 border-b-2 border-gray-1"></div>
		    	</div>
		    </div>
        </div>
        <ui:paymentModal modalId="chargePointModal"></ui:paymentModal>
		<script type="text/javascript">
            $(document).ready(function() {
                // 배너 슬라이더 변수
                let currentBannerSlide = 0;
            	let totalBannerSlides = 0;
                let bannerInterval;
               
                function showBannerSlide(index) {
                    const container = $('#bannerContainer');
                    container.css('transform', `translateX(-\${index * 100}%)`);
                    $('.banner-dot').removeClass('bg-opacity-100').addClass('bg-opacity-50');
                    $(`.banner-dot[data-slide="${index}"]`).removeClass('bg-opacity-50').addClass('bg-opacity-100');
                    currentBannerSlide = index;
                }

                function nextBannerSlide() {
                    const nextIndex = (currentBannerSlide + 1) % totalBannerSlides;
                    showBannerSlide(nextIndex);
                }

                function prevBannerSlide() {
                    const prevIndex = (currentBannerSlide - 1 + totalBannerSlides) % totalBannerSlides;
                    showBannerSlide(prevIndex);
                }

                function startBannerAutoSlide() {
                    bannerInterval = setInterval(nextBannerSlide, 5000);
                }

                function stopBannerAutoSlide() {
                    clearInterval(bannerInterval);
                }

                function bindBannerEvents() {
                    $('#bannerNext').click(function() {
                        stopBannerAutoSlide();
                        nextBannerSlide();
                        startBannerAutoSlide();
                    });

                    $('#bannerPrev').click(function() {
                        stopBannerAutoSlide();
                        prevBannerSlide();
                        startBannerAutoSlide();
                    });

                    $(document).on('click', '.banner-dot', function () {
                        stopBannerAutoSlide();
                        const slideIndex = parseInt($(this).data('slide'));
                        showBannerSlide(slideIndex);
                        startBannerAutoSlide();
                    });

                    $('#bannerContainer').parent().hover(
                        function() { stopBannerAutoSlide(); },
                        function() { startBannerAutoSlide(); }
                    );
                }
               	
				fetch('/api/content/banner/list')
				    .then(response => response.json())
				    .then(data => {
				        const container = $('#bannerContainer');
				        const indicator = $('#bannerIndicators');
				        totalBannerSlides = data.length;
				
				        data.forEach((banner, index) => {
				        	container.append(`
		                        <div class="flex-none w-full h-full">
		                            <a href="\${banner.banner_link_url}" class="block w-full h-full">
		                                <img src="\${banner.image_path}" alt="\${banner.title}" class="w-full h-full object-cover" />
		                            </a>
		                        </div>
		                    `);

		                    indicator.append(`
		                        <button class="banner-dot w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-75 transition-all" data-slide="\${index}"></button>
		                    `);
				        });
				
				        // 이후에 슬라이드 관련 스크립트 init 함수 호출 
				        // 슬라이더 동작 연결 (기존 코드 재사용)
				        bindBannerEvents();
				        showBannerSlide(0);
				        startBannerAutoSlide();
				    })
				    .catch(error => console.error("배너 로딩 실패:", error));
				
				// 베튜브 리스트
				fetch('/api/content/bettube/list')
		            .then(response => response.json())
		            .then(data => {
		                const container = $('#cardContainer');
		                container.empty(); // 기존 카드 제거
	
		                data.forEach(item => {
		                    const videoId = extractYouTubeId(item.bettube_url);
		                    if (!videoId) return;
	
		                    const card = `
		                    	<a href="https://www.youtube.com/watch?v=\${videoId}" target="_blank" rel="noopener noreferrer">
			                        <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
			                            <div class="w-full h-40 rounded-lg mb-4 overflow-hidden">
			                                <img src="https://img.youtube.com/vi/\${videoId}/hqdefault.jpg"
				                                 alt="\${item.title}" class="w-full h-full object-cover" />
			                            </div>
			                            <h3 class="text-lg font-semibold text-gray-900 mb-2">\${item.title}</h3>
			                            <p class="truncate text-sm text-gray-600 leading-relaxed">\${item.description}</p>
			                        </div>
		                        </a>
		                    `;
		                    container.append(card);
		                });
		            })
		            .catch(error => console.error('Bettube 로딩 실패:', error));
					
                function adjustWidth() {
                	const screenWidth = $(window).width() - 32;
                	$("#mainContainer").css("max-width", `\${screenWidth}px`);
                	$("#mainContainer").css("width", `\${screenWidth}px`);
                }

                // 처음 실행
                adjustWidth();

                // 리사이즈 시 다시 적용
                $(window).resize(function() {
                    adjustWidth();
                });

                const container = $('#cardContainer');
                const cardWidth = 288 + 24; // 카드 너비 (w-72 = 288px) + gap (gap-6 = 24px)
                
                // 이전 버튼 클릭
                $('#prevBtn').click(function() {
                    const currentScroll = container.scrollLeft();
                    container.animate({
                        scrollLeft: currentScroll - cardWidth * 2
                    }, 300);
                });
                
                // 다음 버튼 클릭
                $('#nextBtn').click(function() {
                    const currentScroll = container.scrollLeft();
                    container.animate({
                        scrollLeft: currentScroll + cardWidth * 2
                    }, 300);
                });
                
                // 스크롤 위치에 따른 버튼 상태 업데이트
                container.on('scroll', function() {
                    const scrollLeft = $(this).scrollLeft();
                    const maxScroll = $(this)[0].scrollWidth - $(this).outerWidth();
                    
                    // 이전 버튼 상태
                    if (scrollLeft <= 0) {
                        $('#prevBtn').addClass('opacity-50 cursor-not-allowed');
                    } else {
                        $('#prevBtn').removeClass('opacity-50 cursor-not-allowed');
                    }
                    
                    // 다음 버튼 상태
                    if (scrollLeft >= maxScroll) {
                        $('#nextBtn').addClass('opacity-50 cursor-not-allowed');
                    } else {
                        $('#nextBtn').removeClass('opacity-50 cursor-not-allowed');
                    }
                });
                
                // 초기 버튼 상태 설정
                container.trigger('scroll');
                
                
                const topNoticeContainer = $("#TopNoticeContainer");
                
             	// 공지 5개만 로딩
                $.ajax({
                    url: `/api/support/list/NOTICE?page=1`,
                    method: 'GET',
                    success: function (res) {
                        const notices = res.notices || res;
                        const top5 = notices.slice(0, 5); // 최대 5개

                        if (!top5 || top5.length === 0) {
                            topNoticeContainer.html(`<div class="text-center text-gray-500 py-6">공지사항이 없습니다.</div>`);
                            return;
                        }

                        top5.forEach(notice => {
                            const date = formatDate(notice.created_at);
                            const html = `
                                <div class="p-4 flex items-center justify-between border-b border-gray-1 font-light">
                                    <button data-notice="\${notice.uid}" class="col-span-4 truncate hover:underline text-left">
                                        \${notice.title}
                                    </button>
                                    <span class="col-span-1">\${date}</span>
                                </div>
                            `;
                            topNoticeContainer.append(html);
                        });
                    },
                    error: function () {
                        topNoticeContainer.html(`<div class="text-center text-red-500 py-6">공지사항을 불러오는 데 실패했습니다.</div>`);
                    }
                });
             	
             	// 날짜 포맷 함수
                function formatDate(dateStr) {
                    if (!dateStr) return "-";
                    const date = new Date(dateStr);
                    if (isNaN(date)) return "-";
                    return date.toLocaleDateString('ko-KR').replace(/\s/g, '').replace(/\.$/, '');
                }
             	
                $(document).on('click', '[data-notice]', function () {
                    const uid = $(this).data('notice');
                    location.href = `/support?uid=\${uid}`;
                });

                
                // 사용자 로그인 여부 확인
                let token = localStorage.getItem('accessToken');
                
             	// 유저 정보 요청
        		function getUserInfo() {
        			return $.ajax({
        				url: '/api/user/me',
        				method: 'GET',
        				xhrFields: { withCredentials: true }
        			});
        		}
             	
                
                function renderUser(user) {
        			if (!user || !user.user_name) return;

        			// PC
        			$('#userInfoPanel').html(`
        					<div class="w-36 h-36 rounded-full bg-white overflow-hidden">
        						<img id="profileImage" alt="default profile image" src="\${user.profile_img || "/resources/images/profile_default_image.png"}">
        					</div>
                            <div class="text-base">
                            	<a href="/mypage" class="hover:underline font-semibold">\${user.nickname}</a> 님,환영합니다!
                           	</div>
                            <div class="w-full flex flex-col item-start bg-blue-3 rounded-lg p-2">
                            	<div class="font-bold mb-2">보유포인트</div>
                            	<div class="w-full flex items-center justify-between text-gray-700 font-extrabold text-2xl px-2 mb-2">
                            		<img alt="money box" src="${cpath}/resources/images/money_box.png" class="w-8">
                            		<div id="pointBalance" class="grow text-center">\${user.point_balance.toLocaleString()}</div>
                            		<div>P</div>
                            	</div>
        						<button onclick="document.getElementById('chargePointModal').classList.remove('hidden')" 
        								class="w-full rounded text-white bg-blue-2 hover:bg-blue-1 py-1">충전하기</button>
                            </div>
        					
        				`);
        		}
                
             	// 충전 모달 관찰자 설정:
                const chargeModal = document.getElementById('chargePointModal');
                const chargeObserver = new MutationObserver((mutations) => {
                  for (const m of mutations) {
                    if (m.type === 'attributes' && m.attributeName === 'class') {
                      if ($(chargeModal).hasClass('hidden')) {
                    	// hidden 클래스가 붙으면(모달 닫힘) 유저 정보 다시 불러오기
                        getUserInfo().done(renderUser);
                      }
                    }
                  }
                });
                chargeObserver.observe(chargeModal, { attributes: true });
                             	
        		// 페이지 진입 시 유저 정보 로딩
        		if (token) {
        			getUserInfo()
        				.done(renderUser)
        				.fail(xhr => {
        					console.warn('⚠️ 사용자 정보 요청 실패', xhr);
        					if (xhr.status === 401) {
        						localStorage.removeItem("accessToken");
        					}
        				});
        		}
        		
        		
            });
            
         	// 유튜브 ID 추출 함수
            function extractYouTubeId(url) {
                try {
                    const urlObj = new URL(url);
                    const hostname = urlObj.hostname;

                    if (hostname.includes('youtu.be')) {
                        return urlObj.pathname.slice(1);
                    } else if (hostname.includes('youtube.com')) {
                        const params = new URLSearchParams(urlObj.search);
                        return params.get('v');
                    }
                } catch (e) {
                    return null;
                }
                return null;
            }
        </script>
        <ui:chatbot></ui:chatbot>
    </jsp:attribute>
</ui:layout>