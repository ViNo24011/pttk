<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="DAO.CustomerRevenueStatDAO,Model.CustomerRevenueStat6,java.time.LocalDate,java.util.List,java.math.BigDecimal,java.sql.SQLException" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
if (session.getAttribute("currentUser") == null) {
    response.sendRedirect(request.getContextPath() + "/View/SystemUser6/LoginGUI6.jsp?required=1"); return;
}
if (!(session.getAttribute("currentUser") instanceof Model.Manager6)) {
    response.sendError(403); return;
}

LocalDate fromDate, toDate;
try {
    fromDate = parseDate(request.getParameter("fromDate")); toDate = parseDate(request.getParameter("toDate"));
} catch (IllegalArgumentException ex) {
    request.setAttribute("filterError", ex.getMessage()); request.getRequestDispatcher("FilterCustomerRevenueGUI6.jsp").forward(request,response); return;
}
request.setAttribute("pageTitle", "Thống kê khách hàng theo doanh thu");
List<CustomerRevenueStat6> revenueStats = List.of();
String error = "";
try (CustomerRevenueStatDAO dao = new CustomerRevenueStatDAO()) { revenueStats = dao.getCustomerRevenueStat(fromDate, toDate); }
catch (IllegalArgumentException ex) {
    request.setAttribute("filterError", ex.getMessage());
    request.getRequestDispatcher("FilterCustomerRevenueGUI6.jsp").forward(request, response);
    return;
} catch (SQLException ex) { application.log("Revenue report failed", ex); error = "Chưa thể tải dữ liệu thống kê. Vui lòng thử lại sau."; }
// Giữ các đối tượng khách hàng của từng kỳ báo cáo để trang chi tiết nhận lại.
if (error.isEmpty()) {
    session.setAttribute("revenueCustomers:" + fromDate + ":" + toDate, revenueStats);
}
int sumTransactions = 0;
BigDecimal sumRevenue = BigDecimal.ZERO;
for (CustomerRevenueStat6 stat : revenueStats) { sumTransactions += stat.getTotalTransactions(); sumRevenue = sumRevenue.add(stat.getTotalRevenue()); }
String range = rangeQuery(fromDate, toDate);
%>
<%@ include file="/WEB-INF/views/header.jspf" %>
<div class="page-heading"><span class="eyebrow">BÁO CÁO KHÁCH HÀNG</span><h1>Thống kê khách hàng theo doanh thu</h1>
    <p>Ngày bắt đầu: <strong><%= date(fromDate) %></strong><span class="separator">·</span>Ngày kết thúc: <strong><%= date(toDate) %></strong></p></div>
<% if (!error.isEmpty()) { %><div class="alert error" role="alert"><%= h(error) %></div><% } else { %>
<div class="metrics">
    <div class="metric"><span>Khách hàng</span><strong><%= revenueStats.size() %></strong></div>
    <div class="metric"><span>Số lần giao dịch</span><strong><%= sumTransactions %></strong></div>
    <div class="metric"><span>Tổng doanh thu</span><strong><%= money(sumRevenue) %> <small>VND</small></strong></div>
</div>
<section class="card table-card">
    <div class="section-heading"><h2>Danh sách khách hàng</h2><span>Doanh thu giảm dần</span></div>
    <div class="table-scroll"><table>
        <thead><tr><th scope="col">STT</th><th scope="col">Mã KH</th><th scope="col">Họ tên khách hàng</th><th scope="col">Số điện thoại</th><th scope="col" class="number">Số lần GD</th><th scope="col" class="number">Tổng doanh thu (VND)</th></tr></thead>
        <tbody>
        <% if (revenueStats.isEmpty()) { %><tr><td colspan="6" class="empty">Không có dữ liệu giao dịch trong khoảng thời gian đã chọn.</td></tr><% } %>
        <% int row = 0; for (CustomerRevenueStat6 stat : revenueStats) { %>
        <tr><td class="muted"><%= ++row %></td><td><%= h(stat.getCustomerCode()) %></td>
            <td><a class="customer-link" href="CustomerTransactionDetailGUI6.jsp?customerCode=<%= url(stat.getCustomerCode()) %>&amp;<%= h(range) %>"><%= h(stat.getFullName()) %></a></td>
            <td><%= h(stat.getPhone()) %></td><td class="number"><%= stat.getTotalTransactions() %></td><td class="number amount"><%= money(stat.getTotalRevenue()) %></td></tr>
        <% } %>
        </tbody>
        <tfoot><tr><th colspan="4" scope="row">Tổng</th><td class="number"><%= sumTransactions %></td><td class="number"><%= money(sumRevenue) %></td></tr></tfoot>
    </table></div>
</section>
<% } %>
<div class="actions"><a class="button secondary" href="FilterCustomerRevenueGUI6.jsp?<%= h(range) %>">← Quay lại</a></div>
<%@ include file="/WEB-INF/views/footer.jspf" %>
