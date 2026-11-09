<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
if (session.getAttribute("currentUser") == null) {
    response.sendRedirect(request.getContextPath() + "/View/SystemUser6/LoginGUI6.jsp?required=1"); return;
}
if (!(session.getAttribute("currentUser") instanceof Model.Manager6)) { response.sendError(403); return; }
%>
<% request.setCharacterEncoding("UTF-8"); %>
<% request.setAttribute("pageTitle", "Danh mục báo cáo thống kê"); %>
<%@ include file="/WEB-INF/views/header.jspf" %>
<div class="page-heading narrow"><span class="eyebrow">BÁO CÁO</span><h1>Danh mục báo cáo thống kê</h1><p>Chọn loại báo cáo bạn muốn xem.</p></div>
<section class="card narrow">
    <form action="FilterCustomerRevenueGUI6.jsp" method="get">
        <div class="field">
            <label for="reportType">Loại thống kê</label>
            <select id="reportType" name="reportType" required>
                <option value="product" disabled>Thống kê mặt hàng — Chưa triển khai</option>
                <option value="supplier" disabled>Thống kê nhà cung cấp — Chưa triển khai</option>
                <option value="revenue" disabled>Thống kê doanh thu tổng hợp — Chưa triển khai</option>
                <option value="customerRevenue" selected>Thống kê khách hàng theo doanh thu</option>
            </select>
        </div>
        <div class="actions split"><a id="subBack" class="button secondary" href="ManagerViewGUI6.jsp">Quay lại</a><button id="subContinue" class="button primary" type="submit">Tiếp tục →</button></div>
    </form>
</section>
<%@ include file="/WEB-INF/views/footer.jspf" %>
