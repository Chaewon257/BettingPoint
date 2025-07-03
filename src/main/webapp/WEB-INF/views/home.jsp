<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags"%>

<ui:layout pageName="홈 페이지" pageType="main">
    <jsp:attribute name="headLink">
        <style>
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
                
        </script>
    </jsp:attribute>
</ui:layout>