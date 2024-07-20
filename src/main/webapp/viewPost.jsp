<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.HashMap" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String postId = request.getParameter("id");
    if (postId == null) {
        response.sendRedirect("list.jsp");
        return;
    }

    String memberId = (String) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("loginMember.jsp");
        return;
    }

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String title = "";
    String content = "";
    String author = "";
    String created_at = "";

    // 게시글 정보 조회
    String sql = "SELECT title, content, author, created_at FROM post WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, postId);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        title = rs.getString("title");
        content = rs.getString("content");
        author = rs.getString("author");
        created_at = rs.getString("created_at");
    } else {
        response.sendRedirect("list.jsp");
        return;
    }

    // 댓글 조회
    List<Map<String, String>> comments = new ArrayList<>();
    sql = "SELECT id, author, content, created_at FROM comments WHERE post_id = ? ORDER BY created_at DESC";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, postId);
    rs = pstmt.executeQuery();
    while (rs.next()) {
        Map<String, String> comment = new HashMap<>();
        comment.put("id", rs.getString("id")); // 댓글 ID 추가
        comment.put("author", rs.getString("author"));
        comment.put("content", rs.getString("content"));
        comment.put("created_at", rs.getString("created_at"));
        comments.add(comment);
    }

    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();

    request.setAttribute("comments", comments);
%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>글 내용 보기</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
    <div class="container mt-5">
        <a href="list.jsp" class="btn btn-secondary"><fmt:message key="back" /> &raquo;</a>
        <div class="text-end">
            <a href="?language=ko&id=<%= postId %>">Korean</a> | <a href="?language=en&id=<%= postId %>">English</a> 
        </div>
        <div class="card">
            <div class="card-body">
                <h1 class="card-title"><%= title %></h1>
                <p class="text-muted"><fmt:message key="writer" />: <%= author %></p>
                <p class="text-muted"><fmt:message key="createdAt" />: <%= created_at %></p>
                <hr />
                <p class="card-text"><%= content %></p>
                <div class="btn-group-custom">
                    <a href="list.jsp" class="btn btn-secondary-custom btn-fixed-size">목록으로</a>
                    <a href="editPost.jsp?id=<%= postId %>" class="btn btn-secondary-custom btn-fixed-size">수정</a>
                    <form action="deletePostAction.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="id" value="<%= postId %>">
                        <button type="submit" class="btn btn-secondary-custom btn-fixed-size" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
                    </form>
                </div>
            </div>
        </div>
        <hr />
        <h2 class="mt-5"><fmt:message key="comment" /></h2>
        <div class="list-group">
            <% 
                for (Map<String, String> comment : comments) { 
            %>
                <div class="list-group-item comment">
                    <h5 class="mb-1"><strong><%= comment.get("author") %></strong></h5>
                    <p class="mb-1"><%= comment.get("content") %></p>
                    <small class="text-muted"><%= comment.get("created_at") %></small>
                    <% if (memberId != null && memberId.equals(comment.get("author"))) { %>
                        <form action="deleteCommentAction.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="comment_id" value="<%= comment.get("id") %>">
                            <input type="hidden" name="post_id" value="<%= postId %>">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
                        </form>
                    <% } %>
                </div>
            <% 
                } 
            %>
        </div>
        <h3 class="mt-5"><fmt:message key="writeComment" /></h3>
        <form action="addCommentAction.jsp" method="post">
            <input type="hidden" name="post_id" value="<%= postId %>">
            <input type="hidden" name="author" value="<%= memberId %>">
            <div class="form-group">
                <label for="content"><fmt:message key="contents" /></label>
                <textarea class="form-control" name="content" rows="3" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary mt-2"><fmt:message key="writeComment" /></button>
        </form>
    </div>
</fmt:bundle>
</body>
</html>
