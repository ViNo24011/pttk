<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="DAO.CounterInvoiceDAO,DAO.OnlineOrderDAO,Model.Customer6,Model.CounterInvoice6,Model.OnlineOrder6,java.time.LocalDate,java.time.LocalDateTime,java.time.format.DateTimeFormatter,java.math.BigDecimal,java.util.List,java.util.ArrayList,java.util.Comparator,java.sql.SQLException" %>
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
String customerCode = param(request,"customerCode");
if (customerCode.isBlank() || customerCode.length() > 30) { response.sendError(404); return; }
request.setAttribute("pageTitle", "Thống kê các lần giao dịch");
Customer6 customer = null;
Object reportCustomers = session.getAttribute("revenueCustomers:" + fromDate + ":" + toDate);
if (!(reportCustomers instanceof List<?>)) {
    response.sendRedirect("CustomerRevenueReportGUI6.jsp?" + rangeQuery(fromDate, toDate));
    return;
}
for (Object item : (List<?>) reportCustomers) {
    if (item instanceof Customer6 && customerCode.equals(((Customer6) item).getCustomerCode())) {
        customer = (Customer6) item;
        break;
    }
}
if (customer == null) { response.sendError(404); return; }
List<CounterInvoice6> counterInvoices = List.of();
List<OnlineOrder6> onlineOrders = List.of();
String error = "";
try (CounterInvoiceDAO invoiceDAO = new CounterInvoiceDAO(); OnlineOrderDAO orderDAO = new OnlineOrderDAO()) {
    counterInvoices = invoiceDAO.getCounterInvoice(customerCode, fromDate, toDate);
    onlineOrders = orderDAO.getOnlineOrder(customerCode, fromDate, toDate);
} catch (IllegalArgumentException ex) {
    request.setAttribute("filterError", ex.getMessage());
    request.getRequestDispatcher("FilterCustomerRevenueGUI6.jsp").forward(request, response);
    return;
} catch (SQLException ex) { application.log("Transaction history failed", ex); error = "Chưa thể tải lịch sử giao dịch. Vui lòng thử lại sau."; }
counterInvoices = new ArrayList<>(counterInvoices);
onlineOrders = new ArrayList<>(onlineOrders);
counterInvoices.sort(Comparator.comparing(CounterInvoice6::getCreationDate).reversed().thenComparing(i -> "HD" + i.getId()));
onlineOrders.sort(Comparator.comparing(OnlineOrder6::getOrderDate).reversed().thenComparing(o -> "DH" + o.getId()));
int totalTransactions = counterInvoices.size() + onlineOrders.size();
BigDecimal totalRevenue = BigDecimal.ZERO;
for (CounterInvoice6 invoice : counterInvoices) totalRevenue = totalRevenue.add(invoice.getTotalAmount());
for (OnlineOrder6 order : onlineOrders) totalRevenue = totalRevenue.add(order.getTotalAmount());
String range = rangeQuery(fromDate, toDate);
%>
<%@ include file="/WEB-INF/views/header.jspf" %>
<div class="page-heading"><span class="eyebrow">CHI TIẾT KHÁCH HÀNG</span><h1>Thống kê các lần giao dịch</h1><p>Lịch sử mua hàng tại quầy và trực tuyến đã hoàn thành.</p></div>
<% if (!error.isEmpty()) { %><div class="alert error" role="alert"><%= h(error) %></div><% } else { %>
<section class="card customer-summary">
    <div><span>Mã khách hàng</span><strong><%= h(customer.getCustomerCode()) %></strong></div>
    <div><span>Họ tên</span><strong><%= h(customer.getFullName()) %></strong></div>
    <div><span>Khoảng thời gian</span><strong><%= date(fromDate) %> – <%= date(toDate) %></strong></div>
</section>
<section class="card table-card">
    <div class="section-heading"><h2>Danh sách giao dịch</h2><span>Mới nhất trước</span></div>
    <div class="table-scroll"><table>
        <thead><tr><th scope="col">STT</th><th scope="col">Mã GD</th><th scope="col">Ngày GD</th><th scope="col">Loại GD</th><th scope="col" class="number">Thành tiền (VND)</th></tr></thead>
        <tbody>
        <% if (totalTransactions == 0) { %><tr><td colspan="5" class="empty">Không có dữ liệu giao dịch trong khoảng thời gian đã chọn.</td></tr><% } %>
        <% int row = 0, invoiceIndex = 0, orderIndex = 0;
        while (invoiceIndex < counterInvoices.size() || orderIndex < onlineOrders.size()) {
            CounterInvoice6 invoice = invoiceIndex < counterInvoices.size() ? counterInvoices.get(invoiceIndex) : null;
            OnlineOrder6 order = orderIndex < onlineOrders.size() ? onlineOrders.get(orderIndex) : null;
            boolean isOnline = order != null && (invoice == null || !order.getOrderDate().isBefore(invoice.getCreationDate()));
            String code = isOnline ? "DH" + order.getId() : "HD" + invoice.getId();
            LocalDateTime date = isOnline ? order.getOrderDate() : invoice.getCreationDate();
            BigDecimal amount = isOnline ? order.getTotalAmount() : invoice.getTotalAmount();
            String type = isOnline ? "Trực tuyến" : "Tại quầy";
            if (isOnline) orderIndex++; else invoiceIndex++; %>
        <tr><td class="muted"><%= ++row %></td><td><%= h(code) %></td>
            <td><%= date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></td>
            <td><span class="badge <%= "Trực tuyến".equals(type) ? "online" : "" %>"><%= type %></span></td>
            <td class="number amount"><%= money(amount) %></td></tr>
        <% } %>
        </tbody>
    </table></div>
    <div class="transaction-totals"><div>Tổng số GD <strong><%= totalTransactions %></strong></div><div>Tổng doanh thu <strong><%= money(totalRevenue) %> VND</strong></div></div>
</section>
<% } %>
<div class="actions"><a class="button secondary" href="CustomerRevenueReportGUI6.jsp?<%= h(range) %>">← Quay lại</a></div>
<%@ include file="/WEB-INF/views/footer.jspf" %>
