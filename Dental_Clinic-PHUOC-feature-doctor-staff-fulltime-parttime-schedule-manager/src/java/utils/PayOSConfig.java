package utils;

/**
 * PayOS Configuration
 * @author TranHongPhuoc
 */
public class PayOSConfig {
    
    // PayOS Credentials - Thay thế bằng thông tin thực của bạn
    public static final String CLIENT_ID = "abc";
    public static final String API_KEY = "abc";
    public static final String CHECKSUM_KEY = "fb900671a9ba381ee0d0ef0019a580781a499aac332d6473f88156914d74f5bb";

    
    // PayOS URLs
    public static final String PAYOS_BASE_URL = "https://api-merchant.payos.vn";
    public static final String CREATE_PAYMENT_URL = PAYOS_BASE_URL + "/v2/payment-requests";
    public static final String GET_PAYMENT_URL = PAYOS_BASE_URL + "/v2/payment-requests";
    
    // Return URLs
    public static final String SUCCESS_URL = "http://localhost:8080/TestFull/PaymentSuccessServlet";
    public static final String CANCEL_URL = "http://localhost:8080/TestFull/PaymentCancelServlet";
    public static final String WEBHOOK_URL = "http://localhost:8080/TestFull/PayOSWebhookServlet";
    
    // Payment configurations
    public static final String CURRENCY = "VND";
    public static final int EXPIRATION_TIME = 15; // minutes
    
    private PayOSConfig() {
        // Private constructor to prevent instantiation
    }
} 