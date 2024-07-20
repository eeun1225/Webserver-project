<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ include file="dbconn.jsp" %>

<%	
	String challenge_id = request.getParameter("id");
	String participant_id = (String)session.getAttribute("memberId");
	String path = File.separator + "resources" + File.separator + challenge_id + File.separator + participant_id;
	String realFolder = application.getRealPath(path);
	
	File uploadDir = new File(realFolder);
		
	if (!uploadDir.exists()) {
		uploadDir.mkdirs();
	}
	
	Calendar today = Calendar.getInstance();
    int year = today.get(Calendar.YEAR);
    int month = today.get(Calendar.MONTH) + 1; // 월은 0부터 시작하므로 1을 더함
    int day = today.get(Calendar.DAY_OF_MONTH);
    String todayDate = year + "-" + month + "-" + day;
    
    // 해당 사용자가 오늘 이미 인증한 기록이 있는지 확인
    String sql = "SELECT * FROM certifications WHERE participant_id = ? AND DATE(upload_date) = ?";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, participant_id);
    pstmt.setString(2, todayDate);
    ResultSet rs = pstmt.executeQuery();
   
    if (rs.next()) {
        // 이미 오늘 인증한 경우
    	 out.println("<script>alert('이미 오늘의 인증을 완료했습니다!\\n내일 인증해주세요!'); location.href = 'challenge.jsp?id=" + challenge_id + "';</script>");
    } else {

    	String fileType = "";
    	String status = null;
    	String filePath = "";
    	
    	String textContent = request.getParameter("textContent");
        if (textContent != null && !textContent.isEmpty()) {
            // 텍스트 내용을 파일로 저장
            String textFilePath = realFolder + File.separator + "text_content.txt";
            BufferedWriter writer = new BufferedWriter(new FileWriter(textFilePath));
            writer.write(textContent);
            writer.close();
            
            // 파일 경로와 타입 설정
            filePath = textFilePath;
            fileType = "text/plain"; // 텍스트 파일인 경우의 MIME 타입
        } else {
        	DiskFileUpload upload = new DiskFileUpload();
        	
        	List items = upload.parseRequest(request);
        	
        	Iterator params = items.iterator();
        	
        	while(params.hasNext()){
        		FileItem fileItem = (FileItem) params.next();
        		if(!fileItem.isFormField()){
        			String fileName = fileItem.getName();
        			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
        			filePath = realFolder + File.separator + fileName;
        			File file = new File(filePath);
        			fileItem.write(file);
        			fileType = fileItem.getContentType();
        		}
        	}	
        }
    	
    	sql = "INSERT INTO certifications (challenge_id, participant_id, file_path, file_type, status) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, challenge_id);
        pstmt.setString(2, participant_id);
        pstmt.setString(3, filePath);
        pstmt.setString(4, fileType);
        pstmt.setString(5, status);
        pstmt.executeUpdate();
    	
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
        
        out.println("<script>alert('인증이 완료되었습니다!');</script>");
        out.println("<script>location.href = 'challenge.jsp?id=" + challenge_id + "'</script>");
    }

%>
