<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃 풋터"%>

<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<c:choose>
	<c:when test="${pageType eq 'main'}">
		<footer class="bg-gray-3 text-white text-center py-10">
			<div class="my-0 mx-auto">
				<p>&copy; 2025 Betting Point. All rights reserved.</p>
			</div>
		</footer>
		<script src="${cpath}/resources/js/layout.js"></script>
	</c:when>
</c:choose>
