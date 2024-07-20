<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>

<%
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String memberId = (String) session.getAttribute("memberId");

    if (title != null && !title.trim().isEmpty() && content != null && !content.trim().isEmpty() && memberId != null) {
        PreparedStatement pstmt = null;
        
        String sql = "INSERT INTO post (title, content, author) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, memberId);
        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("list.jsp");
        } else {
            out.println("Failed to insert the post.");
        }
       
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
           
    } else {
        response.sendRedirect("createPost.jsp");
    }
%>
