<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%
    String commentId = request.getParameter("comment_id");
    String postId = request.getParameter("post_id");
    String memberId = (String) session.getAttribute("memberId");

    if (commentId == null || postId == null || memberId == null) {
        response.sendRedirect("viewPost.jsp?id=" + postId);
        return;
    }

    PreparedStatement pstmt = null;
    try {
        String sql = "DELETE FROM comments WHERE id = ? AND author = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, commentId);
        pstmt.setString(2, memberId);
        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            response.sendRedirect("viewPost.jsp?id=" + postId);
        } else {
            out.println("<script>alert('삭제 권한이 없습니다.'); location.href='viewPost.jsp?id=" + postId + "';</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
