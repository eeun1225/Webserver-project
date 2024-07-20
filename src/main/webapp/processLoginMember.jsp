<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ include file = "dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String passwd = request.getParameter("password");

    // Assuming password should match the id for simplicity, but this should be properly verified against DB
    if (id == null || passwd == null || id.isEmpty() || passwd.isEmpty()) {
        response.sendRedirect("loginMember.jsp?error=1");
        return;
    }
    
    PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM member WHERE ID = ? AND PASSWORD = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	pstmt.setString(2, passwd);
	rs = pstmt.executeQuery();
    
	if(rs.next()){
		session.setAttribute("memberId", id);
        response.sendRedirect("resultMember.jsp?msg=2");
	} else {
        response.sendRedirect("loginMember.jsp?error=1");
    }
	
	if (rs != null) 
		rs.close();
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();

%>