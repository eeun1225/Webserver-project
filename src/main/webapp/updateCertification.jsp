<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconn.jsp" %>

<%
    String id = request.getParameter("id");
	String challenge_id = request.getParameter("challenge_id");
    String status = request.getParameter("status");

    String sql = "UPDATE certifications SET status = ? WHERE id = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, status);
    pstmt.setString(2, id);
    pstmt.executeUpdate();

    pstmt.close();

    response.sendRedirect("evaluateCertification.jsp?id=" + challenge_id);
%>
