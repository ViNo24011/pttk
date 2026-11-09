<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
if (session.getAttribute("currentUser") == null) {
    response.sendRedirect(request.getContextPath() + "/View/SystemUser6/LoginGUI6.jsp?required=1"); return;
}
if (!(session.getAttribute("currentUser") instanceof Model.Manager6)) { response.sendError(403); return; }
%>
<% request.setCharacterEncoding("UTF-8"); %>
<% request.setAttribute("pageTitle", "Trang chủ quản lý"); %>
<%@ include file="/WEB-INF/views/header.jspf" %>
<section class="hero card">
    <span class="eyebrow">QUẢN LÝ</span><h1>Trang chủ quản lý</h1>
    <p>Theo dõi doanh thu đóng góp và lịch sử giao dịch của khách hàng.</p>
    <a class="button primary" href="SelectReportGUI6.jsp">Xem báo cáo thống kê <span aria-hidden="true">→</span></a>
</section>
<%@ include file="/WEB-INF/views/footer.jspf" %>
