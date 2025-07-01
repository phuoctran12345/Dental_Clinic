package dao;

import java.sql.*;
import utils.DBContext;
import model.Manager;

public class ManagerDAO {
    public static Connection getConnect() {
        return DBContext.getConnection();
    }

    public static Manager getManagerInfo(int userId) {
        String sql = "SELECT * FROM users WHERE id = ? AND role = 'MANAGER'";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Manager(
                    rs.getInt("id"),
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    "", // address
                    null, // date_of_birth
                    "", // gender
                    "", // position
                    rs.getDate("created_at")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getting manager info: " + e);
        }
        return null;
    }

    public static int getUserId(int managerId) {
        String sql = "SELECT user_id FROM Managers WHERE manager_id = ?";
        try (Connection conn = getConnect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            System.out.println("Error getting user id: " + e);
        }
        return -1;
    }

    public static void main(String[] args) {
        Connection conn = getConnect();
        if (conn != null) {
            System.out.println("✅ Kết nối database thành công!");

            // Test lấy thông tin manager có userId = 1
            Manager manager = getManagerInfo(1);
            if (manager != null) {
                System.out.println("Thông tin manager:");
                System.out.println("Họ tên: " + manager.getFullName());
                System.out.println("Chức vụ: " + manager.getPosition());
            } else {
                System.out.println("❌ Không tìm thấy manager với userId = 1");
            }
        } else {
            System.out.println("❌ Kết nối database thất bại!");
        }
    }
} 