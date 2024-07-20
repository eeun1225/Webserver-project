<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<link rel="stylesheet" href="./resources/css/styles.css" />
<title>마이페이지</title>
</head>
<body>
<div class="container">
<%@ include file="navbar.jsp" %>
    <h1 class="display-5 fw-bold">마이페이지</h1>
    <div class="card">
        <%
        	String memberId = (String) session.getAttribute("memberId");
        	if (memberId == null) {
           		response.sendRedirect("loginMember.jsp");
            	return;
        	}
        
        	PreparedStatement pstmt = null;
        	ResultSet rs = null;
        
        	String sql = "SELECT id, name, mail, phone, address, coin FROM member WHERE id = ?";
        	pstmt = conn.prepareStatement(sql);
       		pstmt.setString(1, memberId);
        	rs = pstmt.executeQuery();
        
        	if(rs.next()){
    	%>	
            <p><strong>아이디:</strong> <%=rs.getString("id") %></p>
            <p><strong>이름:</strong> <%=rs.getString("name") %></p>
            <p><strong>메일:</strong> <%=rs.getString("mail") %></p>
            <p><strong>휴대폰 번호:</strong> <%=rs.getString("phone")%></p>
            <p><strong>주소:</strong> <%=rs.getString("address") %></p>
            <p><strong>코인:</strong> <%=rs.getInt("coin")%></p>
    
            <div class="btn-container">
                <a href="updateMember.jsp" class="btn btn-primary">정보 수정</a>
                <a href="deleteMember.jsp" class="btn btn-danger">회원 탈퇴</a>
            </div>
        <%
        	}
        	
        	if (rs != null) 
    			rs.close();
    		if (pstmt != null)
    			pstmt.close();
    		if (conn != null)
    			conn.close();
        %>
    </div>
</div>
</body>
</html>
