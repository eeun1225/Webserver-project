<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>목록</title>
<script type="text/javascript">
function changeSort() {
    var selectBox = document.getElementById("sortSelect");
    var selectedValue = selectBox.options[selectBox.selectedIndex].value;
    location.href = "challenges.jsp?sort=" + selectedValue;
}
</script>
</head>
<body>
<fmt:setLocale value='<%= request.getParameter("language") %>'/>
<fmt:bundle basename="bundle.message" >
<%@ include file="navbar.jsp" %>
<div style="margin-bottom: 45px;"></div>
<div class="container content-container">
    <div class="jumbotron jumbotron-custom">
        <%@ include file= "dbconn.jsp" %>
        <div class="text-end">
    		<a href="?language=ko">Korean</a> | <a href="?language=en">English</a> 
    	</div>
        <div class="row">
            <div class="col-sm-2">
                <select id="sortSelect" name="sortSelect" class="form-select" onchange="changeSort()">
                    <option value="default" <%= "default".equals(request.getParameter("sort")) ? "selected" : "" %>><fmt:message key="DefaultOrder" /></option>
                    <option value="highToLow" <%= "highToLow".equals(request.getParameter("sort")) ? "selected" : "" %>><fmt:message key="HighestCoinFirst" /></option>
                    <option value="lowToHigh" <%= "lowToHigh".equals(request.getParameter("sort")) ? "selected" : ""%>><fmt:message key="LowestCoinFirst" /></option>
                    <option value="deadline" <%= "deadline".equals(request.getParameter("sort")) ? "selected" : ""%>><fmt:message key="ClosingSoon" /></option>
                </select>
            </div>
            <div class="col-sm-2 text-end">
                <a href="./addChallenge.jsp" class="btn btn-warning"><fmt:message key="AddChallenge" /></a>
            </div>
        </div>
        <div style="margin-bottom: 30px;"></div> 
    </div>
    <div class="row align-items-md-stretch text-center">
        <%
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String sql = "SELECT * FROM challenge"; // 기본 쿼리
            String sort = request.getParameter("sort");

            if (sort != null) {
                if (sort.equals("lowToHigh")) {
                    sql += " ORDER BY coin ASC";
                } else if (sort.equals("highToLow")) {
                    sql += " ORDER BY coin DESC";
                } else if(sort.equals("deadline")){
                	sql += " ORDER BY due_date ASC";
                }
            }

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()){
        %>
        <div class="col-md-4">
            <div class="h-100 p-2 card">
                <h5 class="card-title"><b><%=rs.getString("title") %></b></h5>
                <p class="card-text"><b><%=rs.getString("category") %>&emsp;<%=rs.getInt("coin") %><fmt:message key="coin" /></b></p>
                <p class="card-text"><%=rs.getInt("count") %>/<%=rs.getInt("capacity") %></p>
                <p class="card-text"><b><%=rs.getDate("due_date") %></b></p>
                <% 
                    Date currentDate = new Date();
                    Date dueDate = rs.getDate("due_date");
                %>
                <% 
                	if (dueDate != null && currentDate.after(dueDate)) { 
                %>
                    <span class="badge bg-danger"><fmt:message key="End" /></span>
                <% 
                	} else if (rs.getInt("count") == rs.getInt("capacity")) { 
                %>
                    <span class="badge bg-warning"><fmt:message key="Close" /></span>
                <% 
                	} else { 
                %>
                    <a href="./challenge.jsp?id=<%=rs.getString("c_id")%>" class="btn btn-primary" role="button"><fmt:message key="moreInfo" /> &raquo;</a>
                <% 
                	} 
                %>
            </div>
        </div>
        <%
            }
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        %>
    </div>
</div>
</fmt:bundle>
</body>
</html>
