<%@ tag language="java" pageEncoding="UTF-8"%>

<div id="faq-container" 
	 class="tab-content w-full px-4 flex flex-col mb-20 mt-6 text-xs sm:text-sm"></div>

<script type="text/javascript">	
	function loadFAQList() {
		fetch("/api/support/list/FAQ")
	        .then(response => response.json())
	        .then(data => {
	            const container = document.getElementById("faq-container");
	            container.innerHTML = ""; // 초기화
	
	            data.forEach((faq, index) => {
	                const faqItem = document.createElement("div");
	                faqItem.className = "faq-item w-full md:px-6 border-b mb-6 pb-6";
	
	                faqItem.innerHTML = `
	                    <div class="flex justify-between items-start">
	                        <p class="question-title grow text-gray-800 font-medium text-base sm:text-lg">Q\${index + 1}. \${faq.title}</p>
	                        <button class="faq-toggle focus:outline-none w-6 h-6 flex items-center justify-center shrink-0">
	                            <img class="icon-open w-6 h-6 transition-transform duration-300" src="https://tuk-cdn.s3.amazonaws.com/can-uploader/faq-8-svg2.svg" alt="toggle icon">
	                        </button>
	                    </div>
	                    <div class="faq-content hidden mt-4">
	                        <p class="text-gray-600 text-sm">\${faq.content} </p>
	                    </div>
	                `;
	
	                container.appendChild(faqItem);
	            });
	        })
	        .catch(error => {
	            console.error("FAQ 불러오기 실패:", error);
	        });
	} 
	
	// ✅ 첫 페이지 로드 시 실행
	$(document).ready(function () {
		loadFAQList();
	}); 
</script>

<style>
/* 아이콘 회전 효과를 위한 클래스 */
.rotate-180 {
    transform: rotate(180deg);
}
</style>