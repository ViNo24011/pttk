package Model;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class CustomerRevenueStat6 extends Customer6 {
    private LocalDate fromDate;
    private LocalDate toDate;
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private int totalTransactions;

    public CustomerRevenueStat6() {}

    public LocalDate getFromDate() { return fromDate; }
    public void setFromDate(LocalDate fromDate) { this.fromDate = fromDate; }

    public LocalDate getToDate() { return toDate; }
    public void setToDate(LocalDate toDate) { this.toDate = toDate; }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

    public int getTotalTransactions() { return totalTransactions; }
    public void setTotalTransactions(int totalTransactions) { this.totalTransactions = totalTransactions; }

}
