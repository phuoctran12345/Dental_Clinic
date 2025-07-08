package utils;

import java.util.logging.ConsoleHandler;
import java.util.logging.Formatter;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 🎨 Custom Logger với màu sắc đẹp cho Dental Clinic
 * Hiển thị lỗi màu đỏ, warning màu vàng, info màu xanh
 */
public class DentalClinicLogger {
    
    // ANSI Color Codes
    public static final String RESET = "\u001B[0m";
    public static final String BLACK = "\u001B[30m";
    public static final String RED = "\u001B[31m";
    public static final String GREEN = "\u001B[32m";
    public static final String YELLOW = "\u001B[33m";
    public static final String BLUE = "\u001B[34m";
    public static final String PURPLE = "\u001B[35m";
    public static final String CYAN = "\u001B[36m";
    public static final String WHITE = "\u001B[37m";
    
    // Bright colors
    public static final String BRIGHT_RED = "\u001B[91m";
    public static final String BRIGHT_GREEN = "\u001B[92m";
    public static final String BRIGHT_YELLOW = "\u001B[93m";
    public static final String BRIGHT_BLUE = "\u001B[94m";
    public static final String BRIGHT_PURPLE = "\u001B[95m";
    public static final String BRIGHT_CYAN = "\u001B[96m";
    public static final String BRIGHT_WHITE = "\u001B[97m";
    
    // Background colors
    public static final String BG_RED = "\u001B[41m";
    public static final String BG_GREEN = "\u001B[42m";
    public static final String BG_YELLOW = "\u001B[43m";
    
    /**
     * Custom Formatter với màu sắc
     */
    public static class ColoredFormatter extends Formatter {
        
        private final DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        
        @Override
        public String format(LogRecord record) {
            LocalDateTime time = LocalDateTime.now();
            String level = record.getLevel().toString();
            String className = getShortClassName(record.getSourceClassName());
            String message = record.getMessage();
            
            // Chọn màu theo level
            String levelColor = getLevelColor(record.getLevel());
            String messageColor = getMessageColor(record.getLevel());
            
            // Format: [Time] [LEVEL] ClassName - Message
            return String.format("%s[%s]%s %s[%s]%s %s%s%s - %s%s%s%n",
                CYAN, timeFormatter.format(time), RESET,        // Thời gian màu cyan
                levelColor, level, RESET,                       // Level với màu tương ứng
                BLUE, className, RESET,                         // Class name màu xanh
                messageColor, message, RESET                    // Message với màu tương ứng
            );
        }
        
        /**
         * Lấy màu cho level
         */
        private String getLevelColor(Level level) {
            if (level.intValue() >= Level.SEVERE.intValue()) {
                return BG_RED + BRIGHT_WHITE;  // Nền đỏ, chữ trắng cho SEVERE
            } else if (level.intValue() >= Level.WARNING.intValue()) {
                return BRIGHT_YELLOW;          // Vàng sáng cho WARNING
            } else if (level.intValue() >= Level.INFO.intValue()) {
                return BRIGHT_GREEN;           // Xanh sáng cho INFO
            } else if (level.intValue() >= Level.CONFIG.intValue()) {
                return BRIGHT_CYAN;            // Cyan sáng cho CONFIG
            } else {
                return WHITE;                  // Trắng cho FINE, FINER, FINEST
            }
        }
        
        /**
         * Lấy màu cho message
         */
        private String getMessageColor(Level level) {
            if (level.intValue() >= Level.SEVERE.intValue()) {
                return BRIGHT_RED;             // Đỏ sáng cho message SEVERE
            } else if (level.intValue() >= Level.WARNING.intValue()) {
                return YELLOW;                 // Vàng cho message WARNING
            } else {
                return RESET;                  // Màu bình thường cho message khác
            }
        }
        
        /**
         * Rút gọn tên class
         */
        private String getShortClassName(String className) {
            if (className == null) return "Unknown";
            
            String[] parts = className.split("\\.");
            if (parts.length > 0) {
                return parts[parts.length - 1]; // Chỉ lấy tên class cuối
            }
            return className;
        }
    }
    
    /**
     * Tạo logger với màu sắc
     */
    public static Logger getColoredLogger(String name) {
        Logger logger = Logger.getLogger(name);
        logger.setUseParentHandlers(false);
        
        // Tạo console handler với custom formatter
        ConsoleHandler consoleHandler = new ConsoleHandler();
        consoleHandler.setFormatter(new ColoredFormatter());
        consoleHandler.setLevel(Level.ALL);
        
        logger.addHandler(consoleHandler);
        logger.setLevel(Level.ALL);
        
        return logger;
    }
    
    /**
     * Utility methods để log nhanh
     */
    public static void logError(String className, String message) {
        Logger logger = getColoredLogger(className);
        logger.severe("🚨 " + message);
    }
    
    public static void logWarning(String className, String message) {
        Logger logger = getColoredLogger(className);
        logger.warning("⚠️ " + message);
    }
    
    public static void logInfo(String className, String message) {
        Logger logger = getColoredLogger(className);
        logger.info("ℹ️ " + message);
    }
    
    public static void logSuccess(String className, String message) {
        Logger logger = getColoredLogger(className);
        logger.info("✅ " + message);
    }
    
    public static void logDebug(String className, String message) {
        Logger logger = getColoredLogger(className);
        logger.fine("🔍 " + message);
    }
} 