<%@ page contentType="text/html; charset=utf-8" %>
<%
    String memberId = (String) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("loginMember.jsp");
        return;
    }
%>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>글 작성</title>
</head>
<body>
    <div class="container">
        <h1 class="my-4">글 작성</h1>
        <form action="createPostAction.jsp" method="post">
            <div class="mb-3">
                <label for="title" class="form-label">제목</label>
                <input type="text" class="form-control" id="title" name="title" required>
            </div>
            <div class="mb-3">
                <label for="content" class="form-label">내용</label>
                <textarea class="form-control" id="content" name="content" rows="5" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">작성</button>
        </form>
    </div>
</body>
</html>
