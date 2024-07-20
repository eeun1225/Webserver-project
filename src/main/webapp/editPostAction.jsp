<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>

<%
    String id = request.getParameter("id");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String memberId = (String) session.getAttribute("memberId");

    if (id != null && title != null && content != null && memberId != null) {
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE post SET title = ?, content = ? WHERE id = ? AND author = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, id);
        pstmt.setString(4, memberId);
        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("list.jsp");
        } else {
            out.println("Failed to update the post. It may not exist or you don't have permission.");
        }
        
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
        
    } else {
        response.sendRedirect("editPost.jsp?id=" + id);
    }
 
%>
