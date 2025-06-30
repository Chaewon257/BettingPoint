<%@ tag language="java" pageEncoding="UTF-8" description="챗봇 컴포넌트"%>
<%@ attribute name="pageType" required="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.request.contextPath}" />
<c:choose>
	<c:when test="${pageType eq 'main'}">
		<!--  챗봇 버튼 -->
		<button id="chatbotBtn"
			class="fixed top-[75%] right-[30px] transform -translate-y-1/2 z-[1000] bg-white border-none w-[72px] h-[70px] rounded-full cursor-pointer flex items-center justify-center
         shadow-[0_0_12px_rgba(0,0,0,0.3)] transition transform active:scale-90 duration-150 ease-out
         hover:scale-110 hover:shadow-[0_0_20px_rgba(0,0,0,0.4)]">
			<img id="chatbotIcon" src="${cpath}/resources/images/chatbot.png"
				alt="챗봇" class="w-[40px] h-[40px] transition-all duration-200" />
		</button>
		<!-- 챗봇 모달 -->
		<div id="chatbotModal"
			class="hidden fixed bottom-[240px] right-5 w-[350px] h-[450px] bg-gradient-to-br from-white to-[#ffffff]
             rounded-2xl shadow-2xl border border-[#9db8cc] overflow-hidden z-[2000] font-['Segoe_UI']">
			<div
				class="bg-[#A2C8E6] text-[#1f2937] px-4 py-3 font-bold text-[16px] relative">
				1:1 상담 <span id="closeChatbot"
					class="absolute right-4 top-1/2 -translate-y-1/2 text-[20px] cursor-pointer">&times;</span>
			</div>
			<div id="chatbotContent"
				class="p-4 text-sm text-[#333] bg-white h-[calc(100%-56px)] overflow-y-auto">
			</div>
		</div>
		<script>
		$(function () {
			  let isOpen = false;
			  
			  function openChatbot() {
			    isOpen = true;
			    $('#chatbotModal').show();
			    $('#chatbotContent').load('/chatbot');
			    $('#chatbotIcon')
			      .attr('src', '${cpath}/resources/images/close.png')
			      .removeClass('w-[40px] h-[40px]')
			      .addClass('w-[24px] h-[24px]'); 
			  }
			  
			  function closeChatbot() {
			    isOpen = false;
			    $('#chatbotModal').hide();
			    $('#chatbotIcon')
			      .attr('src', '${cpath}/resources/images/chatbot.png')
			      .removeClass('w-[24px] h-[24px]')
			      .addClass('w-[40px] h-[40px]'); 
			  }
			  
			  $('#chatbotBtn').on('click', function () {
			    isOpen ? closeChatbot() : openChatbot();
			  });
			  
			  $('#closeChatbot').on('click', function () {
			    closeChatbot();
			  });
			});
		</script>
	</c:when>
</c:choose>