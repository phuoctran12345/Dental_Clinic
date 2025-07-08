package utils;

import java.text.NumberFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Utility class để format dữ liệu một cách an toàn
 */
public class FormatUtils {
    
    private static final NumberFormat CURRENCY_FORMAT = NumberFormat.getInstance(new Locale("vi", "VN"));
    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");
    
    /**
     * Format số tiền an toàn
     */
    public static String formatAmount(Object amount) {
        if (amount == null) return "0";
        
        try {
            if (amount instanceof Number) {
                return CURRENCY_FORMAT.format(((Number) amount).doubleValue());
            } else if (amount instanceof String) {
                double value = Double.parseDouble((String) amount);
                return CURRENCY_FORMAT.format(value);
            }
        } catch (Exception e) {
            // Silent fallback
        }
        
        return String.valueOf(amount);
    }
    
    /**
     * Format số tiền với đơn vị VND
     */
    public static String formatAmountWithCurrency(Object amount) {
        return formatAmount(amount) + " VNĐ";
    }
    
    /**
     * Format LocalDate an toàn
     */
    public static String formatDate(LocalDate date) {
        if (date == null) return "N/A";
        
        try {
            return date.format(DATE_FORMAT);
        } catch (Exception e) {
            return date.toString();
        }
    }
    
    /**
     * Format LocalTime an toàn
     */
    public static String formatTime(LocalTime time) {
        if (time == null) return "N/A";
        
        try {
            return time.format(TIME_FORMAT);
        } catch (Exception e) {
            return time.toString();
        }
    }
    
    /**
     * Format khoảng thời gian an toàn
     */
    public static String formatTimeRange(LocalTime startTime, LocalTime endTime) {
        String start = formatTime(startTime);
        String end = formatTime(endTime);
        return start + " - " + end;
    }
    
    /**
     * Escape HTML để tránh XSS
     */
    public static String escapeHtml(String text) {
        if (text == null) return "";
        
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;");
    }
    
    /**
     * Safe toString
     */
    public static String safeToString(Object obj) {
        return obj != null ? obj.toString() : "N/A";
    }
}