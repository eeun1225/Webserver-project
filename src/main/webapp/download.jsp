<%@ page import="java.io.*" %>
<%@ page import="org.apache.commons.io.*" %>

<%
    String filePath = request.getParameter("filePath");
    filePath = java.net.URLDecoder.decode(filePath, "UTF-8");
    File file = new File(filePath);

    if (!file.exists()) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
        return;
    }

    String mimeType = application.getMimeType(filePath);
    if (mimeType == null) {
        mimeType = "application/octet-stream";
    }

    response.setContentType(mimeType);
    response.setContentLength((int) file.length());

    String headerKey = "Content-Disposition";
    String headerValue = String.format("attachment; filename=\"%s\"", file.getName());
    response.setHeader(headerKey, headerValue);

    try (InputStream inStream = new FileInputStream(file);
         OutputStream outStream = response.getOutputStream()) {
        IOUtils.copy(inStream, outStream);
    }
%>
