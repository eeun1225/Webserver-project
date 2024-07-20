<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/resources/css/styles.css">
<title>출석 체크</title>
</head>
<body>
<div class="container py-4">
    <a class="navbar-brand" href="./main.jsp">HOME</a>
    <h1 class="mb-4">출석 체크</h1>
    <div class="card">
        <div class="card-body">
            <div class="calendar">
                <table class="table table-bordered">
                    <thead class="thead-light">
                        <tr>
                            <th>일</th>
                            <th>월</th>
                            <th>화</th>
                            <th>수</th>
                            <th>목</th>
                            <th>금</th>
                            <th>토</th>
                        </tr>
                    </thead>
                    <tbody>
					<%
                        // 로그인한 사용자 정보 가져오기
                        String member_Id = (String) session.getAttribute("memberId");
    					if (member_Id == null) {
       						response.sendRedirect("loginMember.jsp");
        					return;
    					}

    					// 현재 날짜
   						Calendar calendar = Calendar.getInstance();
    					int currentYear = calendar.get(Calendar.YEAR);
    					int currentMonth = calendar.get(Calendar.MONTH) + 1;

    					// 출석 체크 처리
    					if ("POST".equalsIgnoreCase(request.getMethod())) {
        					String action = request.getParameter("action");
       							if ("attendanceCheck".equals(action)) {
           			 				String attendanceDate = request.getParameter("attendanceDate");
           			 				PreparedStatement pstmt = null;

            						String sql = "SELECT * FROM attendance WHERE participant_id = ? AND attendance_date = ?";
            						pstmt = conn.prepareStatement(sql);
           							pstmt.setString(1, member_Id);
            						pstmt.setString(2, attendanceDate);
            						ResultSet rs = pstmt.executeQuery();
            						
            						if (!rs.next()) { // 이미 출석하지 않은 경우에만 출석 처리 및 코인 지급
            							String insertSql = "INSERT INTO attendance (participant_id, attendance_date) VALUES (?, ?)";
            							pstmt = conn.prepareStatement(insertSql);
            							pstmt.setString(1, member_Id);
            							pstmt.setString(2, attendanceDate);
            							pstmt.executeUpdate();
            							
            							int coinAmount = 50; // 출석 코인
            				            String coinSql = "UPDATE member SET coin = coin + ? WHERE id = ?";
            				            pstmt = conn.prepareStatement(coinSql);
            				            pstmt.setInt(1, coinAmount);
            				            pstmt.setString(2, member_Id);
            				            pstmt.executeUpdate();
            				            
            				            out.println("<script>alert('50코인이 지급되었습니다!'); location.href='attendanceCheck.jsp';</script>");
            						} else {
            							out.println("<script>alert('이미 출석한 날짜입니다.'); location.href='attendanceCheck.jsp';</script>");
            						}
            					
            						if(rs!=null) rs.close();
            						if(pstmt != null) pstmt.close();
            						if(conn != null) conn.close();
            						
            						return;
        						}
    					}
    					// 현재 월의 출석 기록 가져오기
    					List<String> attendanceDates = new ArrayList<>();
    					PreparedStatement pstmt = null;
   	 					ResultSet rs = null;

   	 					String sql = "SELECT attendance_date FROM attendance WHERE participant_id = ?";
    					pstmt = conn.prepareStatement(sql);
    					pstmt.setString(1, member_Id);		
    					rs = pstmt.executeQuery();

    					while (rs.next()) {
        					attendanceDates.add(rs.getString("attendance_date"));
    					}
    
    					if (rs != null)  rs.close();
    					if (pstmt != null) pstmt.close(); 
    					if (conn != null) conn.close();

    					// 달력 생성
    					calendar.set(Calendar.DAY_OF_MONTH, 1);
    					int firstDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
    					int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

   						 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    
                       	int dayOfWeekCounter = 1;
                       	for (int i = 1; i <= daysInMonth + firstDayOfWeek - 1; i++) {
               	         if (dayOfWeekCounter == 1) { %><tr><% }
               	         	if (i < firstDayOfWeek) {
					%>
					<td></td>
					<%
							} else {
								String currentDate = currentYear + "-" + (currentMonth < 10 ? "0" + currentMonth : currentMonth) + "-" + ((i - firstDayOfWeek + 1) < 10 ? "0" + (i - firstDayOfWeek + 1) : (i - firstDayOfWeek + 1));
								boolean isAttendance = attendanceDates.contains(currentDate);
   								boolean isToday = sdf.format(new java.util.Date()).equals(currentDate);
                 	%>
                    <td class="<%= isAttendance ? "attendance" : isToday ? "today" : "" %>">
                    <%= isAttendance ? "출석" : i - firstDayOfWeek + 1%>
					</td>
                    <%
                        	}

                      	 	if (dayOfWeekCounter == 7) { 
                    %>
                    </tr>
                    <%
                       			dayOfWeekCounter = 0;
                       		}
                       		dayOfWeekCounter++;
                       	}
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <form action="attendanceCheck.jsp" method="post" class="text-center mt-4">
        <input type="hidden" name="action" value="attendanceCheck">
        <input type="hidden" name="attendanceDate" value="<%= sdf.format(new java.util.Date()) %>">
        <button type="submit" class="btn btn-primary">출석 체크</button>
    </form>
</div>
</body>
</html>
