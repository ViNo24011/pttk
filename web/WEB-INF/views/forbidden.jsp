<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("pageTitle", "Không có quyền truy cập"); %>
<%@ include file="header.jspf" %>
<section class="card narrow"><h1>Không có quyền truy cập</h1><p>Chỉ tài khoản quản lý được xem báo cáo thống kê.</p><a class="button secondary" href="<%= request.getContextPath() %>/">Về trang chủ</a></section>
<%@ include file="footer.jspf" %>
