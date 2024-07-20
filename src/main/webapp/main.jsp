<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css">
    <link rel="stylesheet" href="./resources/css/styles.css">
    <title>메인화면</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
    <%@ include file="navbar.jsp" %>
    <div class="container content-container">
    <div class="text-end">
    	<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    </div>
        <div class="jumbotron jumbotron-custom">
            <div class="container">
                <div class="section">
                    <h1 class="display-4"><a style="color: inherit; text-decoration: none;"><fmt:message key="challenge" /></a></h1>
                    <p class="lead"><fmt:message key="welcomeChallenge" /></p>
                    <hr class="my-4">
                    <p><fmt:message key="clickChallenge" /></p>
                    <a class="btn btn-primary btn-lg" href="./challenges.jsp?sort=default" role="button"><fmt:message key="challengeList" /></a>
                </div>
                
                <div class="section">
                    <h1 class="display-4"><a style="color: inherit; text-decoration: none;"><fmt:message key="myChallenge" /></a></h1>
                    <hr class="my-4">
                    <p><fmt:message key="cListMessage" /></p>
                    <a class="btn btn-primary btn-lg" href="./myChallenge.jsp?sort=default" role="button"><fmt:message key="myChallenge" /></a>
                </div>
                
                <div class="section">
                    <h1 class="display-4"><a style="color: inherit; text-decoration: none;"><fmt:message key="board" /></a></h1>
                    <hr class="my-4">
                    <p><fmt:message key="boardMessage" /></p>
                    <a class="btn btn-primary btn-lg" href="./list.jsp" role="button"><fmt:message key="board" /></a>
                </div>

                
                <div class="section">
                    <h1 class="display-4"><a style="color: inherit; text-decoration: none;"><fmt:message key="store" /></a></h1>
                    <hr class="my-4">
                    <p><fmt:message key="shopMessage" /></p>
                    <a class="btn btn-primary btn-lg" href="./shop.jsp" role="button"><fmt:message key="store" /></a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="./resources/js/bootstrap.bundle.min.js"></script>
</fmt:bundle>
</body>
</html>
