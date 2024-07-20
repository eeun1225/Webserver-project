<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="navbar.jsp" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="./resources/css/bootstrap.min.css">
    <link rel="stylesheet" href="./resources/css/styles.css">
    <title>목록</title>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<div class="container py-4">
	 <div class="text-end">
    		<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    	</div>
    <div class="jumbotron jumbotron-custom">
        <div class="container">
            <!-- 내가 만든 챌린지 섹션 -->
            <div class="section">
                <h1 class="display-5 fw-bold">내가 만든 챌린지</h1>
                <%@ include file= "dbconn.jsp" %>
                <div class="row">
                    <%
                        String member_Id = (String) session.getAttribute("memberId");    
                        if (member_Id == null) {
                            response.sendRedirect("loginMember.jsp");
                            return;
                        }
                        
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        String sql = "SELECT * FROM challenge WHERE user_id = ?"; // 내가 만든 챌린지

                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, member_Id);
                        rs = pstmt.executeQuery();

                        boolean hasCreatedChallenges = false;
                        int count = 0;
                        while(rs.next()){
                            hasCreatedChallenges = true;
                            if (count % 3 == 0 && count != 0) {
                    %>
                    </div><div class="row">
                    <%
                            }
                    %>
                    <div class="col-md-4">
                        <div class="card mb-4 shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">
                                    <%=rs.getString("title") %>
                                    <%
                                        Date currentDate = new Date();
                                        Date dueDate = rs.getDate("due_date");
                                        if (dueDate != null && currentDate.after(dueDate)) {
                                    %>
                                        <span class="badge bg-danger"><fmt:message key="End" /></span>
                                    <% 
                                        } 
                                    %>
                                </h5>
                                <p class="card-text">
                                    <b>카테고리 - <%=rs.getString("category") %></b><br>
                                    <%=rs.getInt("coin") %> <fmt:message key="coin" /><br>
                                    <%=rs.getInt("count") %>/<%=rs.getInt("capacity") %><br>
                                    <b><%=rs.getDate("due_date") %></b>
                                </p>
                               	<a href="./challenge.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-secondary btn-custom"><fmt:message key="moreInfo" /> &raquo;</a>
                                <a href="./evaluateCertification.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-secondary btn-custom"><fmt:message key="evaluate" />&raquo;</a>
                            </div>
                        </div>
                    </div>
                    <%
                            count++;
                        }
                        if (!hasCreatedChallenges) {
                    %>
                        <div class="col-12">
                            <p>아직 만든 챌린지가 없습니다. 새로운 챌린지를 만들어보세요!</p>
                            <a href="./addChallenge.jsp" class="btn btn-primary btn-custom"><fmt:message key="AddChallenge" /></a>
                        </div>
                    <%
                        }
                        if(rs != null) rs.close();
                        if(pstmt != null) pstmt.close();
                    %>
                </div>
            </div>
            <hr class="my-4">
            <!-- 내가 참여 중인 챌린지 섹션 -->
            <div class="section">
                <h1 class="display-5 fw-bold">내가 참여 중인 챌린지</h1>
                <div class="row">
                    <%
                        sql = "SELECT c.*, p.end_date, p.status FROM challenge c " +
                              "JOIN participation p ON c.c_id = p.challenge_id " +
                              "WHERE p.participant_id = ?"; // 내가 참여 중인 챌린지

                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, member_Id);
                        rs = pstmt.executeQuery();

                        boolean hasJoinedChallenges = false;
                        count = 0;
                        while(rs.next()){
                            hasJoinedChallenges = true;
                            if (count % 3 == 0 && count != 0) {
                    %>
                    </div><div class="row">
                    <%
                            }
                    %>
                    <div class="col-md-4">
                        <div class="card mb-4 shadow-sm">
                            <div class="card-body text-center">
                                <h5 class="card-title">
                                    <%=rs.getString("title") %>
                                    <%
                                        Date currentDate = new Date();
                                        Date dueDate = rs.getDate("due_date");
                                        if (dueDate != null && currentDate.after(dueDate)) {
                                    %>
                                        <span class="badge bg-danger"><fmt:message key="End" /></span>
                                    <% 
                                        } 
                                    %>
                                </h5>
                                <p class="card-text">
                                    <b><%=rs.getString("category") %></b><br>
                                    <%=rs.getInt("coin") %> <fmt:message key="coin" /><br>
                                    <%=rs.getInt("count") %>/<%=rs.getInt("capacity") %><br>
                                    <b><%=rs.getDate("end_date") %></b>
                                </p>
                                <a href="./challenge.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-secondary btn-custom"><fmt:message key="moreInfo" /> &raquo;</a>
                                <%
                					String status = rs.getString("status");
                					if (status != null) {
                    					if (status.equals("포기")) {
            					%>
                					<span class="badge bg-warning" style="font-size: larger;"><fmt:message key="giveup" /></span>
            					<%
                    					} else if (status.equals("성공")) {
            					%>
                					<span class="badge bg-success" style="font-size: larger;"><fmt:message key="success" /></span>
            					<%
                    					} else if (status.equals("실패")) {
            					%>
                					<span class="badge bg-danger" style="font-size: larger;"><fmt:message key="failure" /></span>
            					<%
                						} else if (status.equals("진행중")) { 
            					%>
                					<a href="./resultChallenge.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-secondary btn-custom"><fmt:message key="progress" /> &raquo;</a>
            					<%
                						}
                					}
            					%>
                            </div>
                        </div>
                    </div>
                    <%
                            count++;
                        }
                        if (!hasJoinedChallenges) {
                    %>
                        <div class="col-12">
                            <p>아직 참여 중인 챌린지가 없습니다. 새로운 챌린지에 참여해보세요!</p>
                            <a href="./challenges.jsp" class="btn btn-primary btn-custom"><fmt:message key="challengeList" /></a>
                        </div>
                    <%
                        }
                        if(rs != null) rs.close();
                        if(pstmt != null) pstmt.close();
                        if(conn != null) conn.close();
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="./resources/js/bootstrap.bundle.min.js"></script>
</fmt:bundle>
</body>
</html>
