package Model;

import static Model.DatabaseInfo.DBURL;
import static Model.DatabaseInfo.DRIVERNAME;
import static Model.DatabaseInfo.PASSDB;
import static Model.DatabaseInfo.USERDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO implements DatabaseInfo {

    public static Connection getConnect() {
        try {
            Class.forName(DRIVERNAME);
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading driver: " + e);
        }
        try {
            Connection con = DriverManager.getConnection(DBURL, USERDB, PASSDB);
            return con;
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }
        return null;
    }

    // Lấy tất cả khách hàng
    public static List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        try (Connection conn = getConnect();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer(
                        rs.getInt("Customer_ID"),
                        rs.getString("Name"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Password"),
                        rs.getInt("Role_ID"),
                        rs.getTimestamp("Created_At"),
                        rs.getBoolean("Status")
                );
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // Lấy Customer bằng Email (dùng khi đăng nhập)
    public static Customer getCustomerByEmail(Connection conn, String email) throws SQLException {
        String sql = "SELECT * FROM Customer WHERE Email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Customer(
                            rs.getInt("Customer_ID"),
                            rs.getString("Name"),
                            rs.getString("Email"),
                            rs.getString("PhoneNumber"),
                            rs.getString("Password"),
                            rs.getInt("Role_ID"),
                            rs.getTimestamp("Created_At"),
                            rs.getBoolean("Status")
                    );
                }
            }
        }
        return null;
    }

    // Cập nhật thông tin Customer
    public static void updateCustomer(Connection conn, Customer customer) throws SQLException {
        String sql = "UPDATE Customer SET Name = ?, Email = ?, PhoneNumber = ? WHERE Customer_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getEmail());
            stmt.setString(3, customer.getPhoneNumber());
            stmt.setInt(4, customer.getCustomer_ID());

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("✅ Thông tin khách hàng đã được cập nhật.");
            } else {
                System.out.println("⚠️ Không có thông tin nào được cập nhật!");
            }
        }
    }

    // Đổi mật khẩu Customer
    public static void changePassword(Connection conn, int customerId, String newPassword) throws SQLException {
        String sql = "UPDATE Customer SET Password = ? WHERE Customer_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, customerId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("✅ Đổi mật khẩu thành công.");
            } else {
                System.out.println("⚠️ Không thể đổi mật khẩu!");
            }
        }
    }
    // Giả sử bạn đã có phương thức getConnection() để kết nối DB
    private Connection getConnection() throws SQLException {
        // Triển khai kết nối DB của bạn
        return null; // Thay bằng code thực tế
    }


    // Phương thức mới để cấp quyền Admin
    public static void promoteToAdmin(int customerId) {
        String sql = "UPDATE Customers SET Role_ID = 1 WHERE Customer_ID = ?";
        try (Connection conn = new CustomerDAO().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    

    public static void updateRole(int customerId, int roleId) {
        String sql = "UPDATE Customer SET Role_ID = ? WHERE Customer_ID = ?";
        try (Connection conn = getConnect();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roleId);
            stmt.setInt(2, customerId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Đã cập nhật Role_ID = " + roleId + " cho Customer_ID = " + customerId);
            } else {
                System.out.println("Không tìm thấy Customer_ID = " + customerId + " trong database");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL trong updateRole: " + e.getMessage());
            throw new RuntimeException("Lỗi cập nhật Role_ID: " + e.getMessage());
        }
    }

    // Phương thức để xóa khách hàng
    public static void deleteCustomer(int customerId) {
        String sql = "DELETE FROM Customer WHERE Customer_ID = ?";
        try (Connection conn = getConnect();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                System.out.println("Tài khoản với Customer_ID = " + customerId + " đã bị xóa.");
            } else {
                System.out.println("Không tìm thấy Customer_ID = " + customerId + " trong database.");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL trong deleteCustomer: " + e.getMessage());
            throw new RuntimeException("Lỗi xóa tài khoản: " + e.getMessage());
        }
    }
}
