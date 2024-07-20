<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ include file="dbconn.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id").trim();
	String password = request.getParameter("password").trim();
	String name = request.getParameter("name").trim();
	String year = request.getParameter("birthyy").trim();
	String month = request.getParameterValues("birthmm")[0];
	String day = request.getParameter("birthdd").trim();
	String birth = year + "/" + month + "/" + day;
	String mail1 = request.getParameter("mail1").trim();
	String mail2 = request.getParameterValues("mail2")[0];
	String mail = mail1 + "@" + mail2;
	String phonePrefix = request.getParameter("phone_prefix");
    String phoneMid = request.getParameter("phone_mid");
    String phoneSuffix = request.getParameter("phone_suffix");
    String phone = phonePrefix + "-" + phoneMid + "-" + phoneSuffix;
	String address = request.getParameter("address").trim();
	int coin = 2000;

	java.sql.Date currentDatetime = new java.sql.Date(System.currentTimeMillis());
	java.sql.Date sqlDate = new java.sql.Date(currentDatetime.getTime());
	
	PreparedStatement pstmt = null;

	String sql = "INSERT INTO member VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	pstmt.setString(2, password);
	pstmt.setString(3, name);
	pstmt.setString(4, birth);
	pstmt.setString(5, mail);
	pstmt.setString(6, phone);
	pstmt.setString(7, address);
	pstmt.setInt(8, coin);
	pstmt.executeUpdate();
	
	if (pstmt != null) pstmt.close();
	if (conn != null) conn.close();

	response.sendRedirect("resultMember.jsp?msg=1");
%>
