<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃"%>

<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout"%>

<%@ attribute name="pageName" required="true"%>
<%@ attribute name="bodyContent" fragment="true"%>
<%@ attribute name="pageType" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<html>
<head>
<meta charset="UTF-8">
<title>${pageName}</title>
<link rel="stylesheet" href="${cpath}/resources/css/styles.css">
<script src="https://cdn.tailwindcss.com"></script>
<script type="text/javascript">
	tailwind.config = {
		theme : {
			extend : {
				colors : {
					'gray-1' : '#D8D8D8',
					'gray-2' : '#E7E5E4',
					'blue-1' : '#4A90E2',
				},
				fontSize : {
					'ts-28' : [
						'1.75rem',
						{
							ineHeight: '100%',
		  					fontWeight: '800'
						}
					] 
				}
			}
		}
	}
</script>
</head>
<body>
	<layout:header pageType="${pageType}" />
	
	<main class="main-container">
		<jsp:invoke fragment="bodyContent" />
	</main>
	
	<c:choose>
		<c:when test="${pageType eq 'main'}">
			<footer class="footer">
				<div class="container">
					<p>&copy; 2025 Betting Point. All rights reserved.</p>
				</div>
			</footer>
			<script src="${cpath}/resources/js/layout.js"></script>
		</c:when>
	</c:choose>
</body>
</html>
