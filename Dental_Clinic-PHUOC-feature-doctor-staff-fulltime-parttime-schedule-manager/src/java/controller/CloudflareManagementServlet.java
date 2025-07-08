package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.CloudflareService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * CloudflareManagementServlet - Quản lý Cloudflare từ admin dashboard
 * 
 * Features:
 * - Xem analytics và thống kê
 * - Purge cache
 * - Kiểm tra security events
 * - Quản lý DNS records
 * - Monitor zone status
 * 
 * @author AI Assistant
 * @version 1.0
 */
@WebServlet("/admin/cloudflare")
public class CloudflareManagementServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CloudflareManagementServlet.class.getName());
    private CloudflareService cloudflareService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        cloudflareService = CloudflareService.getInstance();
        gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "dashboard") {
                case "dashboard":
                    showDashboard(request, response);
                    break;
                case "analytics":
                    getAnalytics(request, response);
                    break;
                case "security-events":
                    getSecurityEvents(request, response);
                    break;
                case "zone-status":
                    getZoneStatus(request, response);
                    break;
                case "cache-status":
                    getCacheStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CloudflareManagementServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "purge-cache":
                    purgeCache(request, response);
                    break;
                case "purge-all-cache":
                    purgeAllCache(request, response);
                    break;
                case "update-dns":
                    updateDnsRecord(request, response);
                    break;
                case "test-connection":
                    testConnection(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CloudflareManagementServlet POST", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    /**
     * Hiển thị dashboard chính
     */
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Map<String, Object> dashboardData = new HashMap<>();
        
        // Kiểm tra cấu hình Cloudflare
        boolean isConfigured = cloudflareService.isConfigured();
        dashboardData.put("configured", isConfigured);
        
        if (isConfigured) {
            // Lấy thông tin zone
            Map<String, Object> zoneStatus = cloudflareService.getZoneStatus();
            dashboardData.put("zoneStatus", zoneStatus);
            
            // Lấy analytics 7 ngày qua
            Map<String, Object> analytics = cloudflareService.getAnalytics(7);
            dashboardData.put("analytics", analytics);
            
            // Lấy security events 24h qua
            List<Map<String, Object>> securityEvents = cloudflareService.getSecurityEvents(24);
            dashboardData.put("securityEvents", securityEvents);
            
            // Thống kê tổng quan
            Map<String, Object> summary = createSummary(analytics, securityEvents);
            dashboardData.put("summary", summary);
        }
        
        request.setAttribute("dashboardData", dashboardData);
        request.getRequestDispatcher("/jsp/manager/cloudflare_dashboard.jsp").forward(request, response);
    }
    
    /**
     * Lấy analytics data
     */
    private void getAnalytics(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int days = 7; // Default 7 days
        try {
            String daysParam = request.getParameter("days");
            if (daysParam != null) {
                days = Integer.parseInt(daysParam);
                if (days < 1 || days > 30) {
                    days = 7; // Reset to default if invalid
                }
            }
        } catch (NumberFormatException e) {
            days = 7;
        }
        
        Map<String, Object> analytics = cloudflareService.getAnalytics(days);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(analytics));
        out.flush();
    }
    
    /**
     * Lấy security events
     */
    private void getSecurityEvents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int hours = 24; // Default 24 hours
        try {
            String hoursParam = request.getParameter("hours");
            if (hoursParam != null) {
                hours = Integer.parseInt(hoursParam);
                if (hours < 1 || hours > 168) { // Max 1 week
                    hours = 24;
                }
            }
        } catch (NumberFormatException e) {
            hours = 24;
        }
        
        List<Map<String, Object>> events = cloudflareService.getSecurityEvents(hours);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(events));
        out.flush();
    }
    
    /**
     * Lấy zone status
     */
    private void getZoneStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Map<String, Object> status = cloudflareService.getZoneStatus();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(status));
        out.flush();
    }
    
    /**
     * Lấy cache status (mock data)
     */
    private void getCacheStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Map<String, Object> cacheStatus = new HashMap<>();
        cacheStatus.put("hit_ratio", 85.5);
        cacheStatus.put("requests_cached", 1234567);
        cacheStatus.put("requests_uncached", 123456);
        cacheStatus.put("bandwidth_saved", "2.5 GB");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(cacheStatus));
        out.flush();
    }
    
    /**
     * Purge cache cho URLs cụ thể
     */
    private void purgeCache(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String[] urls = request.getParameterValues("urls");
        if (urls == null || urls.length == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No URLs provided");
            return;
        }
        
        boolean success = cloudflareService.purgeCache(urls);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "Cache purged successfully" : "Failed to purge cache");
        result.put("urls", Arrays.asList(urls));
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Purge toàn bộ cache
     */
    private void purgeAllCache(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        boolean success = cloudflareService.purgeAllCache();
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "All cache purged successfully" : "Failed to purge all cache");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Cập nhật DNS record
     */
    private void updateDnsRecord(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String content = request.getParameter("content");
        
        if (name == null || type == null || content == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }
        
        boolean success = cloudflareService.updateDnsRecord(name, type, content);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", success ? "DNS record updated successfully" : "Failed to update DNS record");
        result.put("record", Map.of("name", name, "type", type, "content", content));
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Test kết nối Cloudflare
     */
    private void testConnection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            Map<String, Object> zoneStatus = cloudflareService.getZoneStatus();
            boolean configured = (Boolean) zoneStatus.getOrDefault("configured", false);
            
            result.put("success", configured);
            result.put("message", configured ? "Cloudflare connection successful" : "Cloudflare not configured");
            result.put("details", zoneStatus);
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Connection test failed: " + e.getMessage());
            LOGGER.log(Level.WARNING, "Cloudflare connection test failed", e);
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }
    
    /**
     * Tạo summary data cho dashboard
     */
    private Map<String, Object> createSummary(Map<String, Object> analytics, 
                                             List<Map<String, Object>> securityEvents) {
        Map<String, Object> summary = new HashMap<>();
        
        // Analytics summary
        long requests = (Long) analytics.getOrDefault("requests", 0L);
        long pageviews = (Long) analytics.getOrDefault("pageviews", 0L);
        long uniqueVisitors = (Long) analytics.getOrDefault("unique_visitors", 0L);
        long threats = (Long) analytics.getOrDefault("threats", 0L);
        
        summary.put("total_requests", requests);
        summary.put("total_pageviews", pageviews);
        summary.put("unique_visitors", uniqueVisitors);
        summary.put("threats_blocked", threats);
        
        // Security events summary
        Map<String, Integer> actionCounts = new HashMap<>();
        for (Map<String, Object> event : securityEvents) {
            String action = (String) event.getOrDefault("action", "unknown");
            actionCounts.put(action, actionCounts.getOrDefault(action, 0) + 1);
        }
        summary.put("security_actions", actionCounts);
        
        // Calculate rates
        if (requests > 0) {
            double threatRate = (double) threats / requests * 100;
            summary.put("threat_rate", Math.round(threatRate * 100.0) / 100.0);
            
            double cacheHitRate = 85.5; // Mock data - would come from cache analytics
            summary.put("cache_hit_rate", cacheHitRate);
        } else {
            summary.put("threat_rate", 0.0);
            summary.put("cache_hit_rate", 0.0);
        }
        
        return summary;
    }
    
    /**
     * Kiểm tra quyền admin
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        String role = (String) session.getAttribute("role");
        return "manager".equals(role) || "admin".equals(role);
    }
} 