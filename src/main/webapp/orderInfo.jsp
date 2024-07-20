<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<%
    // 주문 번호를 파라미터로 받아옵니다.
    int orderId = Integer.parseInt(request.getParameter("orderId"));

    // 주문 정보 쿼리
    String orderQuery = "SELECT id AS order_id, order_date, name, address, phone FROM orders WHERE id = ?";
    PreparedStatement pstmt = conn.prepareStatement(orderQuery);
    pstmt.setInt(1, orderId);
    ResultSet orderRs = pstmt.executeQuery();

    DecimalFormat formatter = new DecimalFormat("###,###");
    SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    int totalOrderPrice = 0; // 총 주문 가격 초기화

    // 주문 정보 표시
    if (orderRs.next()) {
        int order_id = orderRs.getInt("order_id");
        Timestamp orderDate = orderRs.getTimestamp("order_date");
        String customerName = orderRs.getString("name");
        String customerAddress = orderRs.getString("address");
        String customerPhone = orderRs.getString("phone");

        // 상세 주문 정보 쿼리
        String detailQuery = "SELECT product_id, quantity FROM order_items WHERE order_id = ?";
        pstmt = conn.prepareStatement(detailQuery);
        pstmt.setInt(1, orderId);
        ResultSet detailRs = pstmt.executeQuery();

%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>주문 정보</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") != null ? request.getParameter("language") : "ko" %>'/>
<fmt:bundle basename="bundle.message" >
    <div class="container py-4">
    <div class="text-end">
        <a href="?language=ko&orderId=<%= order_id %>">Korean</a> | <a href="?language=en&orderId=<%= order_id %>">English</a>
    </div>
    <a href="orderList.jsp" class="btn btn-secondary"><fmt:message key="back" /> &raquo;</a>
        <h1 class="display-5 fw-bold"><fmt:message key="orderInfo" /></h1>
        <div>
            <h2><fmt:message key="orderNumber" />: <%= order_id %></h2>
            <p><fmt:message key="orderDate" />: <%= dateFormatter.format(orderDate) %></p>
            <p><fmt:message key="customerName" />: <%= customerName %></p>
            <p><fmt:message key="customerAddress" />: <%= customerAddress %></p>
            <p><fmt:message key="customerPhone" />: <%= customerPhone %></p>
            <table class="table">
                <thead>
                    <tr>
                        <th><fmt:message key="productName" /></th>
                        <th><fmt:message key="price" /></th>
                        <th><fmt:message key="quantity" /></th>
                        <th><fmt:message key="totalPrice" /></th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        while (detailRs.next()) {
                            int productId = detailRs.getInt("product_id");
                            int quantity = detailRs.getInt("quantity");

                            // 상품 정보 조회
                            String productQuery = "SELECT name, price FROM product WHERE id = ?";
                            pstmt = conn.prepareStatement(productQuery);
                            pstmt.setInt(1, productId);
                            ResultSet productRs = pstmt.executeQuery();
                            if (productRs.next()) {
                                String productName = productRs.getString("name");
                                int productPrice = productRs.getInt("price");
                                int totalPrice = productPrice * quantity;
                                totalOrderPrice += totalPrice; // 총 주문 가격 갱신
                    %>
                    <tr>
                        <td><%= productName %></td>
                        <td><%= formatter.format(productPrice) %>코인</td>
                        <td><%= quantity %></td>
                        <td><%= formatter.format(totalPrice) %>코인</td>
                    </tr>
                    <% 
                            }
                            productRs.close();
                        }
                    %>
                </tbody>
            </table>
            <p><fmt:message key="totalOrderPrice" />: <%= formatter.format(totalOrderPrice) %>코인</p>
        </div>
    </div>
  </fmt:bundle>
</body>
</html>
<%
    } else {
%>
    <div class="container py-4">
        <p class="text-center"><fmt:message key="orderNotFound" /></p>
    </div>
<%
    }
    orderRs.close();
    pstmt.close();
%>
