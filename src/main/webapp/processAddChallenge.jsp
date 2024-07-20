<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>

<%
        request.setCharacterEncoding("utf-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String period = request.getParameter("period");
        String due_date_str = request.getParameter("due_date");
        int frequency = Integer.parseInt(request.getParameter("frequency"));
        int coin = Integer.parseInt(request.getParameter("coin"));
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        String category = request.getParameter("category");
        String certification = request.getParameter("certification");
        String user_id = (String)session.getAttribute("memberId");
        int count = 0;
   
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.sql.Date due_date = new java.sql.Date(sdf.parse(due_date_str).getTime());


        String sql = "INSERT INTO challenge(title, description, period, due_date, frequency, coin, capacity, count, category, certification, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, description);
        pstmt.setString(3, period);
        pstmt.setDate(4, due_date);
        pstmt.setInt(5, frequency);
        pstmt.setInt(6, coin);
        pstmt.setInt(7, capacity);
        pstmt.setInt(8, count);
        pstmt.setString(9, category);
        pstmt.setString(10, certification);
        pstmt.setString(11, user_id);
        pstmt.executeUpdate();

        if (pstmt != null) {
            pstmt.close();
        }

        if (conn != null) {
            conn.close();
        }

        response.sendRedirect("challenges.jsp");
%>
