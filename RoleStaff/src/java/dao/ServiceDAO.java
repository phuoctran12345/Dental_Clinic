package dao;

import model.Service;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO cho bảng Services
 * Quản lý CRUD operations cho dịch vụ y tế
 */
public class ServiceDAO {
    
    // Database connection parameters
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=BenhVien;encrypt=false";
    private static final String DB_USERNAME = "sa";
    private static final String DB_PASSWORD = "Phuoc12345@";

    // Lấy kết nối database
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    /**
     * Lấy tất cả dịch vụ
     */
    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, price, status, category, image " +
                    "FROM Services ORDER BY service_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Service service = mapResultSetToService(rs);
                services.add(service);
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách dịch vụ: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }

    /**
     * Lấy dịch vụ theo ID
     */
    public Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, service_name, description, price, status, category, image " +
                    "FROM Services WHERE service_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToService(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Lấy dịch vụ theo trạng thái
     */
    public List<Service> getServicesByStatus(String status) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, price, status, category, image " +
                    "FROM Services WHERE status = ? ORDER BY service_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo trạng thái: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }

    /**
     * Lấy dịch vụ theo danh mục
     */
    public List<Service> getServicesByCategory(String category) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, price, status, category, image " +
                    "FROM Services WHERE category = ? AND status = 'active' ORDER BY service_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy dịch vụ theo danh mục: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }

    /**
     * Lấy dịch vụ đang hoạt động
     */
    public List<Service> getActiveServices() {
        return getServicesByStatus("active");
    }

    /**
     * Tìm kiếm dịch vụ theo tên
     */
    public List<Service> searchServicesByName(String searchTerm) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, price, status, category, image " +
                    "FROM Services WHERE service_name LIKE ? AND status = 'active' ORDER BY service_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = mapResultSetToService(rs);
                    services.add(service);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm kiếm dịch vụ: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }

    /**
     * Thêm dịch vụ mới
     */
    public boolean insertService(Service service) {
        String sql = "INSERT INTO Services (service_name, description, price, status, category, image) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, service.getServiceName());
            stmt.setString(2, service.getDescription());
            stmt.setDouble(3, service.getPrice());
            stmt.setString(4, service.getStatus());
            stmt.setString(5, service.getCategory());
            stmt.setString(6, service.getImage());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi thêm dịch vụ: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật dịch vụ
     */
    public boolean updateService(Service service) {
        String sql = "UPDATE Services SET service_name = ?, description = ?, price = ?, " +
                    "status = ?, category = ?, image = ? WHERE service_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, service.getServiceName());
            stmt.setString(2, service.getDescription());
            stmt.setDouble(3, service.getPrice());
            stmt.setString(4, service.getStatus());
            stmt.setString(5, service.getCategory());
            stmt.setString(6, service.getImage());
            stmt.setInt(7, service.getServiceId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật dịch vụ: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Xóa dịch vụ (thực tế là set status = 'inactive')
     */
    public boolean deleteService(int serviceId) {
        String sql = "UPDATE Services SET status = 'inactive' WHERE service_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, serviceId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa dịch vụ: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy tất cả danh mục dịch vụ
     */
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Services WHERE status = 'active' ORDER BY category";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                String category = rs.getString("category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh mục: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }

    /**
     * Map ResultSet sang Service object
     */
    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));
        service.setServiceName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getDouble("price"));
        service.setStatus(rs.getString("status"));
        service.setCategory(rs.getString("category"));
        service.setImage(rs.getString("image"));
        return service;
    }
} 