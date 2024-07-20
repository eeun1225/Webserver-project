<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>

<%
    String postId = request.getParameter("post_id");
    String author = request.getParameter("author");
    String content = request.getParameter("content");

    if (postId == null || author == null || content == null) {
        response.sendRedirect("viewPost.jsp?id=" + postId);
        return;
    }

    PreparedStatement pstmt = null;

    try {
        String sql = "INSERT INTO comments (post_id, author, content) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, postId);
        pstmt.setString(2, author);
        pstmt.setString(3, content);
        pstmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    response.sendRedirect("viewPost.jsp?id=" + postId);
%>
