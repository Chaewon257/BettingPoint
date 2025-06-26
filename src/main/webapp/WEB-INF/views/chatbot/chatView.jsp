<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />
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
    
    <style>
	    .main-btn, .sub-btn {
	        margin: 5px;
	        padding: 8px 14px;
	        border: 1px solid #ccc;
	        background-color: #f5f5f5;
	        cursor: pointer;
	    }
	    .active {
	        background-color: #007bff;
	        color: white;
	    }
	    
	    .question.active {
		    color: #fff;
		    background-color: #007bff;
		    padding: 4px 8px;
		    border-radius: 5px;
		    text-decoration: none;
		}
	    
	</style>
</head>
<body>
    <h2>🤖 반갑습니다. 아래 질문을 선택해주세요.</h2>
    
    <!-- 메인 카테고리 선택 -->
    <label for="mainCategory">카테고리:</label>
    <div id="mainCategoryButtons">
	    <button class="main-btn" id="questionAll">전체조회</button>
	    <button class="main-btn" data-main="GAME">게임</button>
	    <button class="main-btn" data-main="POINT">포인트</button>
	    <button class="main-btn" data-main="ETC">기타</button>
	</div>
	
    
	<!-- 서브 카테고리 버튼 -->	
    <label for="subCategory">세부 항목:</label>
	<div id="subCategoryButtons" style="margin-top: 10px;"></div>

    
    <!-- 질문 목록 -->
	<ul id="questionList" style="margin-top: 10px;"></ul>
	
	<!-- 답변 -->
	<div id="answerBox" style="margin-top: 20px;">
	    <h4>답변</h4>
	    <p id="answerText">선택한 질문의 답변이 여기에 표시됩니다.</p>
	</div>

</body>
</html>
