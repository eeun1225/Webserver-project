<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<%
    String userId = (String) session.getAttribute("memberId");
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    DecimalFormat formatter = new DecimalFormat("###,###");
    SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    // 주문 내역을 그룹화할 리스트
    List<Map<String, Object>> orderList = new ArrayList<>();
    
    String sql = "SELECT o.id AS order_id, o.order_date, oi.product_id, oi.quantity, p.name, p.price " +
            "FROM orders o " +
            "JOIN order_items oi ON o.id = oi.order_id " +
            "JOIN product p ON oi.product_id = p.id " +
            "WHERE o.user_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, userId);
    rs = pstmt.executeQuery();

    // 주문번호를 기준으로 주문 내역을 그룹화하여 리스트에 추가
    while (rs.next()) {
        int orderId = rs.getInt("order_id");
        Timestamp orderDate = rs.getTimestamp("order_date");
        int productId = rs.getInt("product_id");
        int quantity = rs.getInt("quantity");
        String productName = rs.getString("name");
        int productPrice = rs.getInt("price");

        boolean foundGroup = false;
        for (Map<String, Object> orderMap : orderList) {
            if ((int) orderMap.get("order_id") == orderId) {
                // 이미 존재하는 주문 그룹인 경우 해당 그룹에 상품 정보 추가
                List<Map<String, Object>> productList = (List<Map<String, Object>>) orderMap.get("products");
                Map<String, Object> productMap = new HashMap<>();
                productMap.put("product_id", productId);
                productMap.put("name", productName);
                productMap.put("price", productPrice);
                productMap.put("quantity", quantity);
                productList.add(productMap);
                foundGroup = true;
                break;
            }
        }
        
        if (!foundGroup) {
            // 새로운 주문 그룹인 경우 새로운 주문 그룹 생성 및 상품 정보 추가
            Map<String, Object> newOrderMap = new HashMap<>();
            newOrderMap.put("order_id", orderId);
            newOrderMap.put("order_date", orderDate);
            List<Map<String, Object>> productList = new ArrayList<>();
            Map<String, Object> newProductMap = new HashMap<>();
            newProductMap.put("product_id", productId);
            newProductMap.put("name", productName);
            newProductMap.put("price", productPrice);
            newProductMap.put("quantity", quantity);
            productList.add(newProductMap);
            newOrderMap.put("products", productList);
            orderList.add(newOrderMap);
        }
    }
%> 
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>주문 내역</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
    <div class="container py-4">
    <div class="text-end">
        <a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    </div>
        <a href="./shop.jsp" class="btn btn-secondary"><fmt:message key="toShop" />&raquo;</a>
        <h1 class="display-5 fw-bold"><fmt:message key="orderList" /></h1>
        <%
            if (!orderList.isEmpty()) {
                for (Map<String, Object> orderMap : orderList) {
                    int orderId = (int) orderMap.get("order_id");
                    Timestamp orderDate = (Timestamp) orderMap.get("order_date");
                    List<Map<String, Object>> productList = (List<Map<String, Object>>) orderMap.get("products");
                    int totalPriceSum = 0; // 각 주문마다 총 가격을 초기화
        %>
        <div>
            <h2><a href="orderInfo.jsp?orderId=<%= orderId %>">주문번호: <%= orderId %></a></h2>
            <p><%= dateFormatter.format(orderDate) %></p> <!-- 주문 시간을 출력 -->
            <table class="table">
                <thead>
                    <tr>
                        <th><fmt:message key="product" /></th>
                        <th><fmt:message key="price" /></th>
                        <th><fmt:message key="quantity" /></th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Map<String, Object> productMap : productList) {
                            String productName = (String) productMap.get("name");
                            int productPrice = (int) productMap.get("price");
                            int quantity = (int) productMap.get("quantity");

                            totalPriceSum += productPrice * quantity; // 각 상품의 가격을 합산하여 총 가격 계산
                    %>
                    <tr>
                        <td><%= productName %></td>
                        <td><%= formatter.format(productPrice) %>코인</td>
                        <td><%= quantity %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <div>
                <p>총 가격: <%= formatter.format(totalPriceSum) %>코인</p>
            </div>
        </div>
        <hr /> <!-- 구분선 추가 -->
        <%
                }
            } else {
        %>
        <p class="text-center">주문 내역이 없습니다.</p>
        <%
            }
        %>
    </div>
</fmt:bundle>
</body>
</html>
<%
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
%>
