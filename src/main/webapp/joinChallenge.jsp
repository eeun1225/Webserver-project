<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file = "dbconn.jsp" %>

<%
	request.setCharacterEncoding("utf-8");
	
	String challenge_id = request.getParameter("id");
	String participant_id = (String)session.getAttribute("memberId");
	String period = null;
	int challengeCoin = 0, participantCoin = 0, count = 0;
	
	String sql = "SELECT * FROM challenge WHERE c_id = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, challenge_id);
	ResultSet rs = pstmt.executeQuery();
	
	if(rs.next()){
		challengeCoin = rs.getInt("coin");
		count = rs.getInt("count");
		period = rs.getString("period");	
	}

	sql = "SELECT * FROM member WHERE id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, participant_id);
	rs = pstmt.executeQuery();
	
	if(rs.next()) {
		participantCoin = rs.getInt("coin");
	}
	
	sql = "SELECT * FROM participation WHERE challenge_id = ? AND participant_id = ?";
	pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, challenge_id);
    pstmt.setString(2, participant_id);
    rs = pstmt.executeQuery();
   
    if (!rs.next()) {
    	if(challengeCoin <= participantCoin){
    		sql = "INSERT INTO participation(challenge_id, participant_id, start_date, end_date, status) VALUES (?, ?, ?, ?, ?)";
    		
        	java.util.Date currentDate = new java.util.Date();
        	java.sql.Date start_date = new java.sql.Date(currentDate.getTime());
        	String status = "진행중";
        	
        	Calendar calendar = Calendar.getInstance();
        	calendar.setTime(currentDate);

        	if (period.equals("3일")) {
        	    calendar.add(Calendar.DAY_OF_MONTH, 3); // 3일 추가
        	} else if (period.equals("1주일")) {
        	    calendar.add(Calendar.WEEK_OF_YEAR, 1); // 1주일 추가
        	} else if (period.equals("2주일")) {
        	    calendar.add(Calendar.WEEK_OF_YEAR, 2); // 2주일 추가
        	} else if (period.equals("1개월")) {
        	    calendar.add(Calendar.MONTH, 1); // 1개월 추가
        	} else if (period.equals("3개월")) {
        	    calendar.add(Calendar.MONTH, 3); // 3개월 추가
        	} else if (period.equals("6개월")) {
        	    calendar.add(Calendar.MONTH, 6); // 6개월 추가
        	} else if (period.equals("1년")) {
        	    calendar.add(Calendar.YEAR, 1); // 1년 추가
        	}

        	java.sql.Date end_date = new java.sql.Date(calendar.getTimeInMillis());
      
        	pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, challenge_id);
            pstmt.setString(2, participant_id);
            pstmt.setDate(3, start_date);
            pstmt.setDate(4, end_date);
            pstmt.setString(5, status);
            pstmt.executeUpdate();
            
            sql = "UPDATE member SET coin=? WHERE id=?";
            pstmt =conn.prepareStatement(sql);
            pstmt.setInt(1, participantCoin - challengeCoin);
            pstmt.setString(2, participant_id);
            pstmt.executeUpdate();
            
            sql = "UPDATE challenge SET count=? WHERE c_id=?";
    		pstmt = conn.prepareStatement(sql);
    		pstmt.setInt(1, count +  1);
    		pstmt.setString(2, challenge_id);
    		pstmt.executeUpdate();
            
            
            out.println("<script>alert('챌린지 참여가 완료되었습니다!');</script>");
    	} else {
    		out.println("<script>alert('참여 가능한 코인이 부족합니다.');</script>");
            out.println("<script>location.href = 'challenge.jsp?id=" + challenge_id + "'</script>");
            return;
    	}
    } 
	
    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
    
    out.println("<script>location.href = 'challenge.jsp?id=" + challenge_id + "'</script>");
%>