package dao;

import model.NotificationTemplate;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import model.Notification;

public class NotificationTemplateDAO {
    
    public NotificationTemplate createTemplate(NotificationTemplate template) {
        String sql = "INSERT INTO NotificationTemplates (type, title_template, content_template, is_active) " +
                    "VALUES (?, ?, ?, ?) " +
                    "SELECT SCOPE_IDENTITY() as template_id";
                    
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, template.getType());
            ps.setString(2, template.getTitleTemplate());
            ps.setString(3, template.getContentTemplate());
            ps.setBoolean(4, template.isActive());
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                template.setTemplateId(rs.getInt("template_id"));
                return template;
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating template: " + e.getMessage());
        }
        return null;
    }
    
    public NotificationTemplate getTemplateById(int templateId) {
        String sql = "SELECT * FROM NotificationTemplates WHERE template_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, templateId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTemplate(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting template: " + e.getMessage());
        }
        return null;
    }
    
    public List<NotificationTemplate> getAllTemplates() {
        List<NotificationTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM NotificationTemplates WHERE is_active = 1";
        
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                templates.add(mapResultSetToTemplate(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting templates: " + e.getMessage());
        }
        return templates;
    }
    
    public boolean updateTemplate(NotificationTemplate template) {
        String sql = "UPDATE NotificationTemplates SET type = ?, title_template = ?, " +
                    "content_template = ?, is_active = ? WHERE template_id = ?";
                    
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, template.getType());
            ps.setString(2, template.getTitleTemplate());
            ps.setString(3, template.getContentTemplate());
            ps.setBoolean(4, template.isActive());
            ps.setInt(5, template.getTemplateId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating template: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteTemplate(int templateId) {
        String sql = "UPDATE NotificationTemplates SET is_active = 0 WHERE template_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, templateId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting template: " + e.getMessage());
            return false;
        }
    }
    
    public NotificationTemplate getTemplateByType(String type) {
        String sql = "SELECT * FROM NotificationTemplates WHERE type = ? AND is_active = 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTemplate(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting template by type: " + e.getMessage());
        }
        return null;
    }
    
    public String processTemplate(String template, Map<String, String> params) {
        String result = template;
        for (Map.Entry<String, String> entry : params.entrySet()) {
            result = result.replace("{" + entry.getKey() + "}", entry.getValue());
        }
        return result;
    }
    
    public Notification createNotificationFromTemplate(String type, int userId, int referenceId, Map<String, String> params) {
        NotificationTemplate template = getTemplateByType(type);
        if (template == null) {
            return null;
        }
        
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setType(type);
        notification.setReferenceId(referenceId);
        notification.setTitle(processTemplate(template.getTitleTemplate(), params));
        notification.setContent(processTemplate(template.getContentTemplate(), params));
        
        NotificationDAO notificationDAO = new NotificationDAO();
        if (notificationDAO.createNotification(notification)) {
            return notification;
        }
        return null;
    }
    
    private NotificationTemplate mapResultSetToTemplate(ResultSet rs) throws SQLException {
        NotificationTemplate template = new NotificationTemplate();
        template.setTemplateId(rs.getInt("template_id"));
        template.setType(rs.getString("type"));
        template.setTitleTemplate(rs.getString("title_template"));
        template.setContentTemplate(rs.getString("content_template"));
        template.setActive(rs.getBoolean("is_active"));
        return template;
    }
    
    // Phương thức tiện ích để tạo Map params
    public static Map<String, String> createParams() {
        return new HashMap<>();
    }
} 