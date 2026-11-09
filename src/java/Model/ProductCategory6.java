package Model;


/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class ProductCategory6 {
    private int id;
    private String categoryName;
    private String description;

    public ProductCategory6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

}
