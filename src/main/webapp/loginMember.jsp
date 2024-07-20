<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>Login</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<div class="container py-4">
 <div class="p-5 mb-4 bg-body-tertiary rounded-3">
 <div class="text-end">
    		<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    	</div>
      <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">회원 로그인</h1>
        <p class="col-md-8 fs-4">Membership Login</p>      
      </div>
    </div>

	<div class="container" align="center">
		<div class="col-md-4 col-md-offset-4">
			<h3 class="form-signin-heading">Please sign in</h3>
			<%
				String error = request.getParameter("error");
				if (error != null) {
					out.println("<div class='alert alert-danger'>");
					out.println("아이디와 비밀번호를 확인해 주세요");
					out.println("</div>");
				}
			%>
  			<form class="form-signin" action="processLoginMember.jsp" method="post">
  
    			<div class="form-floating mb-3 row">     
      				<input type="text" class="form-control" name='id' id="floatingInput" placeholder="ID" required autofocus>
      				<label for="floatingInput">ID</label>      
    			</div>
    			<div class="form-floating  mb-3 row">     
     	 			<input type="password" class="form-control" name='password' placeholder="Password">
    				 <label for="floatingPassword">Password</label>
			</div>

   
  				<button class="btn btn btn-lg btn-success btn-block" type="submit"><fmt:message key="login" /></button>
   				
  			</form>

		</div>
	</div>

  </div>	
  </fmt:bundle>
  </body>			
	
</html>