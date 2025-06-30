package utils;

/**
 * PayOS Configuration
 * @author TranHongPhuoc
 */
public class PayOSConfig {
    
    // PayOS Credentials - Lấy từ biến môi trường để bảo mật
    public static final String CLIENT_ID = System.getenv("PAYOS_CLIENT_ID");
    public static final String API_KEY = System.getenv("PAYOS_API_KEY");
    public static final String CHECKSUM_KEY = System.getenv("PAYOS_CHECKSUM_KEY");
    
    // PayOS URLs
    public static final String PAYOS_BASE_URL = "https://api-merchant.payos.vn";
    public static final String CREATE_PAYMENT_URL = PAYOS_BASE_URL + "/v2/payment-requests";
    public static final String GET_PAYMENT_URL = PAYOS_BASE_URL + "/v2/payment-requests";
    
    // Return URLs
    public static final String SUCCESS_URL = "http://localhost:8080/RoleStaff/PaymentSuccessServlet";
    public static final String CANCEL_URL = "http://localhost:8080/RoleStaff/PaymentCancelServlet";
    public static final String WEBHOOK_URL = "http://localhost:8080/RoleStaff/PayOSWebhookServlet";
    
    // Payment configurations
    public static final String CURRENCY = "VND";
    public static final int EXPIRATION_TIME = 15; // minutes
    
    private PayOSConfig() {
        // Private constructor to prevent instantiation
    }
} 