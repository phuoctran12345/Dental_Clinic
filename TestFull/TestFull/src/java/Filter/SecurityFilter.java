//package Filter;
//
//import java.io.IOException;
//import java.util.*;
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
///**
// * 🛡️ SECURITY FILTER
// * Filter bảo mật cho hệ thống phòng khám nha khoa
// * Chống XSS, SQL Injection, CSRF và các tấn công cơ bản
// * 
// * @author TranHongPhuoc
// */
//@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
//public class SecurityFilter implements Filter {
//    
//    private static final boolean DEBUG = true;
//    private FilterConfig filterConfig = null;
//    
//    // HTTP Status Code cho Too Many Requests (429)
//    private static final int SC_TOO_MANY_REQUESTS = 429;
//    
//    // 🚫 DANH SÁCH PATTERN XSS
//    private static final String[] XSS_PATTERNS = {
//        "<script", "</script>", "javascript:", "onload=", "onerror=", 
//        "onclick=", "onmouseover=", "onfocus=", "onblur=", "onchange=",
//        "eval\\(", "expression\\(", "vbscript:", "livescript:",
//        "\\balert\\b", "\\bconfirm\\b", "\\bprompt\\b"
//    };
//    
//    // 🚫 DANH SÁCH PATTERN SQL INJECTION
//    private static final String[] SQL_INJECTION_PATTERNS = {
//        "('|(\\%27))|(\\-|\\%2D){2,}|;|\\%3B",
//        "\\w*(\\s)*(\\%20)*(\\s)*(union|select|insert|delete|update|create|drop|exec|execute)",
//        "(\\%27)|(\\')|(\\-|\\%2D){2,}",
//        "\\w*(\\s)*(\\%20)*(\\s)*(or|and)\\s*(\\%20)*(\\s)*\\w*(\\s)*(\\%20)*(\\s)*=",
//        "\\w*(\\s)*(\\%20)*(\\s)*(or|and)\\s*(\\%20)*(\\s)*[\"\\'][^\"\\']",
//        "\\w*(\\s)*(\\%20)*(\\s)*(or|and)\\s*(\\%20)*(\\s)*\\w*(\\s)*(\\%20)*(\\s)*[\"\\']\\s*(\\%20)*(\\s)*=\\s*(\\%20)*(\\s)*[\"\\']"
//    };
//    
//    // 🔒 DANH SÁCH TRANG CẦN CSRF PROTECTION
//    private static final Set<String> CSRF_PROTECTED_PAGES = new HashSet<>(Arrays.asList(
//        "/payment", "/PayOSServlet", "/BookingServlet", "/BookingPageServlet",
//        "/UpdateStaffInfoServlet", "/ChangePasswordServlet", "/Medicine"
//    ));
//    
//    public SecurityFilter() {}
//
//    @Override
//    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
//            throws IOException, ServletException {
//        
//        HttpServletRequest request = (HttpServletRequest) req;
//        HttpServletResponse response = (HttpServletResponse) res;
//        
//        String uri = request.getRequestURI();
//        String method = request.getMethod();
//        
//        if (DEBUG) {
//            System.out.println("🛡️ SecurityFilter: " + method + " " + uri);
//        }
//        
//        // ✅ 1. SET SECURITY HEADERS
//        setSecurityHeaders(response);
//        
//        // ✅ 2. KIỂM TRA XSS
//        if (containsXSS(request)) {
//            if (DEBUG) System.out.println("🚫 XSS attack detected: " + uri);
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request detected");
//            return;
//        }
//        
//        // ✅ 3. KIỂM TRA SQL INJECTION
//        if (containsSQLInjection(request)) {
//            if (DEBUG) System.out.println("🚫 SQL Injection attack detected: " + uri);
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request detected");
//            return;
//        }
//        
//        // ✅ 4. KIỂM TRA CSRF CHO POST REQUEST
//        if ("POST".equalsIgnoreCase(method) && needsCSRFProtection(uri)) {
//            if (!isValidCSRFToken(request)) {
//                if (DEBUG) System.out.println("🚫 CSRF attack detected: " + uri);
//                response.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token invalid");
//                return;
//            }
//        }
//        
//        // ✅ 5. RATE LIMITING (cơ bản)
//        if (isRateLimited(request)) {
//            if (DEBUG) System.out.println("🚫 Rate limit exceeded: " + uri);
//            response.sendError(SC_TOO_MANY_REQUESTS, "Too many requests");
//            return;
//        }
//        
//        if (DEBUG) {
//            System.out.println("✅ Security check passed: " + uri);
//        }
//        
//        // ✅ 6. TIẾP TỤC FILTER CHAIN
//        chain.doFilter(req, res);
//    }
//    
//    /**
//     * 🔒 Set security headers
//     */
//    private void setSecurityHeaders(HttpServletResponse response) {
//        // Chống clickjacking
//        response.setHeader("X-Frame-Options", "DENY");
//        
//        // Chống XSS
//        response.setHeader("X-XSS-Protection", "1; mode=block");
//        
//        // Chống MIME type sniffing
//        response.setHeader("X-Content-Type-Options", "nosniff");
//        
//        // Strict Transport Security (nếu dùng HTTPS)
//        // response.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
//        
//        // Content Security Policy (cơ bản)
//        response.setHeader("Content-Security-Policy", 
//            "default-src 'self'; " +
//            "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
//            "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
//            "img-src 'self' data: https:; " +
//            "font-src 'self' https://cdnjs.cloudflare.com;"
//        );
//        
//        // Referrer Policy
//        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
//    }
//    
//    /**
//     * 🚫 Kiểm tra XSS
//     */
//    private boolean containsXSS(HttpServletRequest request) {
//        // Kiểm tra parameters
//        Enumeration<String> paramNames = request.getParameterNames();
//        while (paramNames.hasMoreElements()) {
//            String paramName = paramNames.nextElement();
//            String[] paramValues = request.getParameterValues(paramName);
//            
//            if (paramValues != null) {
//                for (String paramValue : paramValues) {
//                    if (paramValue != null && containsXSSPattern(paramValue.toLowerCase())) {
//                        return true;
//                    }
//                }
//            }
//        }
//        
//        // Kiểm tra headers
//        Enumeration<String> headerNames = request.getHeaderNames();
//        while (headerNames.hasMoreElements()) {
//            String headerName = headerNames.nextElement();
//            String headerValue = request.getHeader(headerName);
//            
//            if (headerValue != null && containsXSSPattern(headerValue.toLowerCase())) {
//                return true;
//            }
//        }
//        
//        return false;
//    }
//    
//    /**
//     * 🚫 Kiểm tra SQL Injection
//     */
//    private boolean containsSQLInjection(HttpServletRequest request) {
//        Enumeration<String> paramNames = request.getParameterNames();
//        while (paramNames.hasMoreElements()) {
//            String paramName = paramNames.nextElement();
//            String[] paramValues = request.getParameterValues(paramName);
//            
//            if (paramValues != null) {
//                for (String paramValue : paramValues) {
//                    if (paramValue != null && containsSQLPattern(paramValue.toLowerCase())) {
//                        return true;
//                    }
//                }
//            }
//        }
//        
//        return false;
//    }
//    
//    /**
//     * 🔍 Kiểm tra XSS pattern
//     */
//    private boolean containsXSSPattern(String input) {
//        for (String pattern : XSS_PATTERNS) {
//            if (input.matches(".*" + pattern + ".*")) {
//                return true;
//            }
//        }
//        return false;
//    }
//    
//    /**
//     * 🔍 Kiểm tra SQL injection pattern
//     */
//    private boolean containsSQLPattern(String input) {
//        for (String pattern : SQL_INJECTION_PATTERNS) {
//            if (input.matches(".*" + pattern + ".*")) {
//                return true;
//            }
//        }
//        return false;
//    }
//    
//    /**
//     * 🔒 Kiểm tra cần CSRF protection
//     */
//    private boolean needsCSRFProtection(String uri) {
//        for (String protectedPage : CSRF_PROTECTED_PAGES) {
//            if (uri.contains(protectedPage)) {
//                return true;
//            }
//        }
//        return false;
//    }
//    
//    /**
//     * 🔒 Kiểm tra CSRF token (cơ bản)
//     */
//    private boolean isValidCSRFToken(HttpServletRequest request) {
//        // Đơn giản: kiểm tra referer header
//        String referer = request.getHeader("Referer");
//        String host = request.getHeader("Host");
//        
//        if (referer == null || host == null) {
//            return false;
//        }
//        
//        return referer.contains(host);
//    }
//    
//    /**
//     * 🚦 Rate limiting cơ bản
//     */
//    private boolean isRateLimited(HttpServletRequest request) {
//        // Đơn giản: giới hạn 100 request/phút từ 1 IP
//        // Trong thực tế nên dùng Redis hoặc cache system
//        String clientIP = getClientIP(request);
//        
//        // TODO: Implement proper rate limiting with cache
//        // Hiện tại return false để không block
//        return false;
//    }
//    
//    /**
//     * 🌐 Lấy IP thực của client
//     */
//    private String getClientIP(HttpServletRequest request) {
//        String xForwardedFor = request.getHeader("X-Forwarded-For");
//        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
//            return xForwardedFor.split(",")[0].trim();
//        }
//        
//        String xRealIP = request.getHeader("X-Real-IP");
//        if (xRealIP != null && !xRealIP.isEmpty()) {
//            return xRealIP;
//        }
//        
//        return request.getRemoteAddr();
//    }
//
//    @Override
//    public void init(FilterConfig filterConfig) {
//        this.filterConfig = filterConfig;
//        if (DEBUG) {
//            System.out.println("🛡️ Security Filter initialized");
//            System.out.println("🔒 XSS Protection: ON");
//            System.out.println("🔒 SQL Injection Protection: ON");
//            System.out.println("🔒 CSRF Protection: ON");
//            System.out.println("🔒 Security Headers: ON");
//        }
//    }
//
//    @Override
//    public void destroy() {
//        this.filterConfig = null;
//        if (DEBUG) {
//            System.out.println("🛡️ Security Filter destroyed");
//        }
//    }
//    
//    /**
//     * 📝 Log message
//     */
//    private void log(String msg) {
//        if (filterConfig != null) {
//            filterConfig.getServletContext().log("[SecurityFilter] " + new Date() + ": " + msg);
//        }
//        if (DEBUG) {
//            System.out.println("[SecurityFilter] " + msg);
//        }
//    }
//} 