<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
<title>회원가입</title>
</head>
<body>	
	<form method="post" action="signin_process.jsp">
		<p>아이디 : <input type="text" name="id">
		<p>비밀번호 : <input type="password" name="passwd">
		<p>이름 : <input type="text" name="name">
		<p>이메일 : <input type="text" name="email">
		<p>주소 : <input type="text" name="address">
		<p><input type="submit" value="회원가입">
	</form>
</body>
</html>