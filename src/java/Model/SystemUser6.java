package Model;


/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public abstract class SystemUser6 {
    private int id;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String address;
    private String role;
    private String note;

    public SystemUser6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

}
