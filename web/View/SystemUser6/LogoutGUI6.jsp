<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
if (!"POST".equals(request.getMethod())) { response.setHeader("Allow", "POST"); response.sendError(405); return; }
if (!validCsrf(request)) { response.sendError(403); return; }
session.invalidate(); response.sendRedirect(request.getContextPath() + "/View/SystemUser6/LoginGUI6.jsp");
%>
