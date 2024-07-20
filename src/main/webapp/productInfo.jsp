<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<%
    String productId = request.getParameter("id");
    String sql = "SELECT * FROM product WHERE id = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) {
        String productName = rs.getString("name");
        String productDescription = rs.getString("description");
        int productPrice = rs.getInt("price"); // 숫자 타입으로 변경
        int productStock = rs.getInt("stock"); // 숫자 타입으로 변경
        String productImage = rs.getString("image");
        
        boolean isSoldOut = productStock <= 0; // 품절 여부 확인
%>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title><%= productName %></title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") != null ? request.getParameter("language") : "ko" %>'/>
<fmt:bundle basename="bundle.message" >
    <div class="container py-4">
    <div class="text-end">
        <a href="?language=ko&id=<%= productId %>">Korean</a> | <a href="?language=en&id=<%= productId %>">English</a>
    </div>
        <a href="shop.jsp" class="btn btn-secondary"><fmt:message key="back" /> &raquo;</a>
        <h1 class="display-5 fw-bold"><%= productName %></h1>
        <div class="row">
            <div class="col-md-6">
                <img src="<%= request.getContextPath() %>/resources/image/<%=productImage%>" class="img-fluid" alt="<%= productName %>">
            </div>
            <div class="col-md-6">
                <p><%= productDescription %></p>
                <p>가격: <%= productPrice %>코인</p>
                <p>재고: <%= productStock %>개</p>
                <% 
                    if (!isSoldOut) { // 품절이 아닐 때만 장바구니 추가 및 구매하기 버튼 표시
                %>
                    <form action="addcart.jsp" method="post">
                        <input type="hidden" name="product_id" value="<%= productId %>">
                        <div class="mb-3">
                            <label for="quantity" class="form-label">수량</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" value="1" min="1" max="<%= productStock %>">
                        </div>
                        <button type="submit" class="btn btn-primary me-2"><fmt:message key="addToCart" /></button>
                        <button formaction="productOrder.jsp" type="submit" class="btn btn-success"><fmt:message key="buy" /></button>
                    </form>
                <% 
                    } else { // 품절일 때 품절 메시지만 표시
                %>
                    <div class="text-center mb-3 mt-4">
                        <button type="button" class="btn btn-secondary" disabled><fmt:message key="soldout" /></button>
                    </div>
                <% 
                    }
                %>
            </div>
        </div>
    </div>
</fmt:bundle>
</body>
</html>
<%
    }
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
%>
