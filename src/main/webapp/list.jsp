<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="dbconn.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="navbar.jsp" %>
<html>
<head>
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
    <link rel="stylesheet" href="./resources/css/styles.css" />
    <title>게시판</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
    <div class="container mt-5">
        <h1 class="my-4"><fmt:message key="board" /></h1>
        <div class="text-end">
    		<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    	</div>
        
        <%
            String memberId = (String) session.getAttribute("memberId");
            if (memberId != null) {
        %>
            <div class="mb-4">
                <a href="createPost.jsp" class="btn btn-primary"><fmt:message key="write" /></a>
            </div>
        <%
            } else {
            	response.sendRedirect("loginMember.jsp");
            	return;    	
            }
        %>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th><fmt:message key="number" /></th>
                    <th><fmt:message key="title" /></th>
                    <th><fmt:message key="writer" /></th>
                    <th><fmt:message key="createdAt" /></th>
                    <th><fmt:message key="action" /></th>
                </tr>
            </thead>
            <tbody>
                <%
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    List<Map<String, Object>> postList = new ArrayList<>();
                    String sql = "SELECT * FROM post ORDER BY created_at DESC";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery(sql);

                    while (rs.next()) {
                        Map<String, Object> post = new HashMap<>();
                        post.put("id", rs.getInt("id"));
                        post.put("title", rs.getString("title"));
                        post.put("author", rs.getString("author"));
                        post.put("created_at", rs.getTimestamp("created_at"));
                        postList.add(post);
                    }
                    
                    for (Map<String, Object> post : postList) {
                %>
                <tr>
                    <td><%= post.get("id") %></td>
                    <td><a href="viewPost.jsp?id=<%= post.get("id") %>"><%= post.get("title") %></a></td>
                    <td><%= post.get("author") %></td>
                    <td><%= post.get("created_at") %></td>
                    <td>
                        <%
                            String postAuthor = (String) post.get("author");
                            if (memberId != null && memberId.equals(postAuthor)) {
                        %>
                        <a href="editPost.jsp?id=<%= post.get("id") %>" class="btn btn-warning"><fmt:message key="modify" /></a>
                        <a href="deletePost.jsp?id=<%= post.get("id") %>" class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');"><fmt:message key="delete" /></a>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                		if (rs != null) rs.close();
                		if (pstmt != null) pstmt.close();
                		if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</fmt:bundle>
</body>
</html>
