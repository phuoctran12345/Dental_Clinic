package utils;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;
import java.util.logging.Logger;
import java.util.logging.Level;
import org.json.JSONObject;
import org.json.JSONArray;

/**
 * CloudflareService - Tích hợp Cloudflare API cho phòng khám nha khoa
 * 
 * Features:
 * - Purge cache khi cập nhật thông tin
 * - Quản lý DNS records
 * - Kiểm tra security events
 * - Analytics và monitoring
 * 
 * @author AI Assistant
 * @version 1.0
 */
public class CloudflareService {
    
    private static final Logger LOGGER = Logger.getLogger(CloudflareService.class.getName());
    
    // Cloudflare API Configuration
    private static final String CLOUDFLARE_API_BASE = "https://api.cloudflare.com/client/v4";
    private String apiToken;
    private String zoneId;
    private String domain;
    
    // Static instance for singleton pattern
    private static CloudflareService instance;
    
    /**
     * Private constructor for singleton pattern
     */
    private CloudflareService() {
        loadConfig();
    }
    
    /**
     * Get singleton instance
     */
    public static synchronized CloudflareService getInstance() {
        if (instance == null) {
            instance = new CloudflareService();
        }
        return instance;
    }
    
    /**
     * Load configuration from properties file
     */
    private void loadConfig() {
        try {
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("cloudflare-config.properties");
            
            if (input == null) {
                LOGGER.warning("cloudflare-config.properties not found, using environment variables");
                loadFromEnvironment();
                return;
            }
            
            props.load(input);
            this.apiToken = props.getProperty("cloudflare.api_token");
            this.zoneId = props.getProperty("cloudflare.zone_id");
            this.domain = props.getProperty("cloudflare.domain");
            
            input.close();
            
            LOGGER.info("Cloudflare configuration loaded successfully");
            
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error loading Cloudflare configuration", e);
            loadFromEnvironment();
        }
    }
    
    /**
     * Load config from environment variables as fallback
     */
    private void loadFromEnvironment() {
        this.apiToken = System.getenv("CLOUDFLARE_API_TOKEN");
        this.zoneId = System.getenv("CLOUDFLARE_ZONE_ID");
        this.domain = System.getenv("CLOUDFLARE_DOMAIN");
        
        if (apiToken == null || zoneId == null) {
            LOGGER.warning("Cloudflare configuration not found in environment variables");
        }
    }
    
    /**
     * Purge cache cho trang cụ thể
     * Sử dụng khi cập nhật thông tin bệnh nhân, lịch hẹn, etc.
     */
    public boolean purgeCache(String... urls) {
        if (apiToken == null || zoneId == null) {
            LOGGER.warning("Cloudflare not configured, skipping cache purge");
            return false;
        }
        
        try {
            String endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/purge_cache";
            
            JSONObject payload = new JSONObject();
            JSONArray filesArray = new JSONArray();
            
            for (String url : urls) {
                if (!url.startsWith("http")) {
                    url = "https://" + domain + url;
                }
                filesArray.put(url);
            }
            
            payload.put("files", filesArray);
            
            String response = makeApiRequest("POST", endpoint, payload.toString());
            JSONObject responseJson = new JSONObject(response);
            
            boolean success = responseJson.getBoolean("success");
            if (success) {
                LOGGER.info("Cache purged successfully for URLs: " + Arrays.toString(urls));
            } else {
                LOGGER.warning("Cache purge failed: " + responseJson.toString());
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error purging cache", e);
            return false;
        }
    }
    
    /**
     * Purge toàn bộ cache
     * Sử dụng khi có update lớn của hệ thống
     */
    public boolean purgeAllCache() {
        if (apiToken == null || zoneId == null) {
            LOGGER.warning("Cloudflare not configured, skipping cache purge");
            return false;
        }
        
        try {
            String endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/purge_cache";
            JSONObject payload = new JSONObject();
            payload.put("purge_everything", true);
            
            String response = makeApiRequest("POST", endpoint, payload.toString());
            JSONObject responseJson = new JSONObject(response);
            
            boolean success = responseJson.getBoolean("success");
            if (success) {
                LOGGER.info("All cache purged successfully");
            } else {
                LOGGER.warning("All cache purge failed: " + responseJson.toString());
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error purging all cache", e);
            return false;
        }
    }
    
    /**
     * Lấy analytics data từ Cloudflare
     */
    public Map<String, Object> getAnalytics(int days) {
        Map<String, Object> analytics = new HashMap<>();
        
        if (apiToken == null || zoneId == null) {
            LOGGER.warning("Cloudflare not configured, returning empty analytics");
            return analytics;
        }
        
        try {
            // Calculate date range
            Calendar cal = Calendar.getInstance();
            String endDate = String.format("%04d-%02d-%02dT%02d:%02d:%02dZ", 
                cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH),
                cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND));
            
            cal.add(Calendar.DAY_OF_MONTH, -days);
            String startDate = String.format("%04d-%02d-%02dT%02d:%02d:%02dZ", 
                cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH),
                cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND));
            
            String endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/analytics/dashboard" +
                "?since=" + startDate + "&until=" + endDate;
            
            String response = makeApiRequest("GET", endpoint, null);
            JSONObject responseJson = new JSONObject(response);
            
            if (responseJson.getBoolean("success")) {
                JSONObject result = responseJson.getJSONObject("result");
                JSONObject totals = result.getJSONObject("totals");
                
                analytics.put("requests", totals.getLong("requests"));
                analytics.put("pageviews", totals.getLong("pageviews"));
                analytics.put("unique_visitors", totals.getLong("uniques"));
                analytics.put("bandwidth", totals.getLong("bandwidth"));
                analytics.put("threats", totals.getLong("threats"));
                
                LOGGER.info("Analytics retrieved successfully for " + days + " days");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving analytics", e);
        }
        
        return analytics;
    }
    
    /**
     * Lấy thông tin security events
     */
    public List<Map<String, Object>> getSecurityEvents(int hours) {
        List<Map<String, Object>> events = new ArrayList<>();
        
        if (apiToken == null || zoneId == null) {
            LOGGER.warning("Cloudflare not configured, returning empty security events");
            return events;
        }
        
        try {
            Calendar cal = Calendar.getInstance();
            String endTime = String.format("%04d-%02d-%02dT%02d:%02d:%02dZ", 
                cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH),
                cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND));
            
            cal.add(Calendar.HOUR, -hours);
            String startTime = String.format("%04d-%02d-%02dT%02d:%02d:%02dZ", 
                cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH),
                cal.get(Calendar.HOUR_OF_DAY), cal.get(Calendar.MINUTE), cal.get(Calendar.SECOND));
            
            String endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/security/events" +
                "?since=" + startTime + "&until=" + endTime;
            
            String response = makeApiRequest("GET", endpoint, null);
            JSONObject responseJson = new JSONObject(response);
            
            if (responseJson.getBoolean("success")) {
                JSONArray result = responseJson.getJSONArray("result");
                
                for (int i = 0; i < result.length(); i++) {
                    JSONObject event = result.getJSONObject(i);
                    Map<String, Object> eventMap = new HashMap<>();
                    
                    eventMap.put("ray_id", event.getString("ray_id"));
                    eventMap.put("occurred_at", event.getString("occurred_at"));
                    eventMap.put("action", event.getString("action"));
                    eventMap.put("source", event.getJSONObject("source"));
                    eventMap.put("rule_id", event.optString("rule_id", ""));
                    
                    events.add(eventMap);
                }
                
                LOGGER.info("Retrieved " + events.size() + " security events for " + hours + " hours");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving security events", e);
        }
        
        return events;
    }
    
    /**
     * Tạo hoặc cập nhật DNS record
     */
    public boolean updateDnsRecord(String name, String type, String content) {
        if (apiToken == null || zoneId == null) {
            LOGGER.warning("Cloudflare not configured, skipping DNS update");
            return false;
        }
        
        try {
            // First, get existing DNS records
            String listEndpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/dns_records?name=" + name + "&type=" + type;
            String listResponse = makeApiRequest("GET", listEndpoint, null);
            JSONObject listResponseJson = new JSONObject(listResponse);
            
            String recordId = null;
            if (listResponseJson.getBoolean("success")) {
                JSONArray records = listResponseJson.getJSONArray("result");
                if (records.length() > 0) {
                    recordId = records.getJSONObject(0).getString("id");
                }
            }
            
            JSONObject payload = new JSONObject();
            payload.put("type", type);
            payload.put("name", name);
            payload.put("content", content);
            payload.put("ttl", 1);
            
            String endpoint;
            String method;
            
            if (recordId != null) {
                // Update existing record
                endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/dns_records/" + recordId;
                method = "PUT";
            } else {
                // Create new record
                endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId + "/dns_records";
                method = "POST";
            }
            
            String response = makeApiRequest(method, endpoint, payload.toString());
            JSONObject responseJson = new JSONObject(response);
            
            boolean success = responseJson.getBoolean("success");
            if (success) {
                LOGGER.info("DNS record " + (recordId != null ? "updated" : "created") + " successfully: " + name);
            } else {
                LOGGER.warning("DNS record operation failed: " + responseJson.toString());
            }
            
            return success;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating DNS record", e);
            return false;
        }
    }
    
    /**
     * Kiểm tra trạng thái zone
     */
    public Map<String, Object> getZoneStatus() {
        Map<String, Object> status = new HashMap<>();
        
        if (apiToken == null || zoneId == null) {
            status.put("configured", false);
            return status;
        }
        
        try {
            String endpoint = CLOUDFLARE_API_BASE + "/zones/" + zoneId;
            String response = makeApiRequest("GET", endpoint, null);
            JSONObject responseJson = new JSONObject(response);
            
            if (responseJson.getBoolean("success")) {
                JSONObject result = responseJson.getJSONObject("result");
                
                status.put("configured", true);
                status.put("name", result.getString("name"));
                status.put("status", result.getString("status"));
                status.put("paused", result.getBoolean("paused"));
                status.put("development_mode", result.getInt("development_mode"));
                
                LOGGER.info("Zone status retrieved successfully");
            } else {
                status.put("configured", false);
                LOGGER.warning("Failed to retrieve zone status: " + responseJson.toString());
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving zone status", e);
            status.put("configured", false);
        }
        
        return status;
    }
    
    /**
     * Make HTTP request to Cloudflare API
     */
    private String makeApiRequest(String method, String endpoint, String payload) throws IOException {
        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        // Set request method
        conn.setRequestMethod(method);
        
        // Set headers
        conn.setRequestProperty("Authorization", "Bearer " + apiToken);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("User-Agent", "Dental-Clinic-System/1.0");
        
        // Set timeouts
        conn.setConnectTimeout(30000); // 30 seconds
        conn.setReadTimeout(30000); // 30 seconds
        
        // Send payload if present
        if (payload != null && !payload.isEmpty()) {
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
        }
        
        // Read response
        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(
                conn.getResponseCode() >= 400 ? conn.getErrorStream() : conn.getInputStream(), "utf-8"))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }
        
        return response.toString();
    }
    
    /**
     * Utility methods cho cache management trong ứng dụng
     */
    
    /**
     * Purge cache khi cập nhật thông tin bệnh nhân
     */
    public void onPatientUpdate(Long patientId) {
        purgeCache(
            "/patient/profile/" + patientId,
            "/patient/appointments/" + patientId,
            "/patient/medical-records/" + patientId
        );
    }
    
    /**
     * Purge cache khi cập nhật thông tin bác sĩ
     */
    public void onDoctorUpdate(Long doctorId) {
        purgeCache(
            "/doctor/profile/" + doctorId,
            "/doctor/schedule/" + doctorId,
            "/services", // Service list might include doctor info
            "/booking" // Booking page shows doctor info
        );
    }
    
    /**
     * Purge cache khi cập nhật lịch hẹn
     */
    public void onAppointmentUpdate(Long appointmentId) {
        purgeCache(
            "/appointments",
            "/doctor/appointments",
            "/patient/appointments",
            "/booking"
        );
    }
    
    /**
     * Purge cache khi cập nhật dịch vụ
     */
    public void onServiceUpdate() {
        purgeCache(
            "/services",
            "/booking",
            "/static/js/services.js" // JS file might cache service data
        );
    }
    
    /**
     * Check if Cloudflare is properly configured
     */
    public boolean isConfigured() {
        return apiToken != null && zoneId != null && domain != null;
    }
    
    /**
     * Get domain name
     */
    public String getDomain() {
        return domain;
    }
} 