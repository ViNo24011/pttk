package Model;


/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class TechnicalSpecification6 {
    private int id;
    private int manufactureYear;
    private String manufacturer;
    private String power;
    private String dimensions;
    private double weight;
    private int warrantyPeriod;
    private String image;

    public TechnicalSpecification6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getManufactureYear() { return manufactureYear; }
    public void setManufactureYear(int manufactureYear) { this.manufactureYear = manufactureYear; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public String getPower() { return power; }
    public void setPower(String power) { this.power = power; }

    public String getDimensions() { return dimensions; }
    public void setDimensions(String dimensions) { this.dimensions = dimensions; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public int getWarrantyPeriod() { return warrantyPeriod; }
    public void setWarrantyPeriod(int warrantyPeriod) { this.warrantyPeriod = warrantyPeriod; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

}
