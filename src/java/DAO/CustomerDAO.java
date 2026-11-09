package DAO;

import Model.Customer6;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;

public class CustomerDAO extends DAO {
    public CustomerDAO() throws SQLException { super(); }

    public boolean validateRegistrationInfo(String fullName, String phone, String email,
            String address, String password, String confirmPassword) {
        String[] values = {fullName, phone, email, address, password, confirmPassword};
        int[] limits = {150, 20, 255, 255, 128, 128};
        for (int i = 0; i < values.length; i++) {
            if (values[i] == null || values[i].isBlank() || values[i].length() > limits[i]) return false;
        }
        return phone.trim().matches("0[0-9]{9}")
                && email.trim().matches("^[^\\s@]+@[^\\s@.]+(?:\\.[^\\s@.]+)+$")
                && password.length() >= 8 && password.equals(confirmPassword);
    }

    public boolean emailExists(String email) throws SQLException {
        try (PreparedStatement ps = connection().prepareStatement("SELECT 1 FROM tblSystemUser WHERE email = ?")) {
            ps.setString(1, email.trim().toLowerCase(Locale.ROOT));
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    /** Ghi SystemUser và Customer trong cùng transaction; UNIQUE email chặn đăng ký trùng đồng thời. */
    public boolean registerMembership(Customer6 customer) throws SQLException {
        boolean originalAutoCommit = connection().getAutoCommit();
        connection().setAutoCommit(false);
        int id;
        String code;
        try {
            try (PreparedStatement ps = connection().prepareStatement(
                    "INSERT INTO tblSystemUser(email,password,fullName,phone,address,role) VALUES(?,?,?,?,?,'CUSTOMER')",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, customer.getEmail().trim().toLowerCase(Locale.ROOT));
                ps.setString(2, customer.getPassword());
                ps.setString(3, customer.getFullName().trim());
                ps.setString(4, customer.getPhone().trim());
                ps.setString(5, customer.getAddress().trim());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Không tạo được mã khách hàng.");
                    id = keys.getInt(1);
                }
            }
            code = String.format(Locale.ROOT, "KH%06d", id);
            try (PreparedStatement ps = connection().prepareStatement("INSERT INTO tblCustomer(userId,customerCode) VALUES(?,?)")) {
                ps.setInt(1, id); ps.setString(2, code); ps.executeUpdate();
            }
            connection().commit();
        } catch (SQLException ex) {
            connection().rollback();
            if (ex.getErrorCode() == 1062) return false;
            throw ex;
        } finally { connection().setAutoCommit(originalAutoCommit); }
        customer.setId(id); customer.setCustomerCode(code); customer.setRole("CUSTOMER");
        customer.setPassword(null);
        return true;
    }

}
