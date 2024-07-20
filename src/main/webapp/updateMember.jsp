<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file = "dbconn.jsp" %>
<html>
<head>
<script type="text/javascript" src="./resources/js/validation_member.js"></script>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />	
<title>회원 수정</title>
</head>
<body onload="init()">
<%@include file ="navbar.jsp" %>
<div class="container py-4">
	<div class="p-5 mb-4 bg-body-tertiary rounded-3">
    	<div class="container-fluid py-5">
        	<h1 class="display-5 fw-bold">회원 수정</h1>
        	<p class="col-md-8 fs-4">Membership Updating</p>      
      	</div>
  	</div>
    <%
    	String memberId = (String) session.getAttribute("memberId");
		String sql = "SELECT * FROM member WHERE id=?";
		PreparedStatement pstmt = conn.prepareStatement(sql);
    	pstmt.setString(1, memberId);
		ResultSet rs = pstmt.executeQuery();
		if(rs.next()){
	%>
	<div class="container">
		<form name="newMember"action="processUpdateMember.jsp" method="post" onclick="return checkForm()">
				<div class="mb-3 row">
					<label class="col-sm-2 ">아이디</label>
					<div class="col-sm-3">
						<input name="id" type="text" class="form-control" placeholder="id" value='<%=rs.getString("id") %>'>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">비밀번호확인</label>
					<div class="col-sm-3">
						<input name="password_confirm" type="text" class="form-control" placeholder="password_confirm" >
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">성명</label>
					<div class="col-sm-3">
						<input name="name" type="text" class="form-control" placeholder="name" value='<%=rs.getString("name") %>' >
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">생일</label>
					<div class="col-sm-10  ">
				  		<div class="row">
							<div class="col-sm-2">
								<input type="text" name="birthyy"  maxlength="4"  class="form-control" placeholder="년(4자)" 	size="6" value='<%=rs.getString("birth").split("/")[0] %>'> 
							</div>
							<div class="col-sm-2">
								<select name="birthmm"	id="birthmm" class="form-select">
									<option value="">월</option>
									<option value="01">1</option>
									<option value="02">2</option>
									<option value="03">3</option>
									<option value="04">4</option>
									<option value="05">5</option>
									<option value="06">6</option>
									<option value="07">7</option>
									<option value="08">8</option>
									<option value="09">9</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
								</select> 
							</div>
							<div class="col-sm-2">
								<input type="text" name="birthdd" maxlength="2" class="form-control" placeholder="일" size="4" value='<%=rs.getString("birth").split("/")[2] %>'>
							</div>
						</div>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">이메일</label>
					<div class="col-sm-10">
				  		<div class="row">
				  			<div class="col-sm-4">
								<input type="text" name="mail1" maxlength="50" value='<%=rs.getString("mail") %>' class="form-control">
							</div>
							<div class="col-sm-3" >
								<select name="mail2" id="mail2" class="form-select">
									<option>naver.com</option>
									<option>daum.net</option>
									<option>gmail.com</option>
									<option>nate.com</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2">전화번호</label>
					<div class="col-sm-3">
						<input name="phone" type="text" class="form-control" placeholder="phone" value='<%=rs.getString("phone") %>'>
					</div>
				</div>
				<div class="mb-3 row">
					<label class="col-sm-2 ">주소</label>
					<div class="col-sm-5">
						<input name="address" type="text" class="form-control" placeholder="address" value='<%=rs.getString("address") %>'>
					</div>
				</div>
				<div class="mb-3 row">
					<div class="col-sm-offset-2 col-sm-10 ">
						<input type="submit" class="btn btn-primary" value="회원수정 "> 
						<a href="deleteMember.jsp" class="btn btn-primary">회원탈퇴</a>
					</div>
				</div>
		</form>
	</div>
	<%
		}
		
		if(rs != null) rs.close();
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
	%>
</div>	
</body>
</html>
