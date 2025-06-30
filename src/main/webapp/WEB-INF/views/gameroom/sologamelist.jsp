<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개인 게임 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${cpath}/resources/js/sologamelist.js"></script>
</head>
<body>
	<h1>🎰 개인 게임 리스트</h1>
	<div id="soloGameList" class="flex flex-wrap gap-4 p-4"></div>
</body>
</html>