<%@ tag language="java" pageEncoding="UTF-8" description="공통 레이아웃"%>
<%@ attribute name="pageName" required="true"%>
<%@ attribute name="bodyContent" fragment="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<html>
<head>
<meta charset="UTF-8">
<title>${pageName}</title>
<link rel="stylesheet" href="${cpath}/resources/css/styles.css">
</head>
<body>
	<header class="header">
	</header>

	<main class="container">
		<jsp:invoke fragment="bodyContent" />
	</main>

	<footer class="footer">
	</footer>
	<script src="${cpath}/resources/js/layout.js"></script>
</body>
</html>
