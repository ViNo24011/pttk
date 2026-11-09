package Model;


/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class DeliveryStaff6 {
    private int id;
    private String staffCode;
    private String fullName;
    private String phone;
    private String deliveryZone;

    public DeliveryStaff6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getDeliveryZone() { return deliveryZone; }
    public void setDeliveryZone(String deliveryZone) { this.deliveryZone = deliveryZone; }

}
