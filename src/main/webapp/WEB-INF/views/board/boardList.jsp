<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>게시판 목록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	const cpath = "${cpath}";
</script>


<style>
#categoryButtons {
	text-align: center;
	margin: 30px 0;
}

#categoryButtons button {
	background-color: #f0f0f0;
	border: none;
	border-radius: 20px;
	padding: 10px 20px;
	margin: 0 10px;
	font-size: 14px;
	cursor: pointer;
	box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
	transition: background-color 0.3s, transform 0.2s;
}

#categoryButtons button:hover {
	background-color: #e0e0e0;
	transform: scale(1.05);
}

#categoryButtons button.active {
	background-color: #4CAF50;
	color: white;
	font-weight: bold;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
}

thead {
	background-color: #f2f2f2;
}

th, td {
	padding: 12px;
	border: 1px solid #ccc;
	text-align: center;
}

#paging {
	text-align: center;
	margin: 20px 0;
}

#sortButtons {
	text-align: right;
	margin: 10px 40px;
}

.sort-btn {
	background-color: #f0f0f0;
	border: 1px solid #ccc;
	padding: 8px 14px;
	margin-left: 5px;
	font-size: 14px;
	border-radius: 20px;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.sort-btn:hover {
	background-color: #e0e0e0;
}

.sort-btn.active {
	background-color: #007bff;
	color: white;
	border-color: #007bff;
}

.
.board-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 20px 40px;
}

.write-btn {
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 20px;
	padding: 10px 20px;
	font-size: 14px;
	cursor: pointer;
	box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
	transition: background-color 0.3s ease;
}

.write-btn:hover {
	background-color: #45a049;
}
</style>
</head>
<body>

	<!-- 게시판 제목 + 등록 버튼 -->
	<h1 style="text-align: center;">게시판</h1>

	<!-- 카테고리 버튼 영역 -->
	<div id="categoryButtons">
		<button onclick="filterByCategory('free')">자유</button>
		<button onclick="filterByCategory('info')">정보/조언</button>
		<button onclick="filterByCategory('idea')">제안/아이디어</button>
	</div>

	<!-- 등록 버튼 + 정렬 버튼 한 줄 배치 -->
	<div class="button-row">
		<button class="write-btn"
			onclick="location.href='${cpath}/board/insert'">게시글
			등록</button>
		<div id="sortButtons">
			<button class="sort-btn" data-sort="like_count">👍좋아요</button>
			<button class="sort-btn" data-sort="view_count">👀조회수</button>
		</div>
	</div>


	<!-- 게시글 목록 테이블 -->
	<table>
		<thead>
			<tr>
				<th>순서</th>
				<th>제목</th>
				<th>카테고리</th>
				<th>작성자</th>
				<th>조회수</th>
				<th>좋아요</th>
				<th>작성일</th>
			</tr>
		</thead>
		<tbody id="boardList"></tbody>
	</table>

	<!-- 페이징 영역 -->
	<div id="paging"></div>
	<script src="${cpath}/resources/js/board.js"></script>
</body>
</html>
