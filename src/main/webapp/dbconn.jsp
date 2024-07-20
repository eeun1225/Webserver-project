<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    
    try {
        String url = "jdbc:mysql://localhost:3306/ChallengeDB";
        String user = "root";
        String password = "Root1234@!";
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
    } catch (ClassNotFoundException | SQLException ex) {
        out.println("데이터베이스 연결이 실패했습니다.");
        out.println("SQLException: " + ex.getMessage());
    }
%>
