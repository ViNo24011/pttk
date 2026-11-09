<%@ include file="/WEB-INF/views/functions.jspf" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Model.SystemUser6,Model.Manager6,Model.Customer6,java.sql.Connection,java.sql.DriverManager,java.sql.PreparedStatement,java.sql.ResultSet,java.util.Properties,java.util.Locale,java.nio.file.Files,java.nio.file.Path,java.nio.charset.StandardCharsets,java.io.Reader,java.io.IOException,java.sql.SQLException" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
request.setAttribute("pageTitle", "Đăng nhập");
String error = "", email = param(request, "email").trim();
if ("POST".equals(request.getMethod())) {
    String password = param(request, "password");
    if (!validCsrf(request)) error = "Phiên làm việc đã hết hạn. Vui lòng thử lại.";
    else if (email.isEmpty() || email.length() > 255 || password.isEmpty() || password.length() > 128) error = "Vui lòng nhập email và mật khẩu hợp lệ.";
    else {
        try {
            // Đăng nhập bổ trợ cho demo, nằm ngoài hai sequence nghiệp vụ.
            String configPath = System.getProperty("pttk.db.config");
            if (configPath == null || configPath.isBlank()) configPath = System.getenv("PTTK_DB_CONFIG");
            if (configPath == null || configPath.isBlank()) configPath = application.getInitParameter("databaseConfig");
            if (configPath == null || configPath.isBlank()) configPath = "config/database.properties";
            Properties databaseSettings = new Properties();
            try (Reader reader = Files.newBufferedReader(Path.of(configPath), StandardCharsets.UTF_8)) {
                databaseSettings.load(reader);
            }
            Class.forName("com.mysql.cj.jdbc.Driver");
            SystemUser6 user = null;
            try (Connection connection = DriverManager.getConnection(databaseSettings.getProperty("db.url"), databaseSettings.getProperty("db.user"), databaseSettings.getProperty("db.password"))) {
        try (PreparedStatement ps = connection.prepareStatement(
                "SELECT u.*,c.customerCode,s.staffCode,s.position,m.staffId managerId FROM tblSystemUser u "
                + "LEFT JOIN tblCustomer c ON c.userId=u.id LEFT JOIN tblStaff s ON s.userId=u.id "
                + "LEFT JOIN tblManager m ON m.staffId=u.id WHERE u.email=?")) {
            ps.setString(1, email.trim().toLowerCase(Locale.ROOT));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && java.util.Objects.equals(password, rs.getString("password"))) {

                if ("MANAGER".equals(rs.getString("role")) && rs.getObject("managerId") != null) {
                    Manager6 manager = new Manager6();
                    manager.setStaffCode(rs.getString("staffCode")); manager.setPosition(rs.getString("position"));
                    user = manager;
                } else if ("CUSTOMER".equals(rs.getString("role")) && rs.getString("customerCode") != null) {
                    Customer6 customer = new Customer6(); customer.setCustomerCode(rs.getString("customerCode")); user = customer;
                }
                if (user != null) {
                user.setId(rs.getInt("id")); user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email")); user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address")); user.setRole(rs.getString("role"));
                }
                }
            }
        }
            }
            if (user == null) error = "Email hoặc mật khẩu không đúng.";
            else {
                request.changeSessionId(); session.setAttribute("currentUser", user); session.removeAttribute("csrf");
                response.sendRedirect(request.getContextPath() + (user instanceof Manager6 ? "/View/Manager6/ManagerViewGUI6.jsp" : "/View/Customer6/CustomerMainGUI6.jsp")); return;
            }
        } catch (SQLException | IOException | ClassNotFoundException ex) { application.log("Login failed", ex); error = "Chưa thể kết nối hệ thống. Vui lòng thử lại sau."; }
    }
}
%>
<%@ include file="/WEB-INF/views/header.jspf" %>
<div class="page-heading login-width"><span class="eyebrow">TÀI KHOẢN</span><h1>Đăng nhập</h1><p>Chào mừng bạn trở lại Siêu thị Điện máy.</p></div>
<section class="card login-width">
    <% if (request.getParameter("required") != null) { %><div class="alert info">Vui lòng đăng nhập bằng tài khoản quản lý để xem báo cáo.</div><% } %>
    <% if (!error.isEmpty()) { %><div class="alert error" role="alert"><%= h(error) %></div><% } %>
    <form method="post" action="LoginGUI6.jsp">
        <input type="hidden" name="csrf" value="<%= csrf(session) %>">
        <div class="field"><label for="email">Email</label><input id="email" name="email" type="email" maxlength="255" value="<%= h(email) %>" autocomplete="username" required></div>
        <div class="field"><label for="password">Mật khẩu</label><input id="password" name="password" type="password" maxlength="128" autocomplete="current-password" required></div>
        <button class="button primary full-width" type="submit">Đăng nhập</button>
    </form>
    <p class="form-foot">Chưa có tài khoản? <a href="<%= request.getContextPath() %>/View/Customer6/MembershipRegistrationGUI6.jsp">Đăng ký thành viên</a></p>
</section>
<%@ include file="/WEB-INF/views/footer.jspf" %>
