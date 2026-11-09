<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% request.setAttribute("pageTitle", "Không thể xử lý yêu cầu"); if (exception != null) application.log("Unhandled request failure", exception); %>
<%@ include file="header.jspf" %>
<section class="card narrow"><h1>Chưa thể xử lý yêu cầu</h1><p>Vui lòng thử lại sau hoặc quay về trang chủ.</p><a class="button secondary" href="<%= request.getContextPath() %>/">Về trang chủ</a></section>
<%@ include file="footer.jspf" %>
