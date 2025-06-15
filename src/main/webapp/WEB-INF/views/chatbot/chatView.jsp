<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챗봇 시작</title>
<script>
		function showAnswer(uid) {
			const answerText = document.getElementById("answer_" + uid).value;
			document.getElementById("answerDisplay").innerText = answerText;
		}
	</script>
</head>
<body>
	<h2>${message}</h2>
	<h3>🧾 질문 목록</h3>
    <ul>
        <c:forEach var="q" items="${questions}">
            <li style="cursor:pointer;" onclick="showAnswer('${q.uid}')">
			${q.question_text}
			<input type="hidden" id="answer_${q.uid}" value="${q.answer_text}" />
		</li>
        </c:forEach>
    </ul>
    
    <hr>
	<h4>💬 답변:</h4>
	<div id="answerDisplay" style="border:1px solid #ccc; padding:10px; min-height:50px;"></div>
    
</body>
</html>