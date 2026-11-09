package Model;

import java.math.BigDecimal;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class CounterInvoiceDetail6 {
    private int id;
    private int quantity;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private Product6 product;

    public CounterInvoiceDetail6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public Product6 getProduct() { return product; }
    public void setProduct(Product6 product) { this.product = product; }

    /** Thành tiền là dữ liệu dẫn xuất, không lưu riêng trong CSDL. */
    public BigDecimal getSubTotal() { return unitPrice.multiply(BigDecimal.valueOf(quantity)); }

}
