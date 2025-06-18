<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시판 목록</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
	    const cpath = "${pageContext.request.contextPath}";
	</script>
  <script src="${cpath}/resources/js/board.js"></script>

</head>
<body>
  <h1>게시판 목록</h1>
  <ul id="boardList"></ul>
  
 <button>테스트 게시글 추가</button>
 
  
</body>
</html>
