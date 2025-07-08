package model;

/**
 * Model Service cho bảng Services
 * Quản lý các dịch vụ y tế trong phòng khám
 */
public class Service {
    private int serviceId;
    private String serviceName;
    private String description; 
    private double price;
    private String status;
    private String category;
    private String image;

    // Constructor mặc định
    public Service() {
    }

    // Constructor đầy đủ
    public Service(int serviceId, String serviceName, String description, 
                   double price, String status, String category, String image) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.status = status;
        this.category = category;
        this.image = image;
    }

    // Constructor không có serviceId (cho insert)
    public Service(String serviceName, String description, double price, 
                   String status, String category, String image) {
        this.serviceName = serviceName;
        this.description = description;
        this.price = price;
        this.status = status;
        this.category = category;
        this.image = image;
    }

    // Getters và Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    // Phương thức hỗ trợ
    public String getFormattedPrice() {
        return String.format("%,.0f", price) + " VNĐ";
    }

    public boolean isActive() {
        return "active".equals(status);
    }

    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", status='" + status + '\'' +
                ", category='" + category + '\'' +
                ", image='" + image + '\'' +
                '}';
    }
} 