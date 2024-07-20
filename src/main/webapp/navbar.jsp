<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css">
    <title>Challenge</title>
    <style>
        .navbar-custom .nav-link {
            text-decoration: underline; /* 링크에 밑줄 추가 */
        }
    </style>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
    <nav class="navbar navbar-expand-lg navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="./main.jsp">CHALLENGE</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <div class="navbar-nav ms-auto link-container">
                    <%
                        String sessionId = (String) session.getAttribute("sessionId");
                        String memberId = (String) session.getAttribute("memberId");
                        if (memberId == null) {
                    %>
                    <a class="nav-link" href="./loginMember.jsp"><fmt:message key="login" /></a>
                    <a class="nav-link" href="./signIn.jsp"><fmt:message key="signin" /></a>
                    <%
                        } else {
                    %>
                    <span class="navbar-text"><fmt:message key="welcome" /> ${memberId}</span>
                    <a class="nav-link" href="./myPage.jsp"><fmt:message key="myPage" /></a>
                    <a class="nav-link" href="./logout.jsp"><fmt:message key="logout" /></a>
                    <a class="nav-link" href="./attendanceCheck.jsp"><fmt:message key="attendance" /></a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </nav>
</fmt:bundle>
</body>
</html>
