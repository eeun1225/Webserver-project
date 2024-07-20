<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ include file = "dbconn.jsp" %>

<%
    String challenge_id = request.getParameter("id");
    String participant_id = (String) session.getAttribute("memberId");
    int challengeCoin = Integer.parseInt(request.getParameter("coin"));
    int participantCoin = 0;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT * FROM participation WHERE challenge_id=? AND participant_id=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, challenge_id);
    pstmt.setString(2, participant_id);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        sql = "UPDATE participation SET status=? WHERE challenge_id=? AND participant_id=? ";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "포기");
        pstmt.setString(2, challenge_id);
        pstmt.setString(3, participant_id);
        pstmt.executeUpdate();

        sql = "SELECT * FROM member WHERE id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, participant_id);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            participantCoin = rs.getInt("coin");
        }

        sql = "UPDATE member SET coin=? WHERE id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, participantCoin + challengeCoin);
        pstmt.setString(2, participant_id);
        pstmt.executeUpdate();

        out.println("<script>alert('포인트가 차감되었습니다.');</script>");
    }

    if (rs != null) rs.close();
    if (pstmt != null) pstmt.close();
    if (conn != null) conn.close();

    out.println("<script>location.href = 'myChallenge.jsp'</script>");
%>
