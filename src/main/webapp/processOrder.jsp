<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<%
    String userName = request.getParameter("name");
    String userPhone = request.getParameter("phone");
    String userAddress = request.getParameter("address");
    String userId = (String) session.getAttribute("memberId");

    if (userId == null) {
        response.sendRedirect("loginMember.jsp");
        return;
    }

    List<Map<String, Object>> cartItems = new ArrayList<>();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 장바구니에서 상품 정보 가져오기
        String sql = "SELECT c.id, c.product_id, c.quantity, p.price, p.stock FROM cart c JOIN product p ON c.product_id = p.id WHERE c.user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("cart_id", rs.getInt("id"));
            item.put("product_id", rs.getInt("product_id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("price", rs.getInt("price"));
            item.put("stock", rs.getInt("stock"));
            cartItems.add(item);
        }

        if (cartItems.isEmpty()) {
            out.println("<script>alert('장바구니가 비어있습니다.'); location.href='cart.jsp';</script>");
            return;
        }

        // 사용자 코인 확인
        String userQuery = "SELECT coin FROM member WHERE id = ?";
        pstmt = conn.prepareStatement(userQuery);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        int userCoins = 0;
        if (rs.next()) {
            userCoins = rs.getInt("coin");
        }

        // 총 가격 계산
        int totalPrice = 0;
        for (Map<String, Object> item : cartItems) {
            int quantity = (int) item.get("quantity");
            int price = (int) item.get("price");
            totalPrice += price * quantity;
        }

        // 사용자 코인 충분한지 확인
        if (userCoins < totalPrice) {
            out.println("<script>alert('코인이 부족합니다.'); location.href='cart.jsp';</script>");
            return;
        }

        // 1. orders 테이블에 주문 정보 삽입
        String insertOrderQuery = "INSERT INTO orders (user_id, order_date, name, address, phone) VALUES (?, NOW(), ?, ?, ?)";
        pstmt = conn.prepareStatement(insertOrderQuery, PreparedStatement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, userId);
        pstmt.setString(2, userName);
        pstmt.setString(3, userAddress);
        pstmt.setString(4, userPhone);
        pstmt.executeUpdate();

        // 생성된 주문 ID 가져오기
        rs = pstmt.getGeneratedKeys();
        int orderId = 0;
        if (rs.next()) {
            orderId = rs.getInt(1);
        }

        // 2. order_items 테이블에 각 상품 정보 삽입 및 재고 업데이트
        String insertOrderItemsQuery = "INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(insertOrderItemsQuery);
        for (Map<String, Object> item : cartItems) {
            int productId = (int) item.get("product_id");
            int quantity = (int) item.get("quantity");
            int stock = (int) item.get("stock");

            if (quantity > stock) {
                out.println("<script>alert('재고가 부족합니다.'); location.href='cart.jsp';</script>");
                return;
            }

            pstmt.setInt(1, orderId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            pstmt.executeUpdate();

            // 재고 업데이트
            String updateStockQuery = "UPDATE product SET stock = stock - ? WHERE id = ?";
            PreparedStatement updateStockPstmt = conn.prepareStatement(updateStockQuery);
            updateStockPstmt.setInt(1, quantity);
            updateStockPstmt.setInt(2, productId);
            updateStockPstmt.executeUpdate();
            updateStockPstmt.close();
        }

        // 사용자 코인 차감
        String updateCoinsQuery = "UPDATE member SET coin = coin - ? WHERE id = ?";
        pstmt = conn.prepareStatement(updateCoinsQuery);
        pstmt.setInt(1, totalPrice);
        pstmt.setString(2, userId);
        pstmt.executeUpdate();

        // 장바구니 비우기
        String clearCartQuery = "DELETE FROM cart WHERE user_id = ?";
        pstmt = conn.prepareStatement(clearCartQuery);
        pstmt.setString(1, userId);
        pstmt.executeUpdate();

        request.setAttribute("orderId", orderId);

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <title>주문 완료</title>
</head>
<body>
    <div class="container py-4">
        <h2>주문 완료</h2>
        <div class="alert alert-success" role="alert">
            주문이 성공적으로 완료되었습니다. 감사합니다!
        </div>
        <p>주문 번호: <%= request.getAttribute("orderId") %></p>
        <p>주문자: <%= userName %></p>
        <p>연락처: <%= userPhone %></p>
        <p>주소: <%= userAddress %></p>
        <p>주문 내역을 확인하려면 <a href="orderList.jsp">여기</a>를 클릭하세요.</p>
    </div>
</body>
</html>
