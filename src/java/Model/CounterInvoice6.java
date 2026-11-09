package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class CounterInvoice6 {
    private int id;
    private LocalDateTime creationDate;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private String paymentMethod;
    private SalesStaff6 salesStaff;
    private List<CounterInvoiceDetail6> details = new java.util.ArrayList<>();
    private Customer6 customer;

    public CounterInvoice6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDateTime getCreationDate() { return creationDate; }
    public void setCreationDate(LocalDateTime creationDate) { this.creationDate = creationDate; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public SalesStaff6 getSalesStaff() { return salesStaff; }
    public void setSalesStaff(SalesStaff6 salesStaff) { this.salesStaff = salesStaff; }

    public List<CounterInvoiceDetail6> getDetails() { return details; }
    public void setDetails(List<CounterInvoiceDetail6> details) { this.details = details; }

    public Customer6 getCustomer() { return customer; }
    public void setCustomer(Customer6 customer) { this.customer = customer; }

}
