<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cpath" value="${pageContext.servletContext.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>게시글 등록</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    const cpath = "${cpath}";
  </script>
  <script src="${cpath}/resources/js/board.js"></script>
</head>
<body>
  <h1>게시글 등록</h1>

  <form id="insertForm" onsubmit="return false;">
    <p>
      <label for="title">제목:</label><br />
      <input type="text" id="title" name="title" required maxlength="100" />
    </p>

    <p>
      <label for="category">카테고리:</label><br />
      <select id="category" name="category" required>
        <option value="">선택하세요</option>
        <option value="free">자유</option>
        <option value="info">정보</option>
        <option value="idea">아이디어</option>
      </select>
    </p>

    <p>
      <label for="content">내용:</label><br />
      <textarea id="content" name="content" rows="8" cols="50" required></textarea>
    </p>

    <p>
      <label for="board_img">이미지 URL (선택):</label><br />
      <input type="text" id="board_img" name="board_img" placeholder="이미지 URL 입력" />
    </p>

    <p>
      <button id="btnInsert">등록하기</button>
      <button type="button" onclick="location.href='${cpath}/board/boardList.jsp'">목록으로</button>
    </p>
  </form>

</body>
</html>
