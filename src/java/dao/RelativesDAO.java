package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Date;
import utils.DBContext;

public class RelativesDAO {
    // Trả về relative_id nếu đã có, nếu chưa thì insert và trả về id mới
    public static int getOrCreateRelative(int userId, String fullName, String phone, String dob, String gender, String relationship) {
        int relativeId = -1;
        try (Connection conn = DBContext.getConnection()) {
            // 1. Kiểm tra đã tồn tại chưa (theo user_id, tên, sđt, ngày sinh)
            String checkSql = "SELECT relative_id FROM Relatives WHERE user_id = ? AND full_name = ? AND phone = ? AND date_of_birth = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, userId);
                ps.setString(2, fullName);
                ps.setString(3, phone);
                ps.setDate(4, dob != null && !dob.isEmpty() ? Date.valueOf(dob) : null);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("relative_id");
                    }
                }
            }
            // 2. Nếu chưa có, insert mới
            String insertSql = "INSERT INTO Relatives (user_id, full_name, phone, date_of_birth, gender, relationship) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setString(2, fullName);
                ps.setString(3, phone);
                ps.setDate(4, dob != null && !dob.isEmpty() ? Date.valueOf(dob) : null);
                ps.setString(5, gender);
                ps.setString(6, relationship);
                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    return -1;
                }
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        relativeId = rs.getInt(1);
                    } else {
                        return -1;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            relativeId = -1;
        }
        return relativeId;
    }

    // Cập nhật thông tin người thân
    public static boolean updateRelative(int relativeId, String fullName, String phone, String dob, String gender, String relationship) {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "UPDATE Relatives SET full_name = ?, phone = ?, date_of_birth = ?, gender = ?, relationship = ? WHERE relative_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, fullName);
                ps.setString(2, phone);
                ps.setDate(3, dob != null && !dob.isEmpty() ? Date.valueOf(dob) : null);
                ps.setString(4, gender);
                ps.setString(5, relationship);
                ps.setInt(6, relativeId);
                int affectedRows = ps.executeUpdate();
                return affectedRows > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
} 