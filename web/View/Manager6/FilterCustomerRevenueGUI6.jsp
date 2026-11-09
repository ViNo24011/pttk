<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
if (session.getAttribute("currentUser") == null) {
    response.sendRedirect(request.getContextPath() + "/View/SystemUser6/LoginGUI6.jsp?required=1"); return;
}
if (!(session.getAttribute("currentUser") instanceof Model.Manager6)) { response.sendError(403); return; }
%>
<% request.setCharacterEncoding("UTF-8"); %>
<% request.setAttribute("pageTitle", "Chọn khoảng thời gian thống kê"); %>
<%@ include file="/WEB-INF/views/header.jspf" %>
    <div class="page-heading narrow">
      <h1>THỐNG KÊ KHÁCH HÀNG</h1>
      <h2>Chọn khoảng thời gian thống kê</h2>
      <p>Xem doanh thu từ các giao dịch đã hoàn thành.</p>
    </div>
<section class="card narrow">
    <% if (request.getAttribute("filterError") != null) { %><div class="alert error" role="alert"><%= h(request.getAttribute("filterError")) %></div><% } %>
    <form action="CustomerRevenueReportGUI6.jsp" method="get">
        <div class="form-grid">
            <div class="field"><label for="fromDate">Ngày bắt đầu</label><input id="fromDate" name="fromDate" type="date" min="1000-01-01" max="9998-12-31" value="<%= h(param(request,"fromDate")) %>" required></div>
            <div class="field"><label for="toDate">Ngày kết thúc</label><input id="toDate" name="toDate" type="date" min="1000-01-01" max="9998-12-31" value="<%= h(param(request,"toDate")) %>" required></div>
        </div>
        <p class="hint">Bao gồm cả ngày bắt đầu và ngày kết thúc.</p>
        <div class="actions"><button class="button primary" type="submit">Xem thống kê</button><a class="button secondary" href="SelectReportGUI6.jsp">Quay lại</a></div>
    </form>
</section>
<%@ include file="/WEB-INF/views/footer.jspf" %>
