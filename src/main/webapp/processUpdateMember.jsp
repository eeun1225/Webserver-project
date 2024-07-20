<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String year = request.getParameter("birthyy");
    String month = request.getParameter("birthmm");
    String day = request.getParameter("birthdd");
    String birth = year + "/" + month + "/" + day;
    String mail1 = request.getParameter("mail1");
    String mail2 = request.getParameter("mail2");
    String mail = mail1 + "@" + mail2;
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");

    java.sql.Date currentDatetime = new java.sql.Date(System.currentTimeMillis());
    java.sql.Date sqlDate = new java.sql.Date(currentDatetime.getTime());
    java.sql.Timestamp timestamp = new java.sql.Timestamp(currentDatetime.getTime());

    PreparedStatement pstmt = null;

    String sql = "UPDATE member SET name=?, birth=?, mail=?, phone=?, address=? WHERE id=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, name);
    pstmt.setString(2, birth);
    pstmt.setString(3, mail);
    pstmt.setString(4, phone);
    pstmt.setString(5, address);
    pstmt.setString(6, id);
    int rowsAffected = pstmt.executeUpdate();

    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();

    if (rowsAffected > 0) {
        response.sendRedirect("resultMember.jsp?msg=0");
    } else {
        response.sendRedirect("resultMember.jsp?msg=1");
    }
%>
