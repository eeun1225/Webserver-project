<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file = "dbconn.jsp" %>
<%@include file="navbar.jsp" %>
<%
    String memberId = (String) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("loginMember.jsp");
        return;
    }
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT mail, phone, address FROM member WHERE id = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, memberId);
	rs = pstmt.executeQuery();
	if(rs.next()) {
%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>회원 정보 수정</title>
</head>
<body>
<div class="container py-4">
    <h1 class="display-5 fw-bold">회원 정보 수정</h1>
    <%
        String error = request.getParameter("error");
        if (error != null && error.equals("1")) {
            out.println("<div class='alert alert-danger'>모든 필드를 채워주세요.</div>");
        }
    %>
    <form action="updateMember.jsp" method="post">
            <div class="mb-3">
                <label for="mail" class="form-label">메일</label>
                <input type="email" class="form-control" id="mail" name="mail" value="${row.mail}" required>
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">휴대폰 번호</label>
                <input type="text" class="form-control" id="phone" name="phone" value="${row.phone}" required>
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">주소</label>
                <input type="text" class="form-control" id="address" name="address" value="${row.address}" required>
            </div>
		<button type="submit" class="btn btn-primary">수정</button>
    </form>
    <%
	}
	if(rs!=null)
		rs.close();
	if(pstmt != null)
		pstmt.close();
	if(conn != null)
		conn.close();
    %>
</div>
</body>
</html>
