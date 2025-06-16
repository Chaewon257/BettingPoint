<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>챗봇 질문</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
	    const cpath = "${pageContext.request.contextPath}";
	</script>
    <script src="${cpath}/resources/js/chatbot.js"></script>
</head>
<body>
    <h2>🤖 반갑습니다. 아래 질문을 선택해주세요.</h2>
    <select id="categorySelect">
		<option value="game">게임</option>
		<option value="point">포인트</option>
		<option value="etc">기타</option>
	</select>
	<button id="questionAll">전체조회</button>
	
    <ul id="categoryList"></ul>
    
    <hr>
    <div id="answerBox">
        <h3>답변</h3>
        <p id="answerText">선택한 질문의 답변이 여기에 표시됩니다.</p>
    </div>

</body>
</html>
