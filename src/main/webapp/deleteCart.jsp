<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%
    String user_id = (String) session.getAttribute("memberId");
    String productId = request.getParameter("product_id");
	
    
    String sql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, user_id);
    pstmt.setString(2, productId);
    pstmt.executeUpdate();
    
    
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();

    response.sendRedirect("cart.jsp");
%>
