package utils;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

/**
 * Service để tạo và quản lý OTP
 * @author ASUS
 */
public class OTPService {
    
    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRY_MINUTES = 5;
    private static final String OTP_CHARACTERS = "0123456789";
    
    /**
     * Tạo mã OTP ngẫu nhiên
     * @return Mã OTP 6 số
     */
    public static String generateOTP() {
        SecureRandom random = new SecureRandom();
        StringBuilder otp = new StringBuilder();
        
        for (int i = 0; i < OTP_LENGTH; i++) {
            int index = random.nextInt(OTP_CHARACTERS.length());
            otp.append(OTP_CHARACTERS.charAt(index));
        }
        
        return otp.toString();
    }
    
    /**
     * Tạo OTP data để lưu vào session
     * @param otp Mã OTP
     * @return OTPData object
     */
    public static OTPData createOTPData(String otp) {
        return new OTPData(otp, LocalDateTime.now().plus(OTP_EXPIRY_MINUTES, ChronoUnit.MINUTES));
    }
    
    /**
     * Kiểm tra OTP có hợp lệ không
     * @param otpData OTP data từ session
     * @param inputOTP OTP người dùng nhập
     * @return true nếu OTP hợp lệ và chưa hết hạn
     */
    public static boolean verifyOTP(OTPData otpData, String inputOTP) {
        if (otpData == null || inputOTP == null) {
            return false;
        }
        
        // Kiểm tra OTP có đúng không
        if (!otpData.getOtp().equals(inputOTP.trim())) {
            return false;
        }
        
        // Kiểm tra OTP có hết hạn không
        return LocalDateTime.now().isBefore(otpData.getExpiryTime());
    }
    
    /**
     * Kiểm tra OTP có hết hạn không
     * @param otpData OTP data từ session
     * @return true nếu đã hết hạn
     */
    public static boolean isExpired(OTPData otpData) {
        if (otpData == null) {
            return true;
        }
        return LocalDateTime.now().isAfter(otpData.getExpiryTime());
    }
    
    /**
     * Lấy thời gian còn lại của OTP (tính bằng giây)
     * @param otpData OTP data từ session
     * @return Số giây còn lại, -1 nếu đã hết hạn
     */
    public static long getRemainingSeconds(OTPData otpData) {
        if (otpData == null) {
            return -1;
        }
        
        LocalDateTime now = LocalDateTime.now();
        if (now.isAfter(otpData.getExpiryTime())) {
            return -1;
        }
        
        return ChronoUnit.SECONDS.between(now, otpData.getExpiryTime());
    }
    
    /**
     * Class để lưu thông tin OTP
     */
    public static class OTPData {
        private String otp;
        private LocalDateTime expiryTime;
        private String email;
        
        public OTPData(String otp, LocalDateTime expiryTime) {
            this.otp = otp;
            this.expiryTime = expiryTime;
        }
        
        public OTPData(String otp, LocalDateTime expiryTime, String email) {
            this.otp = otp;
            this.expiryTime = expiryTime;
            this.email = email;
        }
        
        // Getters and Setters
        public String getOtp() {
            return otp;
        }
        
        public void setOtp(String otp) {
            this.otp = otp;
        }
        
        public LocalDateTime getExpiryTime() {
            return expiryTime;
        }
        
        public void setExpiryTime(LocalDateTime expiryTime) {
            this.expiryTime = expiryTime;
        }
        
        public String getEmail() {
            return email;
        }
        
        public void setEmail(String email) {
            this.email = email;
        }
        
        @Override
        public String toString() {
            return "OTPData{" +
                    "otp='" + otp + '\'' +
                    ", expiryTime=" + expiryTime +
                    ", email='" + email + '\'' +
                    '}';
        }
    }
} 