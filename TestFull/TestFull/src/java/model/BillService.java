package model;

import java.math.BigDecimal;

/**
 * Model BillService cho chi tiết dịch vụ trong hóa đơn
 * @author TranHongPhuoc
 */
public class BillService {
    private int id;
    private int billId;
    private int serviceId;
    private String serviceName;
    private BigDecimal price;
    private int quantity;
    private BigDecimal total;

    public BillService() {}

    public BillService(int serviceId, String serviceName, BigDecimal price, int quantity) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.price = price;
        this.quantity = quantity;
        this.total = price.multiply(BigDecimal.valueOf(quantity));
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    /**
     * Tính toán tổng tiền của dịch vụ
     */
    public void calculateTotal() {
        this.total = this.price.multiply(BigDecimal.valueOf(this.quantity));
    }

    @Override
    public String toString() {
        return "BillService{" +
                "id=" + id +
                ", serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", total=" + total +
                '}';
    }
} 