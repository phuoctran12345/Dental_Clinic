package utils;

import java.util.logging.Level;
import java.util.logging.LogManager;
import java.io.InputStream;

/**
 * Utility class cho logging trong RoleStaff project
 * Thay thế System.out.println bằng logging chuyên nghiệp
 */
public class Logger {
    
    private static final java.util.logging.Logger logger = 
        java.util.logging.Logger.getLogger("RoleStaff");
    
    static {
        try {
            // Load cấu hình logging từ file
            InputStream configFile = Logger.class.getClassLoader()
                .getResourceAsStream("logging.properties");
            if (configFile != null) {
                LogManager.getLogManager().readConfiguration(configFile);
                configFile.close();
            }
        } catch (Exception e) {
            System.err.println("Không thể load cấu hình logging: " + e.getMessage());
        }
    }
    
    /**
     * Log thông tin debug
     */
    public static void debug(String message) {
        logger.log(Level.FINE, "[DEBUG] " + message);
    }
    
    /**
     * Log thông tin debug với class name
     */
    public static void debug(Class<?> clazz, String message) {
        logger.log(Level.FINE, "[DEBUG][" + clazz.getSimpleName() + "] " + message);
    }
    
    /**
     * Log thông tin general
     */
    public static void info(String message) {
        logger.log(Level.INFO, "[INFO] " + message);
    }
    
    /**
     * Log thông tin với class name
     */
    public static void info(Class<?> clazz, String message) {
        logger.log(Level.INFO, "[INFO][" + clazz.getSimpleName() + "] " + message);
    }
    
    /**
     * Log cảnh báo
     */
    public static void warning(String message) {
        logger.log(Level.WARNING, "[WARNING] " + message);
    }
    
    /**
     * Log cảnh báo với class name
     */
    public static void warning(Class<?> clazz, String message) {
        logger.log(Level.WARNING, "[WARNING][" + clazz.getSimpleName() + "] " + message);
    }
    
    /**
     * Log lỗi
     */
    public static void error(String message) {
        logger.log(Level.SEVERE, "[ERROR] " + message);
    }
    
    /**
     * Log lỗi với class name
     */
    public static void error(Class<?> clazz, String message) {
        logger.log(Level.SEVERE, "[ERROR][" + clazz.getSimpleName() + "] " + message);
    }
    
    /**
     * Log lỗi với exception
     */
    public static void error(String message, Throwable throwable) {
        logger.log(Level.SEVERE, "[ERROR] " + message, throwable);
    }
    
    /**
     * Log lỗi với class name và exception
     */
    public static void error(Class<?> clazz, String message, Throwable throwable) {
        logger.log(Level.SEVERE, "[ERROR][" + clazz.getSimpleName() + "] " + message, throwable);
    }
    
    /**
     * Log SQL query (để debug database)
     */
    public static void sql(String query) {
        logger.log(Level.INFO, "[SQL] " + query);
    }
    
    /**
     * Log SQL query với parameters
     */
    public static void sql(String query, Object... params) {
        StringBuilder sb = new StringBuilder("[SQL] ");
        sb.append(query);
        if (params != null && params.length > 0) {
            sb.append(" | Params: ");
            for (int i = 0; i < params.length; i++) {
                if (i > 0) sb.append(", ");
                sb.append(params[i]);
            }
        }
        logger.log(Level.INFO, sb.toString());
    }
    
    /**
     * Log thông tin user action
     */
    public static void userAction(String username, String action) {
        logger.log(Level.INFO, "[USER_ACTION] " + username + " - " + action);
    }
    
    /**
     * Log thông tin authentication
     */
    public static void auth(String message) {
        logger.log(Level.INFO, "[AUTH] " + message);
    }
    
    /**
     * Log thông tin session
     */
    public static void session(String message) {
        logger.log(Level.FINE, "[SESSION] " + message);
    }
} 