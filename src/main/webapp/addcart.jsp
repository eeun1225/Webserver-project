<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%@ page import="java.io.*" %>
<%
    String memberId = (String) session.getAttribute("memberId");
    String productId = request.getParameter("product_id");
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    PreparedStatement pstmt = null;
    
    String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, memberId);
    pstmt.setString(2, productId);
    pstmt.setInt(3, quantity);
    pstmt.executeUpdate();
    
    if (pstmt != null) pstmt.close(); 
    if (conn != null) conn.close();

    // 장바구니 페이지로 리디렉션
    response.sendRedirect("cart.jsp");
%>
