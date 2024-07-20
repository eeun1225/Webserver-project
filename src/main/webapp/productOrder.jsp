<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ include file="navbar.jsp" %>
<%
	String member_Id = (String) session.getAttribute("memberId");

	if(member_Id == null) {
		response.sendRedirect("loginMember.jsp");
		return;    	
	}
	
    String productId = request.getParameter("product_id");
    String quantityString = request.getParameter("quantity");
    String userId = (String) session.getAttribute("memberId");
    int quantity = Integer.parseInt(quantityString);

    // 해당 상품 정보 가져오기
    String sql = "SELECT * FROM product WHERE id = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        // 상품 정보 추출
        String productName = rs.getString("name");
        int productPrice = rs.getInt("price");
        int productStock = rs.getInt("stock");
        DecimalFormat formatter = new DecimalFormat("###,###");
%>
<html>
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css" />
    <title>주문 정보 입력</title>
</head>
<body>
    <div class="container py-4">
        <h2>주문 정보 입력</h2>
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title"><%= productName %></h5>
                <p class="card-text">가격: <%= formatter.format(productPrice) %>코인</p>
                <p class="card-text">주문 수량: <%= quantity %></p>
                <p class="card-text">총 가격: <%= formatter.format(productPrice * quantity) %>코인</p>
            </div>
        </div>
        <form action="productOrderProcess.jsp" method="post">
            <input type="hidden" name="product_id" value="<%= productId %>">
            <input type="hidden" name="quantity" value="<%= quantity %>">
            <div class="mb-3">
                <label for="name" class="form-label">이름</label>
                <input type="text" class="form-control" id="name" name="name" required>
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">전화번호</label>
                <input type="tel" class="form-control" id="phone" name="phone" required>
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">배송 주소</label>
                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary">주문하기</button>
        </form>
    </div>
</body>
</html>
<%
    }

    // 자원 해제
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
%>
