package utils;

import java.util.logging.ConsoleHandler;
import java.util.logging.Formatter;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.util.logging.Logger;

/**
 * 🎨 Utility để hiển thị log có màu sắc trong NetBeans
 * SEVERE = Đỏ, WARNING = Vàng, INFO = Xanh
 */
public class ColoredLogger {
    
    /**
     * Log lỗi với màu đỏ và icon 🚨
     */
    public static void logError(String className, String message) {
        Logger logger = Logger.getLogger(className);
        logger.severe("🚨 ERROR: " + message);
    }
    
    /**
     * Log warning với màu vàng và icon ⚠️
     */
    public static void logWarning(String className, String message) {
        Logger logger = Logger.getLogger(className);
        logger.warning("⚠️ WARNING: " + message);
    }
    
    /**
     * Log info với màu xanh và icon ℹ️
     */
    public static void logInfo(String className, String message) {
        Logger logger = Logger.getLogger(className);
        logger.info("ℹ️ INFO: " + message);
    }
    
    /**
     * Log thành công với icon ✅
     */
    public static void logSuccess(String className, String message) {
        Logger logger = Logger.getLogger(className);
        logger.info("✅ SUCCESS: " + message);
    }
    
    /**
     * Log debug với icon 🔍
     */
    public static void logDebug(String className, String message) {
        Logger logger = Logger.getLogger(className);
        logger.fine("🔍 DEBUG: " + message);
    }
} 