<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="dbconn.jsp" %>

<%
    request.setCharacterEncoding("utf-8");

    String c_id = request.getParameter("id");
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    String period = request.getParameter("period");
    String due_date_str = request.getParameter("due_date");
    int frequency = Integer.parseInt(request.getParameter("frequency"));
    int coin = Integer.parseInt(request.getParameter("coin"));
   	int capacity = Integer.parseInt(request.getParameter("capacity"));
   	String category = request.getParameter("category");
    String certification = request.getParameter("certification");
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	java.sql.Date due_date = new java.sql.Date(sdf.parse(due_date_str).getTime());


    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String sql = "SELECT * FROM challenge WHERE c_id=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, c_id);
    rs = pstmt.executeQuery();
    
    if(rs.next()){
        sql = "UPDATE challenge SET title=?, description=?, period=?, due_date=?, frequency=?, coin=?, capacity=?, category=?, certification=? WHERE c_id=?";
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, title);
        pstmt.setString(2, description);
        pstmt.setString(3, period);
        pstmt.setDate(4, due_date);
        pstmt.setInt(5, frequency);
        pstmt.setInt(6, coin);
        pstmt.setInt(7, capacity);
        pstmt.setString(8, category);
        pstmt.setString(9, certification);
        pstmt.setString(10, c_id);
        
        pstmt.executeUpdate();
        
    }
    
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();

    response.sendRedirect("challenge.jsp?id=" + c_id);
%>
