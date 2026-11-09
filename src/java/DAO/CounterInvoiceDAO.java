package DAO;

import Model.CounterInvoice6;
import Model.Customer6;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CounterInvoiceDAO extends DAO {
    public CounterInvoiceDAO() throws SQLException { super(); }

    public List<CounterInvoice6> getCounterInvoice(String customerCode, LocalDate fromDate, LocalDate toDate) throws SQLException {
        if (fromDate == null || toDate == null) throw new IllegalArgumentException("Vui lòng chọn đầy đủ Ngày bắt đầu và Ngày kết thúc.");
        if (fromDate.isAfter(toDate)) throw new IllegalArgumentException("Ngày bắt đầu không được lớn hơn Ngày kết thúc.");
        if (fromDate.getYear() < 1000 || toDate.getYear() > 9998) throw new IllegalArgumentException("Vui lòng chọn năm từ 1000 đến 9998.");
        List<CounterInvoice6> result = new ArrayList<>();
        try (PreparedStatement ps = connection().prepareStatement(
                "SELECT i.* FROM tblCounterInvoice i JOIN tblCustomer c ON c.userId=i.customerId "
                + "WHERE c.customerCode=? AND i.creationDate>=? AND i.creationDate<? ORDER BY i.creationDate DESC,i.id DESC")) {
            ps.setString(1, customerCode); ps.setTimestamp(2, Timestamp.valueOf(fromDate.atStartOfDay()));
            ps.setTimestamp(3, Timestamp.valueOf(toDate.plusDays(1).atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CounterInvoice6 invoice = new CounterInvoice6();
                    invoice.setId(rs.getInt("id")); invoice.setCreationDate(rs.getTimestamp("creationDate").toLocalDateTime());
                    invoice.setTotalAmount(rs.getBigDecimal("totalAmount")); invoice.setPaymentMethod(rs.getString("paymentMethod"));
                    Customer6 customer = new Customer6(); customer.setId(rs.getInt("customerId")); customer.setCustomerCode(customerCode);
                    invoice.setCustomer(customer); result.add(invoice);
                }
            }
        }
        return result;
    }
}
