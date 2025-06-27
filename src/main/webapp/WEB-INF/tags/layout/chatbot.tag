<%@ tag language="java" pageEncoding="UTF-8" description="챗봇 컴포넌트"%>
<%@ attribute name="pageType" required="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.request.contextPath}" />

<c:choose>
	<c:when test="${pageType eq 'main'}">

		<!--  챗봇 버튼 -->
		<button id="chatbotBtn"
			class="fixed top-[75%] right-[30px] transform -translate-y-1/2 z-[1000] bg-white border-none px-6 py-5 rounded-full cursor-pointer
         shadow-[0_0_12px_rgba(0,0,0,0.3)] transition transform active:scale-90 duration-150 ease-out
         hover:scale-110 hover:shadow-[0_0_20px_rgba(0,0,0,0.4)]">

			<img id="chatbotIcon" src="${cpath}/resources/images/chatbot.png"
				alt="챗봇" class="w-[30px] h-[30px]" />
		</button>

		<!-- 챗봇 모달 -->
		<div id="chatbotModal"
			class="hidden fixed bottom-[210px] right-5 w-[350px] h-[450px] bg-gradient-to-br from-white to-[#ffffff]
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
        .addClass('p-[7px] box-border');
    }

    function closeChatbot() {
      isOpen = false;
      $('#chatbotModal').hide();
      $('#chatbotIcon')
        .attr('src', '${cpath}/resources/images/chatbot.png')
        .removeClass('p-[7px] box-border');
    }

    $('#chatbotBtn').on('click', function () {
      isOpen ? closeChatbot() : openChatbot();
    });

    $('#closeChatbot').on('click', function () {
      closeChatbot();
    });

    // 👉 드래그 제어 변수들
    let draggingBtn = false;
    let isDraggingNow = false;
    let offsetXBtn = 0, offsetYBtn = 0;

    $('#chatbotBtn').on('mousedown', function (e) {
      draggingBtn = true;
      isDraggingNow = false;

      const offset = $(this).offset();
      offsetXBtn = e.pageX - offset.left;
      offsetYBtn = e.pageY - offset.top;
      e.preventDefault();
    });

    $(document).on('mousemove', function (e) {
      if (!draggingBtn) return;

      const $btn = $('#chatbotBtn');
      const currentOffset = $btn.offset();
      const moveX = e.pageX - offsetXBtn;
      const moveY = e.pageY - offsetYBtn;

      const dx = Math.abs(moveX - currentOffset.left);
      const dy = Math.abs(moveY - currentOffset.top);

      // ✅ 실제 드래그일 때만 위치 전환
      if (!isDraggingNow && (dx > 3 || dy > 3)) {
        isDraggingNow = true;

        $btn.css({
          left: currentOffset.left,
          top: currentOffset.top,
          right: 'auto',
          bottom: 'auto'
        });
      }

      if (isDraggingNow) {
        const winW = $(window).width();
        const winH = $(window).height();
        const btnW = $btn.outerWidth();
        const btnH = $btn.outerHeight();

        let left = moveX;
        let top = moveY;

        left = Math.max(0, Math.min(winW - btnW, left));
        top = Math.max(0, Math.min(winH - btnH, top));

        $btn.css({
          top: top + 'px',
          left: left + 'px'
        });
      }
    });

    $(document).on('mouseup', function () {
      draggingBtn = false;
      isDraggingNow = false;
    });
  });
</script>

	</c:when>
</c:choose>
