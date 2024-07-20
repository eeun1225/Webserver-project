<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>회원 정보</title>
</head>
<body>
<div class="container py-4">
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <%
                String msg = request.getParameter("msg");
                if (msg != null) {
                    if (msg.equals("0") || msg.equals("2")) {
            %>
            <h1 class="display-5 fw-bold">회원 정보</h1>
            <p class="col-md-8 fs-4">Membership Info</p>    
            <% } else if (msg.equals("1")) { %>  
            <h1 class="display-5 fw-bold">회원 가입</h1>
            <p class="col-md-8 fs-4">Membership Joining</p>    
            <% } %>
            <% } %>
        </div>
    </div>
    
    <div class="row align-items-md-stretch text-center">
		<%
			if (msg != null) {
			if (msg.equals("0")) {
		%>
			<h2 class='alert alert-danger'>회원정보가 수정되었습니다.</h2>
			<a href="./main.jsp" class="btn btn-warning">메인화면으로 이동</a>
		<%
			} else if (msg.equals("1")) {
		%>
			<h2 class='alert alert-danger'>회원가입을 축하드립니다.</h2>
			<a href="./main.jsp" class="btn btn-warning">메인화면으로 이동</a>
		<%
		    } else if (msg.equals("2")) {
					String loginId = (String) session.getAttribute("memberId");
		%>
			<h2 class='alert alert-success'><%= loginId %>님 환영합니다</h2>
			 <a href="./main.jsp" class="btn btn-warning">메인화면으로 이동</a>
		<%
			    }           
			} else {
		%>
    		<h2 class='alert alert-danger'>회원정보가 삭제되었습니다.</h2>
    		<a href="./main.jsp" class="btn btn-warning">메인화면으로 이동</a>
		<%
			}
		%>
    </div>
</div>    
</body>
</html>
