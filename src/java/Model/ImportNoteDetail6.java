package Model;

import java.math.BigDecimal;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class ImportNoteDetail6 {
    private int id;
    private int importQuantity;
    private BigDecimal importUnitPrice = BigDecimal.ZERO;
    private Product6 product;

    public ImportNoteDetail6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getImportQuantity() { return importQuantity; }
    public void setImportQuantity(int importQuantity) { this.importQuantity = importQuantity; }

    public BigDecimal getImportUnitPrice() { return importUnitPrice; }
    public void setImportUnitPrice(BigDecimal importUnitPrice) { this.importUnitPrice = importUnitPrice; }

    public Product6 getProduct() { return product; }
    public void setProduct(Product6 product) { this.product = product; }

    /** Thành tiền là dữ liệu dẫn xuất, không lưu riêng trong CSDL. */
    public BigDecimal getSubTotal() { return importUnitPrice.multiply(BigDecimal.valueOf(importQuantity)); }

}
