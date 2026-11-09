package Model;

import java.time.LocalDateTime;
import java.util.List;

/** Lớp thực thể theo sơ đồ thiết kế HTTT; dữ liệu nghiệp vụ do DAO truy xuất. */
public class ImportNote6 {
    private int id;
    private LocalDateTime importDate;
    private String note;
    private Supplier6 supplier;
    private WarehouseStaff6 warehouseStaff;
    private List<ImportNoteDetail6> details = new java.util.ArrayList<>();

    public ImportNote6() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public LocalDateTime getImportDate() { return importDate; }
    public void setImportDate(LocalDateTime importDate) { this.importDate = importDate; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Supplier6 getSupplier() { return supplier; }
    public void setSupplier(Supplier6 supplier) { this.supplier = supplier; }

    public WarehouseStaff6 getWarehouseStaff() { return warehouseStaff; }
    public void setWarehouseStaff(WarehouseStaff6 warehouseStaff) { this.warehouseStaff = warehouseStaff; }

    public List<ImportNoteDetail6> getDetails() { return details; }
    public void setDetails(List<ImportNoteDetail6> details) { this.details = details; }

}
