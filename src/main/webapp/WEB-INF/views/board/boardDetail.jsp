<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>게시글 상세보기</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	const cpath = "${cpath}";
	const uid = "${board.uid}";
</script>

<script src="${cpath}/resources/js/board.js"></script>

<style>
table.detail-table {
	width: 80%;
	margin: 20px auto;
	border-collapse: collapse;
}

.detail-table th, .detail-table td {
	border: 1px solid #ddd;
	padding: 12px;
	text-align: left;
}

.detail-table th {
	background-color: #f8f8f8;
	width: 150px;
}

#detailImg {
	max-width: 300px;
	height: auto;
}

#actionButtons, #backButton {
	width: 80%;
	margin: 20px auto;
	text-align: center;
}

#likeSection {
	display: flex;
	justify-content: center;
	margin: 20px 0;
}

#likeBtn {
	background-color: #ff6b81;
	color: white;
	border: none;
	padding: 12px 24px;
	font-size: 16px;
	border-radius: 30px;
	cursor: pointer;
	transition: background-color 0.3s ease;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

#likeBtn:hover {
	background-color: #e85a70;
}

#likeCount {
	margin-left: 8px;
	font-weight: bold;
}
</style>
</head>
<body>
	<h1 style="text-align: center;">게시글 상세보기</h1>


	<!-- 상세정보 테이블 -->
	<table class="detail-table">
		<tr>
			<th>제목</th>
			<td id="detailTitle"></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td id="detailAuthor"></td>
		</tr>
		<tr>
			<th>카테고리</th>
			<td id="detailCategory"></td>
		</tr>
		<tr>
			<th>내용</th>
			<td id="detailContent"></td>
		</tr>
		<tr>
			<th>조회수</th>
			<td id="detailViewCount"></td>
		</tr>
		<tr>
			<th>좋아요 수</th>
			<td id="detailLikeCount"></td>
		</tr>
		<tr>
			<th>작성일</th>
			<td id="detailCreatedAt"></td>
		</tr>
		<tr>
			<th>첨부 이미지</th>
			<td><img id="detailImg" src="" alt="이미지 없음" /></td>
		</tr>
	</table>

	<!-- 좋아요 -->
	<button id="likeBtn">좋아요</button>
	<span id="likeCount">${board.like_count}</span>

	<!-- 버튼 -->
	<div id="actionButtons">
		<button id="btnEdit">수정하기</button>
		<button id="btnDelete">삭제하기</button>
	</div>

	<div id="backButton">
		<button onclick="location.href='${cpath}/board/list'">목록으로</button>
	</div>
</body>
</html>
