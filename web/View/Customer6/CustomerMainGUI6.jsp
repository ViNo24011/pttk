<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% request.setAttribute("pageTitle", "Trang chủ khách hàng"); %>
<%@ include file="/WEB-INF/views/header.jspf" %>
<section class="hero card">
    <span class="eyebrow">KHÁCH HÀNG</span>
    <h1>Trang chủ khách hàng</h1>
    <% if (navigationUser == null) { %>
    <p>Đăng ký thành viên để tạo tài khoản tại Siêu thị Điện máy.</p>
    <div class="actions"><a class="button primary" href="MembershipRegistrationGUI6.jsp">Đăng ký thành viên <span aria-hidden="true">→</span></a>
        <a class="button secondary" href="<%= request.getContextPath() %>/View/SystemUser6/LoginGUI6.jsp">Đăng nhập</a></div>
    <% } else { %>
    <p>Xin chào <strong><%= h(navigationUser.getFullName()) %></strong>. Bạn đã đăng nhập thành công.</p>
    <% } %>
</section>
<%@ include file="/WEB-INF/views/footer.jspf" %>
