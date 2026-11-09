package Model;

import java.math.BigDecimal;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class Product6 {
    private int id;
    private String productName;
    private String manufacturer;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private int stockQuantity;
    private String description;
    private String status;
    private ProductCategory6 category;
    private TechnicalSpecification6 technicalSpecification;

    public Product6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public ProductCategory6 getCategory() { return category; }
    public void setCategory(ProductCategory6 category) { this.category = category; }

    public TechnicalSpecification6 getTechnicalSpecification() { return technicalSpecification; }
    public void setTechnicalSpecification(TechnicalSpecification6 technicalSpecification) { this.technicalSpecification = technicalSpecification; }

}
