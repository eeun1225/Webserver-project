<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ include file= "dbconn.jsp" %>
<%
    String challenge_id = request.getParameter("id");
    String participant_id = (String) session.getAttribute("memberId");
    int frequency = 0, coin = 0, days = 0;
    String period = null, title = null;
    java.sql.Date start_date = null, end_date = null;
    String status = null;

    String sql = "SELECT * FROM challenge WHERE c_id=?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, challenge_id);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        frequency = rs.getInt("frequency");
        coin = rs.getInt("coin");
        period = rs.getString("period");
        title = rs.getString("title");

        String periodUnit = period.substring(1);

        if ("일".equals(periodUnit)) {
            days = Integer.parseInt(period.substring(0, 1));
        } else if ("주일".equals(periodUnit)) {
            days = Integer.parseInt(period.substring(0, 1)) * 7;
        } else if ("개월".equals(periodUnit)) {
            days = Integer.parseInt(period.substring(0, 1)) * 30;
        } else if ("년".equals(periodUnit)) {
            days = Integer.parseInt(period.substring(0, 1)) * 365;
        }
    }

    sql = "SELECT * FROM participation WHERE challenge_id=? AND participant_id=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, challenge_id);
    pstmt.setString(2, participant_id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        start_date = rs.getDate("start_date");
        end_date = rs.getDate("end_date");
        status = rs.getString("status");
    }

    java.util.Date currentDate = new java.util.Date();
    java.sql.Date sqlCurrentDate = new java.sql.Date(currentDate.getTime());

	if (sqlCurrentDate.before(end_date)) {
        out.println("<script>alert('챌린지가 아직 진행 중입니다.'); history.back();</script>");
    } else if ("포기".equals(status)) {
        out.println("<script>alert('이미 포기한 챌린지입니다.'); location.href='myChallenge.jsp';</script>");
    } else if ("성공".equals(status)) {
        out.println("<script>alert('이미 성공한 챌린지입니다.'); location.href='myChallenge.jsp';</script>");
    } else {
    	sql = "SELECT COUNT(*) AS count FROM certifications WHERE challenge_id = ? AND participant_id = ? AND upload_date BETWEEN ? AND ? AND status = 'approved'";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, challenge_id);
        pstmt.setString(2, participant_id);
        pstmt.setDate(3, start_date);
        pstmt.setDate(4, end_date);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int certificationCount = rs.getInt("count");
            int requiredCertifications = 0;

            // 총 필요한 인증 횟수 계산
            if (days < 7) {
    			requiredCertifications = frequency;
			} else {
    			requiredCertifications = (days * frequency) / 7;
			}

            if (certificationCount >= requiredCertifications) {
                // 코인이 아직 지급되지 않은 경우에만 지급
                sql = "UPDATE member SET coin = coin + ? WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, coin * 2);
                pstmt.setString(2, participant_id);
                pstmt.executeUpdate();

                sql = "UPDATE participation SET status=? WHERE challenge_id = ? AND participant_id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "성공");
                pstmt.setString(2, challenge_id);
                pstmt.setString(3, participant_id);
                pstmt.executeUpdate();

                out.println("<script>alert('" + title + " 챌린지 성공! " + coin * 2 + " 코인이 지급되었습니다.'); location.href='myChallenge.jsp';</script>");
            } else {
                sql = "UPDATE participation SET status=? WHERE challenge_id = ? AND participant_id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "실패");
                pstmt.setString(2, challenge_id);
                pstmt.setString(3, participant_id);
                pstmt.executeUpdate();

                out.println("<script>alert('" + title + " 챌린지를 실패하셨습니다.'); location.href='myChallenge.jsp';</script>");
            }
        }
    }

    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();
%>
