<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, java.text.DecimalFormat, java.util.HashMap, java.util.Map" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="navbar.jsp" %>
<%@ include file="dbconn.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>장바구니</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message">
    <div class="container py-4">
        <div class="text-end">
            <a href="?language=ko">Korean</a> | <a href="?language=en">English</a>
        </div>
        <h1 class="display-5 fw-bold"><fmt:message key="cart" /></h1>
        <a href="javascript:history.back()" class="btn btn-secondary"><fmt:message key="back" /> &raquo;</a>
        <table class="table">
            <thead>
                <tr>
                    <th><fmt:message key="product" /></th>
                    <th><fmt:message key="price" /></th>
                    <th><fmt:message key="quantity" /></th>
                    <th><fmt:message key="totalPrice" /></th>
                    <th><fmt:message key="action" /></th>
                </tr>
            </thead>
            <tbody>
                <%
                    String memberId = (String) session.getAttribute("memberId");

                    if (memberId == null) {
                        response.sendRedirect("loginMember.jsp");
                        return;
                    }

                    String userId = memberId;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    boolean hasResults = false;

                    String sql = "SELECT c.id, c.product_id, p.name, p.price, c.quantity FROM cart c JOIN product p ON c.product_id = p.id WHERE c.user_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, userId);
                    rs = pstmt.executeQuery();

                    DecimalFormat formatter = new DecimalFormat("###,###");
                    int grandTotal = 0;
                    int cart_id = 0;

                    // HashMap을 사용하여 동일한 제품을 묶음
                    HashMap<String, Integer> productMap = new HashMap<>();

                    while (rs.next()) {
                        hasResults = true;
                        cart_id = rs.getInt("id");
                        String productId = rs.getString("product_id");
                        int quantity = rs.getInt("quantity");

                        if (productMap.containsKey(productId)) {
                            productMap.put(productId, productMap.get(productId) + quantity);
                        } else {
                            productMap.put(productId, quantity);
                        }
                    }

                    for (Map.Entry<String, Integer> entry : productMap.entrySet()) {
                        String productId = entry.getKey();
                        int quantity = entry.getValue();

                        sql = "SELECT name, price FROM product WHERE id = ?";
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, productId);
                        rs = pstmt.executeQuery();

                        if (rs.next()) {
                            String productName = rs.getString("name");
                            int productPrice = rs.getInt("price");
                            int totalPrice = productPrice * quantity;
                            grandTotal += totalPrice;
                %>
                <tr>
                    <td><%= productName %></td>
                    <td><%= formatter.format(productPrice) %>코인</td>
                    <td><%= quantity %></td>
                    <td><%= formatter.format(totalPrice) %>코인</td>
                    <td>
                        <form method="post" action="deleteCart.jsp">
                            <input type="hidden" name="product_id" value="<%= productId %>">
                            <button type="submit" class="btn btn-danger"><fmt:message key="delete" /></button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    }

                    if (!hasResults) {
                %>
                <tr>
                    <td colspan="5" class="text-center">장바구니가 비어 있습니다.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            if (hasResults) {
        %>
        <div class="text-end">
            <h4><fmt:message key="total" />: <%= formatter.format(grandTotal) %>코인</h4>
        </div>
        <a href="orderCart.jsp" class="btn btn-primary"><fmt:message key="order" /></a>
        <%
            }
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        %>
    </div>
</fmt:bundle>
</body>
</html>
