<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%
    // 세션을 무효화하여 모든 세션 속성을 제거
    session.invalidate();

    // 메인 화면으로 리디렉션
    response.sendRedirect("main.jsp");
%>
