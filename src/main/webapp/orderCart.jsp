<%@ page import="java.io.*, java.util.*, java.text.DecimalFormat, java.util.HashMap, java.util.Map" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>주문하기</title>
</head>
<body>
<%@ include file="navbar.jsp" %>
    <div class="container py-4">
        <h1 class="display-5 fw-bold">주문하기</h1>
        <div class="row">
            <div class="col-md-6">
                <h2>주문 상품 목록</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th>상품명</th>
                            <th>가격</th>
                            <th>수량</th>
                            <th>총 가격</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            String memberId = (String) session.getAttribute("memberId");

                            if(memberId == null) {
                                response.sendRedirect("loginMember.jsp");
                                return;    	
                            }

                            String userId = (String) session.getAttribute("memberId");
                            PreparedStatement pstmt = null;
                            ResultSet rs = null;
                            boolean hasResults = false;

                            String sql = "SELECT c.product_id, p.name, p.price, c.quantity FROM cart c JOIN product p ON c.product_id = p.id WHERE c.user_id = ?";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, userId);
                            rs = pstmt.executeQuery();

                            DecimalFormat formatter = new DecimalFormat("###,###");
                            HashMap<String, Integer> productMap = new HashMap<>();

                            while (rs.next()) {
                                hasResults = true;
                                String productId = rs.getString("product_id");
                                int quantity = rs.getInt("quantity");

                                if (productMap.containsKey(productId)) {
                                    productMap.put(productId, productMap.get(productId) + quantity);
                                } else {
                                    productMap.put(productId, quantity);
                                }
                            }

                            int grandTotal = 0;

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
                            <td><%= formatter.format(productPrice) %>원</td>
                            <td><%= quantity %></td>
                            <td><%= formatter.format(totalPrice) %>원</td>
                        </tr>
                        <%
                                }
                            }

                            if (!hasResults) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center">장바구니가 비어 있습니다.</td>
                        </tr>
                        <%
                            }

                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        %>
                    </tbody>
                </table>
                <div class="text-end">
                    <h5>총 가격: <%= formatter.format(grandTotal) %>원</h5>
                </div>
            </div>
            <div class="col-md-6">
                <h2>주문 정보 입력</h2>
                <form action="processOrder.jsp" method="post">
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
        </div>
    </div>
</body>
</html>
