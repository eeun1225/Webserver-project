<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css" />
    <title>상품 목록</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
    <div class="container py-4">
    <div class="text-end">
    	<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    </div>
        <h1 class="display-5 fw-bold"><fmt:message key="productList" /></h1>
        <a class="btn btn-warning" href="<%= request.getContextPath() %>/cart.jsp"><fmt:message key="cart" /></a>
        <a class="btn btn-warning" href="<%= request.getContextPath() %>/orderList.jsp"><fmt:message key="orderList" /></a>
        <div class="row mt-3">
            <%
                DecimalFormat formatter = new DecimalFormat("###,###");
                String sql = "SELECT * FROM product";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery();
                while (rs.next()) {
                    String productId = rs.getString("id");
                    String productName = rs.getString("name");
                    String productPrice = formatter.format(rs.getInt("price"));
                    String productImage = rs.getString("image");
            %>
                <div class="col-md-4">
                    <div class="card mb-4">
                        <img src="<%= request.getContextPath() %>/resources/image/<%=productImage%>" style="width: 250px; height:350px" alt="<%= productName %>" />      
                        <div class="card-body">
                            <h5 class="card-title"><%= productName %></h5>
                            <p class="card-text">가격: <%= productPrice %>코인</p>
                            <a href="productInfo.jsp?id=<%= productId %>" class="btn btn-primary"><fmt:message key="moreInfo" /></a>
                        </div>
                    </div>
                </div>
            <%
                }
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            %>
        </div>
    </div>
</fmt:bundle>
</body>
</html>
