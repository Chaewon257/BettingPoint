<%@ tag language="java" pageEncoding="UTF-8"%>

<div data-content="free" class="tab-content w-full px-4 flex flex-col mb-20 mt-6 text-xs sm:text-sm">
	<!-- 질문 1 -->
    <div class="faq-item w-full md:px-6 border-b mb-6 pb-6">
       	<div class="flex justify-between items-start">
    		<p class="grow text-gray-800 font-medium text-base sm:text-lg">Q1. How do I know if a product is available in boutiques?</p>
    		<button class="faq-toggle focus:outline-none w-6 h-6 flex items-center justify-center shrink-0">
       	 		<img class="icon-open w-6 h-6 transition-transform duration-300" src="https://tuk-cdn.s3.amazonaws.com/can-uploader/faq-8-svg2.svg" alt="toggle icon">
    		</button>
		</div>
        <div class="faq-content hidden mt-4">
            <p class="text-gray-600 text-sm">Remember you can query the status of your orders any time in My orders in the My account section. If you are not registered at Mango.com, you can access directly in the Orders section. In this case, you will have to enter your email address and order number.</p>
        </div>
    </div>

    <!-- Question 2 -->
    <div class="faq-item w-full md:px-6 border-b mb-6 pb-6">
       	<div class="flex justify-between items-start">
            <p class="grow text-gray-800 font-medium text-base sm:text-lg">Q2. How can I find the prices or get other information about Chanel products?</p>
    		<button class="faq-toggle focus:outline-none w-6 h-6 flex items-center justify-center shrink-0">
                <img class="icon-open transition-transform duration-300" src="https://tuk-cdn.s3.amazonaws.com/can-uploader/faq-8-svg2.svg" alt="toggle icon">
            </button>
        </div>
        <div class="faq-content hidden mt-4">
            <p class="text-gray-600 text-sm">Remember you can query the status of your orders any time in My orders in the My account section. If you are not registered at Mango.com, you can access directly in the Orders section. In this case, you will have to enter your email address and order number.</p>
        </div>
    </div>

</div>

<!-- jQuery 스크립트 -->
<script>
$(document).ready(function () {
    $(".faq-toggle").on("click", function () {
        const $faqItem = $(this).closest(".faq-item");
        const $content = $faqItem.find(".faq-content");
        const $question = $faqItem.find("p");
        const $icon = $(this).find(".icon-open");

        // 내용 slide toggle
        $content.stop(true, true).slideToggle(300);

        // 질문 강조 토글
        $question.toggleClass("font-semibold");

        // 아이콘 회전
        $icon.toggleClass("rotate-180");
    });
});
</script>

<style>
/* 아이콘 회전 효과를 위한 클래스 */
.rotate-180 {
    transform: rotate(180deg);
}
</style>