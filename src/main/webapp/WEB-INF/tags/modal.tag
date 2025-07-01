<%@ tag language="java" pageEncoding="UTF-8" description="공통 모달"%>

<%@ attribute name="modalId" required="true" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="content" fragment="true" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div id="${modalId}" class="fixed top-0 left-0 px-5 z-50 flex items-center justify-center h-screen w-full bg-black/10 hidden">
    <div class="relative max-h-[90%] p-4 flex flex-col bg-white rounded-xl shadow-[2px_2px_8px_rgba(0,0,0,0.35)]">
        <button class="absolute top-4 right-4 text-sm" onclick="document.getElementById('${modalId}').classList.add('hidden')">
            닫기
        </button>
        <c:if test="${not empty title}">
            <div class="text-lg font-semibold mb-2">${title}</div>
            <div class="h-px w-full bg-gray-1"></div>
        </c:if>
        <jsp:invoke fragment="content" />
    </div>
</div>