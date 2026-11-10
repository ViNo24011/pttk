# Hệ thống quản lý siêu thị điện máy

Dự án Java Web triển khai hai chức năng theo báo cáo **HTTT – Đề số 12**:

- **Đăng ký thành viên:** nhập thông tin cá nhân, kiểm tra hợp lệ và email trùng, lưu tài khoản, thông báo thành công.
- **Thống kê khách hàng theo doanh thu:** quản lý chọn khoảng ngày, xem khách hàng theo doanh thu giảm dần và xem chi tiết giao dịch tại quầy/trực tuyến.

## Công nghệ

Java 21 · JSP/HTML/CSS · JDBC · MySQL 8 · Tomcat 9 · NetBeans/Ant.

## Cấu trúc dự án
- folder SystemUser6 cho quản lý đăng nhập và sử dụng chức năng, khách hàng test đăng nhập sau khi đăng ký tài khoản

```text
pttk/
├── src/java/
│   ├── Model/              # Các lớp thực thể theo thiết kế
│   ├── DAO/                # Kết nối và truy vấn CSDL
│   └── ApplicationSetup.java
├── web/
│   ├── View/
│   │   ├── SystemUser6/    # Đăng nhập, đăng xuất
│   │   ├── Customer6/      # Trang chủ, đăng ký thành viên
│   │   └── Manager6/       # Báo cáo và chi tiết giao dịch
│   ├── assets/             # CSS
│   └── WEB-INF/            # Cấu hình, thư viện, JSP dùng chung
├── config/                 # Cấu hình kết nối MySQL
├── docs/                   # Báo cáo, SQL, hướng dẫn, ảnh giao diện
├── scripts/                # Script tạo CSDL, build và chạy
├── test/                   # Kiểm thử tích hợp
├── nbproject/              # Cấu hình NetBeans
└── build.xml               # Cấu hình Ant
```

Mã nguồn tổ chức theo **View → DAO → Model**, giữ tên JSP, lớp và phương thức chính theo thiết kế cuối và Scenario v3.0 trong báo cáo. CSDL gồm **18 bảng**; dữ liệu thống kê được tổng hợp từ hóa đơn tại quầy và đơn trực tuyến đã giao thành công.

## Tài khoản mẫu

| Vai trò | Email | Mật khẩu |
|---|---|---|
| Quản lý | quanly@dienmay.vn | QuanLy@123 |


Kỳ thống kê mẫu **01/09/2026–20/09/2026**: **3 khách hàng, 7 giao dịch, 68.000.000 VND**.
