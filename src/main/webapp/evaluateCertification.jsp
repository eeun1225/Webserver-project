<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="dbconn.jsp" %>
<%@ include file="navbar.jsp" %>
<html>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<head>
    <meta charset="UTF-8">
    <title>인증 평가</title>
</head>
<body>
<div class="container py-4">
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5"> 
            <h1 class="display-5 fw-bold">챌린지 인증 평가</h1>
        </div>
    </div>
     <a href="./myChallenge.jsp" class="btn btn-secondary">뒤로가기 &raquo;</a>
    <table border="1">
        <tr>
            <th>참가자 ID</th>
            <th>&nbsp;파일 경로&nbsp;</th>
            <th>&nbsp;파일 타입&nbsp;</th>
            <th>&nbsp;업로드 날짜&nbsp;</th>
            <th>&nbsp;승인&nbsp;</th>
            <th>&nbsp;거부&nbsp;</th>
        </tr>
        <%
        	String challenge_id = request.getParameter("id");
        	String sql = "SELECT * FROM certifications WHERE challenge_id=? AND status IS NULL";
        	PreparedStatement pstmt = conn.prepareStatement(sql);
        	pstmt.setString(1, challenge_id);
        	ResultSet rs = pstmt.executeQuery();
        
            while (rs.next()) {
            	String id = rs.getString("id");
                String participant_id = rs.getString("participant_id");
                String filePath = rs.getString("file_path");
                String fileType = rs.getString("file_type");
                Timestamp uploadDate = rs.getTimestamp("upload_date");
        %>
        <tr>
            <td><%= participant_id %></td>
            <td>
            	<%
                    if ("text/plain".equals(fileType)) {
                        // 텍스트 파일 내용 읽기
                        File file = new File(filePath);
                        BufferedReader reader = new BufferedReader(new FileReader(file));
                        String line;
                        while ((line = reader.readLine()) != null) {
                            out.println(line + "<br>");
                        }
                        reader.close();
                    } else {
                %>
                       	<a href="download.jsp?filePath=<%= java.net.URLEncoder.encode(filePath, "UTF-8") %>"><%= filePath %>
                <%
                    }
                %>
            </td>
            <td><%= fileType %></td>
            <td><%= uploadDate %></td>
            <td>
                <form action="updateCertification.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="challenge_id" value="<%= challenge_id %>">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="status" value="approved">
                    <button type="submit">승인</button>
                </form>
            </td>
            <td>
                <form action="updateCertification.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="challenge_id" value="<%= challenge_id %>">
                    <input type="hidden" name="id" value="<%= id %>">
                    <input type="hidden" name="status" value="rejected">
                    <button type="submit">거부</button>
                </form>
            </td>
        </tr>
        <%
            }
            rs.close();
            pstmt.close();
        %>
    </table>
</div>
</body>
</html>
