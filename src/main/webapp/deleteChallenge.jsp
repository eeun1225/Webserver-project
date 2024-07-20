<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ include file="dbconn.jsp" %>
<%
    String c_id = request.getParameter("id");
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    boolean canDelete = false; // 삭제 가능 여부를 저장하는 변수

    // 챌린지 종료 여부 확인
    String sql = "SELECT * FROM challenge WHERE c_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, c_id);
    rs = pstmt.executeQuery();
    if (rs.next()) {
        Date currentDate = new Date();
        Date dueDate = rs.getDate("due_date");
        if (dueDate != null && currentDate.before(dueDate)) {
            canDelete = true; // 아직 종료되지 않은 챌린지는 삭제 가
        }
    }
    

    // 참여자 여부 확인
    if (canDelete) {
        sql = "SELECT * FROM participation WHERE challenge_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, c_id);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            canDelete = false; // 챌린지에 참여자가 있는 경우 삭제 불가능
        }
    }

    if (canDelete) {
        // 삭제 가능한 경우 챌린지 삭제
        sql = "DELETE FROM challenge WHERE c_id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, c_id);
        pstmt.executeUpdate();
        out.println("<script>alert('챌린지가 성공적으로 삭제되었습니다.'); location.href='challenges.jsp';</script>");
    } else {
        // 삭제 불가능한 경우 알림 출력
        out.println("<script>alert('이 챌린지를 삭제할 수 없습니다. 종료되지 않았거나 참여자가 있습니다.'); history.back();</script>");
    }

    if (rs != null)
        rs.close();
    if (pstmt != null)
        pstmt.close();
    if (conn != null)
        conn.close();
%>
