package Model;

import java.time.LocalDateTime;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class ExportNote6 {
    private int id;
    private LocalDateTime exportDate;
    private String note;
    private OnlineOrder6 onlineOrder;
    private WarehouseStaff6 warehouseStaff;
    private DeliveryStaff6 deliveryStaff;

    public ExportNote6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDateTime getExportDate() { return exportDate; }
    public void setExportDate(LocalDateTime exportDate) { this.exportDate = exportDate; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public OnlineOrder6 getOnlineOrder() { return onlineOrder; }
    public void setOnlineOrder(OnlineOrder6 onlineOrder) { this.onlineOrder = onlineOrder; }

    public WarehouseStaff6 getWarehouseStaff() { return warehouseStaff; }
    public void setWarehouseStaff(WarehouseStaff6 warehouseStaff) { this.warehouseStaff = warehouseStaff; }

    public DeliveryStaff6 getDeliveryStaff() { return deliveryStaff; }
    public void setDeliveryStaff(DeliveryStaff6 deliveryStaff) { this.deliveryStaff = deliveryStaff; }

}
