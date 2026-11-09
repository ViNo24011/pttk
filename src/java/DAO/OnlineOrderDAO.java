package DAO;

import Model.OnlineOrder6;
import Model.Customer6;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class OnlineOrderDAO extends DAO {
    public OnlineOrderDAO() throws SQLException { super(); }

    public List<OnlineOrder6> getOnlineOrder(String customerCode, LocalDate fromDate, LocalDate toDate) throws SQLException {
        if (fromDate == null || toDate == null) throw new IllegalArgumentException("Vui lòng chọn đầy đủ Ngày bắt đầu và Ngày kết thúc.");
        if (fromDate.isAfter(toDate)) throw new IllegalArgumentException("Ngày bắt đầu không được lớn hơn Ngày kết thúc.");
        if (fromDate.getYear() < 1000 || toDate.getYear() > 9998) throw new IllegalArgumentException("Vui lòng chọn năm từ 1000 đến 9998.");
        List<OnlineOrder6> result = new ArrayList<>();
        try (PreparedStatement ps = connection().prepareStatement(
                "SELECT o.* FROM tblOnlineOrder o JOIN tblCustomer c ON c.userId=o.customerId "
                + "WHERE c.customerCode=? AND o.orderDate>=? AND o.orderDate<? AND o.status=? ORDER BY o.orderDate DESC,o.id DESC")) {
            ps.setString(1, customerCode); ps.setTimestamp(2, Timestamp.valueOf(fromDate.atStartOfDay()));
            ps.setTimestamp(3, Timestamp.valueOf(toDate.plusDays(1).atStartOfDay()));
            ps.setString(4, "Đã giao thành công");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OnlineOrder6 order = new OnlineOrder6();
                    order.setId(rs.getInt("id")); order.setOrderDate(rs.getTimestamp("orderDate").toLocalDateTime());
                    order.setTotalAmount(rs.getBigDecimal("totalAmount")); order.setStatus(rs.getString("status"));
                    order.setDeliveryAddress(rs.getString("deliveryAddress"));
                    Customer6 customer = new Customer6(); customer.setId(rs.getInt("customerId")); customer.setCustomerCode(customerCode);
                    order.setCustomer(customer); result.add(order);
                }
            }
        }
        return result;
    }
}
