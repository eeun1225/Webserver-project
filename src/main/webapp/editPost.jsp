<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>글 수정</title>
</head>
<body>
    <div class="container">
        <h1 class="my-4">글 수정</h1>
        <%
    		String memberId = (String) session.getAttribute("memberId");
    		String postId = request.getParameter("id");
    		if (memberId == null || postId == null) {
        		response.sendRedirect("loginMember.jsp");
        		return;
    		}

    		PreparedStatement pstmt = null;
    		ResultSet rs = null;
    		boolean hasPermission = false;
   			String title = "";
    		String content = "";
    		
    		String sql = "SELECT title, content, author FROM post WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, postId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                title = rs.getString("title");
                content = rs.getString("content");
                String author = rs.getString("author");
                if (author.equals(memberId)) {
                    hasPermission = true;
                }
            } else {
                // 게시물이 없는 경우 처리
                response.sendRedirect("list.jsp");
                return;
            }

    		
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();

    		if (!hasPermission) {
				out.println("<script>alert('수정 권한이 없습니다.'); location href ='list.jsp'; </script>");
				return;
    	    }
		%>
		
        <form action="editPostAction.jsp" method="post">
            <input type="hidden" name="id" value="<%= postId %>">
            <div class="mb-3">
                <label for="title" class="form-label">제목</label>
                <input type="text" class="form-control" id="title" name="title" value="<%= title %>" required>
            </div>
            <div class="mb-3">
                <label for="content" class="form-label">내용</label>
                <textarea class="form-control" id="content" name="content" rows="5" required><%= content %></textarea>
            </div>
            <button type="submit" class="btn btn-primary">수정</button>
        </form>
    </div>
</body>
</html>
