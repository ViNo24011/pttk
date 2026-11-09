package DAO;

import Model.CustomerRevenueStat6;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CustomerRevenueStatDAO extends DAO {
    public CustomerRevenueStatDAO() throws SQLException { super(); }

    /** UNION ALL hai nguồn trước khi GROUP BY để không nhân chéo hóa đơn và đơn hàng. */
    public List<CustomerRevenueStat6> getCustomerRevenueStat(LocalDate fromDate, LocalDate toDate) throws SQLException {
        if (fromDate == null || toDate == null) throw new IllegalArgumentException("Vui lòng chọn đầy đủ Ngày bắt đầu và Ngày kết thúc.");
        if (fromDate.isAfter(toDate)) throw new IllegalArgumentException("Ngày bắt đầu không được lớn hơn Ngày kết thúc.");
        if (fromDate.getYear() < 1000 || toDate.getYear() > 9998) throw new IllegalArgumentException("Vui lòng chọn năm từ 1000 đến 9998.");

        String sql = "SELECT u.id,u.fullName,u.email,u.phone,u.address,u.role,c.customerCode, "
                + "t.totalRevenue,t.totalTransactions FROM tblCustomer c JOIN tblSystemUser u ON u.id=c.userId "
                + "JOIN (SELECT customerId,SUM(totalAmount) totalRevenue,COUNT(*) totalTransactions FROM ("
                + "SELECT customerId,totalAmount FROM tblCounterInvoice WHERE creationDate>=? AND creationDate<? AND customerId IS NOT NULL "
                + "UNION ALL SELECT customerId,totalAmount FROM tblOnlineOrder WHERE orderDate>=? AND orderDate<? AND status=?"
                + ") transactions GROUP BY customerId) t ON t.customerId=c.userId "
                + "ORDER BY t.totalRevenue DESC,c.customerCode ASC";
        List<CustomerRevenueStat6> result = new ArrayList<>();
        try (PreparedStatement ps = connection().prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(fromDate.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(toDate.plusDays(1).atStartOfDay()));
            ps.setTimestamp(3, Timestamp.valueOf(fromDate.atStartOfDay()));
            ps.setTimestamp(4, Timestamp.valueOf(toDate.plusDays(1).atStartOfDay()));
            ps.setString(5, "Đã giao thành công");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomerRevenueStat6 stat = new CustomerRevenueStat6();
                    stat.setId(rs.getInt("id"));
                    stat.setCustomerCode(rs.getString("customerCode"));
                    stat.setFullName(rs.getString("fullName"));
                    stat.setEmail(rs.getString("email"));
                    stat.setPhone(rs.getString("phone"));
                    stat.setAddress(rs.getString("address"));
                    stat.setRole(rs.getString("role"));
                    stat.setFromDate(fromDate); stat.setToDate(toDate);
                    stat.setTotalRevenue(rs.getBigDecimal("totalRevenue"));
                    stat.setTotalTransactions(rs.getInt("totalTransactions"));
                    result.add(stat);
                }
            }
        }
        return result;
    }
}
