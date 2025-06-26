<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>게시글 등록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- summernote -->
<script src="${cpath}/resources/js/summernote/summernote-lite.js"></script>
<link rel="stylesheet"
	href="${cpath}/resources/css/summernote/summernote-lite.css">

<script>
	const cpath = "${cpath}";
</script>
<script src="${cpath}/resources/js/board.js"></script>

<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f9f9f9;
	margin: 0;
	padding: 40px;
}

h1 {
	text-align: center;
	color: #333;
	margin-bottom: 30px;
}

form {
	max-width: 700px;
	margin: 0 auto;
	padding: 30px;
	background-color: #fff;
	border-radius: 12px;
	box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
}

p {
	margin-bottom: 20px;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 6px;
	color: #555;
}

input[type="text"], select, textarea {
	width: 100%;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 8px;
	font-size: 16px;
	box-sizing: border-box;
	transition: border-color 0.3s;
}

input[type="text"]:focus, select:focus, textarea:focus {
	border-color: #4a90e2;
	outline: none;
}

button {
	padding: 10px 20px;
	font-size: 15px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	transition: background-color 0.2s ease-in-out;
}

#btnInsert {
	background-color: #4a90e2;
	color: white;
	margin-right: 10px;
}

#btnInsert:hover {
	background-color: #3a78c2;
}

button[type="button"] {
	background-color: #ccc;
	color: #333;
}

button[type="button"]:hover {
	background-color: #bbb;
}
</style>
</head>
<body>
	<h1>게시글 등록</h1>

	<!-- 게시글 등록 폼 -->
	<form id="insertForm">
		<p>
			<label for="title">제목:</label> <input type="text" id="title"
				name="title" required maxlength="100" />
		</p>

		<p>
			<label for="category">카테고리:</label> <select id="category"
				name="category" required>
				<option value="">선택하세요</option>
				<option value="free">자유</option>
				<option value="info">정보/조언</option>
				<option value="idea">아이디어/제안</option>
			</select>
		</p>

		<p>
			<label for="content">내용:</label><br />
			<!-- summernote가 적용될 textarea (id와 name 둘 다 content로 통일) -->
			<textarea id="summernote" name="content"></textarea>
		</p>

		<p>
			<button type="submit" id="btnInsert">등록하기</button>
			<button type="button" onclick="location.href='${cpath}/board/list'">목록으로</button>
		</p>
	</form>
<script>
	$(function() {

		setupInsertForm();
	});
</script>

</body>
</html>
