package dao;

import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class FaceImageDAO {
    private static final Logger logger = Logger.getLogger(FaceImageDAO.class.getName());
    
    /**
     * Lưu ảnh khuôn mặt và face encoding của user
     */
    public boolean saveFaceImage(int userId, String faceImageBase64, String faceEncoding, double confidenceScore) {
        String sql = "INSERT INTO UserFaceImages (user_id, face_image, face_encoding, confidence_score) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, faceImageBase64);
            ps.setString(3, faceEncoding);
            ps.setDouble(4, confidenceScore);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            logger.severe("Error saving face image: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Lấy tất cả ảnh khuôn mặt active của user
     */
    public List<FaceImageInfo> getFaceImagesByUserId(int userId) {
        List<FaceImageInfo> faces = new ArrayList<>();
        String sql = "SELECT id, face_image, face_encoding, confidence_score FROM UserFaceImages WHERE user_id = ? AND is_active = 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                FaceImageInfo face = new FaceImageInfo();
                face.id = rs.getInt("id");
                face.faceImage = rs.getString("face_image");
                face.faceEncoding = rs.getString("face_encoding");
                face.confidenceScore = rs.getDouble("confidence_score");
                faces.add(face);
            }
            
        } catch (SQLException e) {
            logger.severe("Error getting face images: " + e.getMessage());
        }
        
        return faces;
    }
    
    /**
     * Tìm user bằng cách so sánh khuôn mặt
     */
    public Integer findUserByFace(String faceEncoding) {
        String sql = "SELECT user_id, face_encoding FROM UserFaceImages WHERE is_active = 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            double bestSimilarity = 0;
            Integer bestUserId = null;
            
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                String storedEncoding = rs.getString("face_encoding");
                
                // So sánh khuôn mặt sử dụng Google Vision
                double similarity = utils.GoogleVisionFaceService.compareFaces(faceEncoding, storedEncoding);
                
                logger.info(String.format("Comparing with user %d: similarity=%.3f", 
                        userId, similarity));
                
                // Tìm user có điểm tương đồng cao nhất và >= 0.85
                if (similarity >= 0.85 && similarity > bestSimilarity) {
                    bestSimilarity = similarity;
                    bestUserId = userId;
                }
            }
            
            if (bestUserId != null) {
                logger.info(String.format("Found matching user %d with similarity %.3f", bestUserId, bestSimilarity));
                return bestUserId;
            }
            
        } catch (SQLException e) {
            logger.severe("Error finding user by face: " + e.getMessage());
        }
        
        return null; // Không tìm thấy
    }
    
    /**
     * Vô hiệu hóa tất cả ảnh cũ của user (khi đăng ký ảnh mới)
     */
    public boolean deactivateOldFaceImages(int userId) {
        String sql = "UPDATE UserFaceImages SET is_active = 0 WHERE user_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.executeUpdate();
            return true;
            
        } catch (SQLException e) {
            logger.severe("Error deactivating old face images: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Kiểm tra user đã đăng ký khuôn mặt chưa
     */
    public boolean hasFaceRegistered(int userId) {
        String sql = "SELECT COUNT(*) FROM UserFaceImages WHERE user_id = ? AND is_active = 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            return rs.next() && rs.getInt(1) > 0;
            
        } catch (SQLException e) {
            logger.severe("Error checking face registration: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Inner class để lưu thông tin ảnh khuôn mặt
     */
    public static class FaceImageInfo {
        public int id;
        public String faceImage;
        public String faceEncoding;
        public double confidenceScore;
    }
} 