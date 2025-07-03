<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

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
        </style>
    </jsp:attribute>

    <jsp:attribute name="bodyContent">
        <div class="grow flex flex-col items-center gap-y-4">
            <div class="w-full lg:grid lg:grid-cols-5">
                <!-- 배너 슬라이더 섹션 -->
                <div class="relative col-span-4 w-full h-56 md:h-96 overflow-hidden">
                    <div id="bannerContainer" class="flex w-full h-full banner-slide">
                        <!-- 배너 1 -->
                        <div class="flex-none w-full h-full bg-gradient-to-r from-blue-500 to-purple-600 flex items-center justify-center">
                            <div class="text-center text-white">
                                <h2 class="text-4xl font-bold mb-4">첫 번째 배너</h2>
                                <p class="text-xl">멋진 콘텐츠를 만나보세요</p>
                            </div>
                        </div>
                        <!-- 배너 2 -->
                        <div class="flex-none w-full h-full bg-gradient-to-r from-green-500 to-teal-600 flex items-center justify-center">
                            <div class="text-center text-white">
                                <h2 class="text-4xl font-bold mb-4">두 번째 배너</h2>
                                <p class="text-xl">새로운 경험을 시작하세요</p>
                            </div>
                        </div>
                        <!-- 배너 3 -->
                        <div class="flex-none w-full h-full bg-gradient-to-r from-orange-500 to-red-600 flex items-center justify-center">
                            <div class="text-center text-white">
                                <h2 class="text-4xl font-bold mb-4">세 번째 배너</h2>
                                <p class="text-xl">특별한 혜택을 놓치지 마세요</p>
                            </div>
                        </div>
                        <!-- 배너 4 -->
                        <div class="flex-none w-full h-full bg-gradient-to-r from-pink-500 to-rose-600 flex items-center justify-center">
                            <div class="text-center text-white">
                                <h2 class="text-4xl font-bold mb-4">네 번째 배너</h2>
                                <p class="text-xl">지금 바로 참여해보세요</p>
                            </div>
                        </div>
                    </div>

                    <!-- 배너 인디케이터 -->
                    <div class="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2">
                        <button class="banner-dot w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-75 transition-all" data-slide="0"></button>
                        <button class="banner-dot w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-75 transition-all" data-slide="1"></button>
                        <button class="banner-dot w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-75 transition-all" data-slide="2"></button>
                        <button class="banner-dot w-3 h-3 rounded-full bg-white bg-opacity-50 hover:bg-opacity-75 transition-all" data-slide="3"></button>
                    </div>

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
		        <div id="cardContainer" class="flex gap-6 overflow-x-auto scrollbar-custom card-container pb-4">
		            <!-- 카드 1 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 1</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		
		            <!-- 카드 2 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 2</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		
		            <!-- 카드 3 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 3</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		
		            <!-- 카드 4 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 4</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		
		            <!-- 카드 5 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 5</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		
		            <!-- 카드 6 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 6</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		
		            <!-- 카드 7 -->
		            <div class="flex-none w-72 bg-white rounded-lg shadow-sm border border-gray-200 p-4">
		                <div class="w-full h-40 bg-gray-300 rounded-lg mb-4"></div>
		                <h3 class="text-lg font-semibold text-gray-900 mb-2">게임영상 7</h3>
		                <p class="truncate text-sm text-gray-600 leading-relaxed">
		                    동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한...
		                </p>
		            </div>
		        </div>
		    </div>
		<script type="text/javascript">
            $(document).ready(function() {
                // 배너 슬라이더 변수
                let currentBannerSlide = 0;
                const totalBannerSlides = 4;
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

                $('.banner-dot').click(function() {
                    stopBannerAutoSlide();
                    const slideIndex = parseInt($(this).data('slide'));
                    showBannerSlide(slideIndex);
                    startBannerAutoSlide();
                });

                $('#bannerContainer').parent().hover(
                    function() { stopBannerAutoSlide(); },
                    function() { startBannerAutoSlide(); }
                );

                showBannerSlide(0);
                startBannerAutoSlide();
                
                function adjustWidth() {
                	const screenWidth = $(window).width() - 32;
                	$("#mainContainer").css("max-width", `\${screenWidth}px`);
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
                
                // 사용자 로그인 여부 확인
                let token = localStorage.getItem('accessToken');
                
                function renderUser(user) {
        			if (!user || !user.user_name) return;

        			// PC
        			$('#userInfoPanel').html(`
        					<div class="w-36 h-36 rounded-full bg-white overflow-hidden">
        						<img id="profileImage" alt="default profile image" src="\${user.profile_img || "/resources/images/profile_default_image.png"}">
        					</div>
                            <div class="text-base"><a href="/mypage" class="hover:underline font-semibold">\${user.nickname}</a> 님,환영합니다!</div>
                            <div class="w-full flex flex-col item-start bg-blue-3 rounded-lg p-2">
                            	<div class="font-bold mb-2">보유포인트</div>
                            	<div class="w-full flex items-center justify-between text-gray-700 font-extrabold text-2xl px-2 mb-2">
                            		<img alt="money box" src="${cpath}/resources/images/money_box.png" class="w-8">
                            		<div id="pointBalance" class="grow text-center">\${user.point_balance}</div>
                            		<div>P</div>
                            	</div>
        						<button onclick="location.href='/'" class="w-full rounded text-white bg-blue-2 hover:bg-blue-1 py-1">충전하기</button>
                            </div>
        					
        				`);
        		}
                
             	// 유저 정보 요청
        		function getUserInfo() {
        			return $.ajax({
        				url: '/api/user/me',
        				method: 'GET',
        				xhrFields: { withCredentials: true }
        			});
        		}
             	
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
        </script>
    </jsp:attribute>
</ui:layout>