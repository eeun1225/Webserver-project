<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>상세 정보</title>
<script>
    function confirmGiveUp(challengeId, coin) {
        if (confirm('포인트가 ' + (coin / 2) + ' 차감됩니다.\n정말 포기하시겠습니까?')) {
            window.location.href = './giveUp.jsp?id=' + challengeId + '&coin=' + (coin / 2);
        }
    }
</script>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<div class="container py-4">
    <div class="text-end">
            <a href="?language=ko&id=<%= request.getParameter("id") %>">Korean</a> | <a href="?language=en&id=<%= request.getParameter("id") %>">English</a> 
    </div>
    <button class="btn btn-secondary" onclick="history.back()"><fmt:message key="back" /> &raquo;</button>
    <%
        String c_id = request.getParameter("id");
        String login_id = (String) session.getAttribute("memberId");
        
        if(login_id == null){
            response.sendRedirect("loginMember.jsp");
            return; 
        }
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM challenge WHERE c_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, c_id);
        rs = pstmt.executeQuery();    
        if(rs.next()){
    %>
    <div class="row align-items-md-stretch">
        <div class="col-md-6">
            <p> <h2><b><%=rs.getString("title") %> </b></h2>
                <b>카테고리 - <%=rs.getString("category") %>&emsp;<%=rs.getInt("coin") %><fmt:message key="coin" />&emsp;<%=rs.getInt("count") %>/<%=rs.getInt("capacity") %></b>
                <br><%=rs.getDate("due_date") %>&emsp;주&emsp;<%=rs.getInt("frequency") %>일&emsp;<%=rs.getString("period") %>
                <br><br><%=rs.getString("description") %><br><br>
            <%
                boolean alreadyJoined = false;
                boolean hasGivenUp = false;
                boolean isEndPassed = false;
                boolean isFailed = false;
                boolean isCreator = login_id.equals(rs.getString("user_id"));
                if (!isCreator) {
                    String challenge_id = c_id;
                    String sql2 = "SELECT * FROM participation WHERE challenge_id = ? AND participant_id = ?";
                    PreparedStatement pstmt2 = conn.prepareStatement(sql2);
                    pstmt2.setString(1, challenge_id);
                    pstmt2.setString(2, login_id);
                    ResultSet rs2 = pstmt2.executeQuery();
                    if (rs2.next()) {
                        alreadyJoined = true;
                        if (rs2.getString("status").equals("포기")) {
                            hasGivenUp = true;
                            Date endDate = rs2.getDate("end_date");
                            
                            long currentTimeMillis = System.currentTimeMillis();
                            Date currentDate = new Date(currentTimeMillis);
                            isEndPassed = currentDate.after(endDate);
                        }
                        // 실패 여부 확인
                        if (rs2.getString("status").equals("실패")) {
                            isFailed = true;
                        }
                    }
                }

                if (!isCreator && !isEndPassed) {
                    if (alreadyJoined && !hasGivenUp && !isFailed) {
                        if(rs.getString("certification").equals("텍스트")) {
            %>
                            <form action="certification.jsp?id=<%=rs.getString("c_id")%>" method="post">
                                <div class="mb-3">
                                    <textarea name="textContent" id="textContent" cols="100" rows="5" class="form-control" placeholder="입력해주세요."></textarea>
                                </div>
                                <button type="submit" class="btn btn-success">업로드 &raquo;</button>
                            </form>
            <%
                        } else {
            %>
                            <form action="certification.jsp?id=<%=rs.getString("c_id")%>" method="post" enctype="multipart/form-data">
                                <div class="mb-3">
                                    <input class="form-control" type="file" id="Filename" name="Filename">
                                </div>
                                <button type="submit" class="btn btn-success">업로드 &raquo;</button>
                            </form>
            <%
                        }
            %> 
                        <button class="btn btn-danger" onclick="confirmGiveUp('<%=rs.getString("c_id")%>', <%=rs.getInt("coin")%>)">포기하기 &raquo;</button>
            <%
                    } else if (!alreadyJoined && (rs.getInt("count") < rs.getInt("capacity"))) {
            %>
                            <a href="./joinChallenge.jsp?id=<%=rs.getString("c_id")%>&coin=<%=rs.getInt("coin")%>" class="btn btn-primary">참가하기 &raquo;</a>
            <%
                    }
                } else { // 챌린지를 만든 사용자인 경우
            %>
                    <a href="./editChallenge.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-success">수정하기 &raquo;</a>
                    <a href="./deleteChallenge.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-danger">삭제하기 &raquo;</a>
            <%
                }
            %>
        </div>
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
</fmt:bundle>
</body>
</html>
