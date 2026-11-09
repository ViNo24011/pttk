package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class OnlineOrder6 {
    private int id;
    private LocalDateTime orderDate;
    private String deliveryAddress;
    private BigDecimal totalAmount = BigDecimal.ZERO;
    private String status;
    private WarehouseStaff6 approvedBy;
    private List<OnlineOrderDetail6> details = new java.util.ArrayList<>();
    private Customer6 customer;

    public OnlineOrder6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public WarehouseStaff6 getApprovedBy() { return approvedBy; }
    public void setApprovedBy(WarehouseStaff6 approvedBy) { this.approvedBy = approvedBy; }

    public List<OnlineOrderDetail6> getDetails() { return details; }
    public void setDetails(List<OnlineOrderDetail6> details) { this.details = details; }

    public Customer6 getCustomer() { return customer; }
    public void setCustomer(Customer6 customer) { this.customer = customer; }

}
