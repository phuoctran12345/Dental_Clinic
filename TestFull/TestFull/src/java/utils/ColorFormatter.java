package utils;

import java.util.logging.Formatter;
import java.util.logging.Level;
import java.util.logging.LogRecord;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 🎨 Color Formatter cho Tomcat Console
 * Hiển thị log với màu sắc dễ đọc
 */
public class ColorFormatter extends Formatter {
    
    // ANSI Color Codes
    public static final String RESET = "\u001B[0m";
    public static final String RED = "\u001B[31m";
    public static final String GREEN = "\u001B[32m";
    public static final String YELLOW = "\u001B[33m";
    public static final String BLUE = "\u001B[34m";
    public static final String PURPLE = "\u001B[35m";
    public static final String CYAN = "\u001B[36m";
    public static final String WHITE = "\u001B[37m";
    public static final String BOLD = "\u001B[1m";
    
    // Background Colors
    public static final String RED_BG = "\u001B[41m";
    public static final String YELLOW_BG = "\u001B[43m";
    
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm:ss");
    
    @Override
    public String format(LogRecord record) {
        StringBuilder sb = new StringBuilder();
        
        // Timestamp
        LocalDateTime time = LocalDateTime.now();
        sb.append(CYAN).append("[").append(time.format(TIME_FORMAT)).append("]").append(RESET).append(" ");
        
        // Level với màu sắc
        String levelColor = getLevelColor(record.getLevel());
        String levelText = String.format("%-7s", record.getLevel().getName());
        sb.append(levelColor).append(levelText).append(RESET).append(" ");
        
        // Logger name (class name)
        String loggerName = record.getLoggerName();
        if (loggerName != null) {
            // Chỉ lấy tên class cuối cùng
            String shortName = loggerName.contains(".") ? 
                loggerName.substring(loggerName.lastIndexOf(".") + 1) : loggerName;
            sb.append(BLUE).append(shortName).append(RESET).append(" - ");
        }
        
        // Message
        String message = record.getMessage();
        if (isErrorMessage(message) || record.getLevel().intValue() >= Level.SEVERE.intValue()) {
            sb.append(RED).append(BOLD).append(message).append(RESET);
        } else if (record.getLevel().intValue() >= Level.WARNING.intValue()) {
            sb.append(YELLOW).append(message).append(RESET);
        } else if (message.contains("SUCCESS") || message.contains("✅")) {
            sb.append(GREEN).append(message).append(RESET);
        } else {
            sb.append(message);
        }
        
        // Exception stack trace
        if (record.getThrown() != null) {
            sb.append("\n").append(RED_BG).append(WHITE).append(BOLD);
            sb.append("🚨 EXCEPTION: ").append(record.getThrown().getClass().getSimpleName());
            sb.append(RESET).append("\n");
            sb.append(RED).append(record.getThrown().getMessage()).append(RESET);
            
            // Stack trace (chỉ hiện 5 dòng đầu)
            StackTraceElement[] stack = record.getThrown().getStackTrace();
            for (int i = 0; i < Math.min(5, stack.length); i++) {
                sb.append("\n").append(RED).append("  at ").append(stack[i].toString()).append(RESET);
            }
            if (stack.length > 5) {
                sb.append("\n").append(RED).append("  ... and ").append(stack.length - 5).append(" more").append(RESET);
            }
        }
        
        sb.append("\n");
        return sb.toString();
    }
    
    private String getLevelColor(Level level) {
        if (level.intValue() >= Level.SEVERE.intValue()) {
            return RED_BG + WHITE + BOLD; // Màu đỏ nền cho SEVERE
        } else if (level.intValue() >= Level.WARNING.intValue()) {
            return YELLOW + BOLD; // Màu vàng cho WARNING
        } else if (level.intValue() >= Level.INFO.intValue()) {
            return GREEN; // Màu xanh cho INFO
        } else {
            return BLUE; // Màu xanh dương cho DEBUG/FINE
        }
    }
    
    private boolean isErrorMessage(String message) {
        if (message == null) return false;
        
        String lowerMessage = message.toLowerCase();
        return lowerMessage.contains("error") || 
               lowerMessage.contains("exception") || 
               lowerMessage.contains("failed") || 
               lowerMessage.contains("❌") ||
               lowerMessage.contains("🚨") ||
               lowerMessage.contains("sql") && lowerMessage.contains("error");
    }
} 