<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="DAO.CustomerDAO,Model.Customer6,java.sql.SQLException" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page %>
<%
request.setAttribute("pageTitle", "Đăng ký thành viên");
String fullName = param(request, "fullName").trim();
String phone = param(request, "phone").trim();
String email = param(request, "email").trim();
String address = param(request, "address").trim();
String registrationError = "";
boolean success = Boolean.TRUE.equals(session.getAttribute("registrationSuccess"));
session.removeAttribute("registrationSuccess");
if ("POST".equals(request.getMethod())) {
    success = false;
    String password = param(request, "password"), confirm = param(request, "confirmPassword");
    if (!validCsrf(request)) registrationError = "Phiên làm việc đã hết hạn. Vui lòng thử lại.";
    else {
            try (CustomerDAO dao = new CustomerDAO()) {
                if (!dao.validateRegistrationInfo(fullName, phone, email, address, password, confirm)) registrationError = "Thông tin đăng ký không hợp lệ.";
                else if (dao.emailExists(email)) registrationError = "Email đã được đăng ký. Vui lòng sử dụng email khác hoặc đăng nhập.";
                else {
                    Customer6 customer = new Customer6();
                    customer.setFullName(fullName); customer.setPhone(phone); customer.setEmail(email);
                    customer.setAddress(address); customer.setPassword(password);
                    if (dao.registerMembership(customer)) {
                        session.setAttribute("registrationSuccess", true);
                        response.sendRedirect("MembershipRegistrationGUI6.jsp"); return;
                    } else registrationError = "Email đã được đăng ký. Vui lòng sử dụng email khác hoặc đăng nhập.";
                }
            } catch (SQLException ex) {
                application.log("Membership registration failed", ex);
                registrationError = "Chưa thể lưu thông tin thành viên. Vui lòng thử lại sau.";
            }
    }
}
%>
<%@ include file="/WEB-INF/views/header.jspf" %>
<% if (success) { %>
<section class="card narrow success-card" role="status">
    <div class="success-icon" aria-hidden="true">✓</div><h1>Đăng ký thành viên thành công</h1>
    <p>Tài khoản của bạn đã được tạo. Bạn có thể đăng nhập ngay.</p>
    <a class="button primary" href="<%= request.getContextPath() %>/View/SystemUser6/LoginGUI6.jsp">Đăng nhập ngay</a>
</section>
<% } else { %>
<div class="page-heading narrow"><a class="back-link" href="CustomerMainGUI6.jsp">← Trang chủ khách hàng</a>
    <h1>Đăng ký thành viên</h1><p>Nhập đầy đủ thông tin bên dưới để tạo tài khoản.</p></div>
<section class="card narrow">
    <% if (!registrationError.isEmpty()) { %><div class="alert error" role="alert"><%= h(registrationError) %></div><% } %>
    <form method="post" action="MembershipRegistrationGUI6.jsp">
        <input type="hidden" name="csrf" value="<%= csrf(session) %>">
        <div class="field"><label for="fullName">Họ tên <span>*</span></label>
            <input id="fullName" name="fullName" value="<%= h(fullName) %>" maxlength="150" autocomplete="name" required>
            </div>
        <div class="field"><label for="phone">Số điện thoại <span>*</span></label>
            <input id="phone" name="phone" type="tel" value="<%= h(phone) %>" maxlength="10" pattern="0[0-9]{9}" title="10 chữ số, bắt đầu bằng 0" autocomplete="tel" required>
            </div>
        <div class="field"><label for="email">Email <span>*</span></label>
            <input id="email" name="email" type="email" value="<%= h(email) %>" maxlength="255" autocomplete="email" required>
            </div>
        <div class="field"><label for="address">Địa chỉ <span>*</span></label>
            <textarea id="address" name="address" rows="2" maxlength="255" autocomplete="street-address" required><%= h(address) %></textarea>
            </div>
        <div class="form-grid">
            <div class="field"><label for="password">Mật khẩu <span>*</span></label>
                <input id="password" name="password" type="password" minlength="8" maxlength="128" autocomplete="new-password" required>
                <small id="password-help">Tối thiểu 8 ký tự.</small></div>
            <div class="field"><label for="confirmPassword">Mật khẩu xác nhận <span>*</span></label>
                <input id="confirmPassword" name="confirmPassword" type="password" minlength="8" maxlength="128" autocomplete="new-password" required>
                </div>
        </div>
        <div class="actions"><button class="button primary" type="submit">Đăng ký</button><a class="button secondary" href="CustomerMainGUI6.jsp">Hủy</a></div>
    </form>
</section>
<% } %>
<%@ include file="/WEB-INF/views/footer.jspf" %>
