<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("pageTitle", "Không tìm thấy"); %>
<%@ include file="header.jspf" %>
<section class="card narrow"><h1>Không tìm thấy thông tin</h1><p>Trang hoặc khách hàng bạn yêu cầu không tồn tại.</p><a class="button secondary" href="<%= request.getContextPath() %>/">Về trang chủ</a></section>
<%@ include file="footer.jspf" %>
