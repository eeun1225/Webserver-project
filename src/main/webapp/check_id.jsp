<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*, java.io.*"%>
<%@ include file="dbconn.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean isDuplicate = false;
    
    String sql = "SELECT id FROM member WHERE id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        isDuplicate = true;
    }
	
    if (isDuplicate) {
        out.print("DUPLICATE");
    } else {
        out.print("OK");
    }
    
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();

%>