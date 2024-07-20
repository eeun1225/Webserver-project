<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file = "dbconn.jsp" %>
<%
	String memberId = (String) session.getAttribute("memberId");
	PreparedStatement pstmt = null;
	
	String sql = "DELETE FROM member WHERE id = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, memberId);
	pstmt.executeUpdate();
	
	
	
	if(pstmt != null)
		pstmt.close();
	if(conn != null)
		conn.close();
	
	session.invalidate();
	response.sendRedirect("resultMember.jsp");
%>


 