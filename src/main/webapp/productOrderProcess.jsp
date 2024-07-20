<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="dbconn.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.util.Date" %>
<html>
<head>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css" />
    <title>주문 완료</title>
</head>
<body>
    <div class="container py-4">
    	<%
    		// 파라미터 가져오기
    		String productId = request.getParameter("product_id");
    		String quantityString = request.getParameter("quantity");
    		String userName = request.getParameter("name");
    		String userPhone = request.getParameter("phone");
    		String userAddress = request.getParameter("address");
    		String userId = (String) session.getAttribute("memberId");
	
    		if (userId == null) {
        		response.sendRedirect("loginMember.jsp");
        		return;
    		}

    		int quantity = Integer.parseInt(quantityString);
    
    		PreparedStatement pstmt = null;
    		ResultSet rs = null;
    
 			// 상품 정보 가져오기
    		String productQuery = "SELECT * FROM product WHERE id = ?";
    		pstmt = conn.prepareStatement(productQuery);
    		pstmt.setInt(1, Integer.parseInt(productId));
    		rs = pstmt.executeQuery();

    		if (rs.next()) {
       			int productPrice = rs.getInt("price");
        		int productStock = rs.getInt("stock");
        
        		if (quantity > productStock) {
            		out.println("<script>alert('재고가 부족합니다.'); location.href='productInfo.jsp?id=" + productId + "'</script>");
        		}

        		// 사용자 코인 확인
        		String userQuery = "SELECT coin FROM member WHERE id = ?";
        		pstmt = conn.prepareStatement(userQuery);
        		pstmt.setString(1, userId);
        		ResultSet userRs = pstmt.executeQuery();

        		int userCoins = 0;
        		if (userRs.next()) {
            		userCoins = userRs.getInt("coin");
        		}

        		// 총 가격 계산
        		int totalPrice = productPrice * quantity;

        		if (userCoins < totalPrice) {
            		out.println("<script>alert('코인이 부족합니다.'); location.href='productInfo.jsp?id=" + productId + "'</script>");
        		} else {
            		// 주문 정보 저장
            		String orderQuery = "INSERT INTO orders (user_id, order_date, name, address, phone) VALUES (?, NOW(), ?, ?, ?)";
            		pstmt = conn.prepareStatement(orderQuery, PreparedStatement.RETURN_GENERATED_KEYS);
            		pstmt.setString(1, userId);
            		pstmt.setString(2, userName);
            		pstmt.setString(3, userAddress);
            		pstmt.setString(4, userPhone);
            		pstmt.executeUpdate();

            		// 주문 번호 생성
            		rs = pstmt.getGeneratedKeys();
           			int orderId = 0;
            		if (rs.next()) {
                		orderId = rs.getInt(1);
            		}

            		// order_items 테이블에 주문 항목 저장
            		String orderItemQuery = "INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)";
            		pstmt = conn.prepareStatement(orderItemQuery);
            		pstmt.setInt(1, orderId);
            		pstmt.setInt(2, Integer.parseInt(productId));
            		pstmt.setInt(3, quantity);
            		pstmt.executeUpdate();

            		// 재고 업데이트
            		String updateStockQuery = "UPDATE product SET stock = stock - ? WHERE id = ?";
            		pstmt = conn.prepareStatement(updateStockQuery);
            		pstmt.setInt(1, quantity);
            		pstmt.setInt(2, Integer.parseInt(productId));
            		pstmt.executeUpdate();

            		// 사용자 코인 차감
            		String updateCoinsQuery = "UPDATE member SET coin = coin - ? WHERE id = ?";
            		pstmt = conn.prepareStatement(updateCoinsQuery);
            		pstmt.setInt(1, totalPrice);
            		pstmt.setString(2, userId);
            		pstmt.executeUpdate();
        
		%>
        		<h2>주문 완료</h2>
        		<div class="alert alert-success" role="alert">
            		주문이 성공적으로 완료되었습니다. 감사합니다!
        		</div>
        		<p>주문 번호: <%= orderId %></p>
        		<p>주문자: <%= userName %></p>
        		<p>연락처: <%= userPhone %></p>
        		<p>주소: <%= userAddress %></p>
        		<p>주문 내역을 확인하려면 <a href="orderInfo.jsp?orderId=<%= orderId %>">여기</a>를 클릭하세요.</p>
		<%
				}
			} else {
            // 주문 처리 중 문제가 발생한 경우
		%>
				<h2>주문 오류</h2>
        		<div class="alert alert-danger" role="alert">
            		주문 처리 중 문제가 발생했습니다. 다시 시도해주세요.
        		</div>
		<%
     		}
    		
    		if (rs != null) rs.close();
    		if (pstmt != null) pstmt.close(); 
    		if (conn != null) conn.close();  
		%>
	</div>
</body>
</html>
