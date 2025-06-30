/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Filter;

import model.User;
import java.io.IOException;
import java.util.*;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 🏥 DENTAL CLINIC ROLE FILTER
 * Filter tổng quát cho hệ thống phòng khám nha khoa
 * Hỗ trợ: PATIENT, DOCTOR, STAFF, MANAGER
 *
 * @author TranHongPhuoc
 */
// @WebFilter(filterName = "RoleFilter", urlPatterns = {"/*"})
public class RoleFilter implements Filter {
    
    private static final boolean DEBUG = true;
    private FilterConfig filterConfig = null;
    
    // 🔓 DANH SÁCH TRANG CÔNG KHAI (không cần đăng nhập)
    private static final Set<String> PUBLIC_PAGES = new HashSet<>(Arrays.asList(
        "/login.jsp",
        "/signup.jsp", 
        "/home.jsp",
        "/information.jsp",
        "/test-encoding.jsp",
        "/LoginServlet",
        "/SignUpServlet",
        "/RegisterServlet",
        "/GoogleCallbackServlet",
        "/services", // Trang dịch vụ công khai
        "/payment-success.jsp",
        "/payment-cancel.jsp"
    ));
    
    // 🔓 DANH SÁCH ĐƯỜNG DẪN CÔNG KHAI (pattern)
    private static final Set<String> PUBLIC_PATTERNS = new HashSet<>(Arrays.asList(
        "/images/",
        "/styles/", 
        "/js/",
        "/css/",
        "/META-INF/",
        "/WEB-INF/",
        "/includes/",
        "/common/",
        "/favicon.ico"
    ));
    
    // 🏥 CẤU HÌNH QUYỀN TRUY CẬP CHO TỪNG ROLE
    private static final Map<String, Set<String>> ROLE_ACCESS_MAP = new HashMap<>();
    
    static {
        // 👤 PATIENT - Bệnh nhân
        ROLE_ACCESS_MAP.put("PATIENT", new HashSet<>(Arrays.asList(
            "/jsp/patient/",
            "/BookingPageServlet",
            "/BookingServlet", 
            "/PatientAppointments",
            "/payment",
            "/PayOSServlet",
            "/checkBill",
            "/services",
            "/UserHompageServlet",
            "/AvatarServlet",
            "/UpdateStaffInfoServlet",
            "/ChangePasswordServlet",
            "/LogoutServlet"
        )));
        
        // 👨‍⚕️ DOCTOR - Bác sĩ
        ROLE_ACCESS_MAP.put("DOCTOR", new HashSet<>(Arrays.asList(
            "/doctor/",
            "/jsp/doctor/",
            "/DoctorScheduleServlet",
            "/DoctorScheduleConfirmServlet", 
            "/DoctorAppointmentsServlet",
            "/DoctorWorkDaysServlet",
            "/MedicalReport",
            "/AvatarServlet",
            "/UpdateStaffInfoServlet",
            "/ChangePasswordServlet",
            "/LogoutServlet"
        )));
        
        // 👩‍💼 STAFF - Nhân viên
        ROLE_ACCESS_MAP.put("STAFF", new HashSet<>(Arrays.asList(
            "/staff_homepage.jsp",
            "/staff_datlich.jsp",
            "/staff_tuvan.jsp",
            "/staff_view_patient.jsp",
            "/staff_taikhoan.jsp",
            "/StaffInfoServlet",
            "/StaffViewPatientServlet",
            "/UpdateStaffInfoServlet",
            "/ChangePasswordServlet",
            "/AvatarServlet",
            "/LogoutServlet"
        )));
        
        // 👨‍💼 MANAGER - Quản lý
        ROLE_ACCESS_MAP.put("MANAGER", new HashSet<>(Arrays.asList(
            "/manager_menu.jsp",
            "/manager_tongquan.jsp", 
            "/manager_doctors.jsp",
            "/manager_staff.jsp",
            "/manager_users.jsp",
            "/manager_medicine.jsp",
            "/manager_blogs.jsp",
            "/manager_phancong.jsp",
            "/Medicine",
            "/ScheduleApprovalServlet",
            "/AvatarServlet",
            "/UpdateStaffInfoServlet", 
            "/ChangePasswordServlet",
            "/LogoutServlet"
        )));
    }
    
    public RoleFilter() {}

    @Override
     public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // Loại bỏ context path để lấy đường dẫn thực
        String path = uri.substring(contextPath.length());
        
        if (DEBUG) {
            System.out.println("🔍 RoleFilter: " + request.getMethod() + " " + path);
        }
        
        // ✅ 1. KIỂM TRA TRANG CÔNG KHAI
        if (isPublicPage(path)) {
            if (DEBUG) System.out.println("✅ Public page: " + path);
            chain.doFilter(req, res);
            return;
        }

        // ✅ 2. KIỂM TRA SESSION VÀ USER
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            if (DEBUG) System.out.println("❌ No session/user, redirect to login");
            redirectToLogin(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        String userRole = user.getRole();
        
        if (DEBUG) {
            System.out.println("👤 User: " + user.getUsername() + " | Role: " + userRole);
        }
        
        // ✅ 3. KIỂM TRA QUYỀN TRUY CẬP
        if (hasAccess(userRole, path)) {
            if (DEBUG) System.out.println("✅ Access granted for " + userRole + " to " + path);
            chain.doFilter(req, res);
        } else {
            if (DEBUG) System.out.println("❌ Access denied for " + userRole + " to " + path);
            handleAccessDenied(request, response, userRole);
        }
    }
    
    /**
     * 🔓 Kiểm tra trang có phải công khai không
     */
    private boolean isPublicPage(String path) {
        // Kiểm tra exact match
        if (PUBLIC_PAGES.contains(path)) {
            return true;
        }
        
        // Kiểm tra pattern match
        for (String pattern : PUBLIC_PATTERNS) {
            if (path.startsWith(pattern)) {
                return true;
            }
        }
        
        // Kiểm tra các servlet công khai
        for (String publicPage : PUBLIC_PAGES) {
            if (path.contains(publicPage)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 🔐 Kiểm tra quyền truy cập của role
     */
    private boolean hasAccess(String userRole, String path) {
        if (userRole == null) {
            return false;
        }
        
        Set<String> allowedPaths = ROLE_ACCESS_MAP.get(userRole.toUpperCase());
        if (allowedPaths == null) {
            return false;
        }
        
        // Kiểm tra exact match hoặc pattern match
        for (String allowedPath : allowedPaths) {
            if (path.equals(allowedPath) || path.startsWith(allowedPath) || path.contains(allowedPath)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * 🔄 Chuyển hướng đến trang login
     */
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String loginUrl = request.getContextPath() + "/login.jsp";
        response.sendRedirect(loginUrl);
    }
    
    /**
     * 🚫 Xử lý khi bị từ chối truy cập
     */
    private void handleAccessDenied(HttpServletRequest request, HttpServletResponse response, String userRole) 
            throws IOException {
        
        // Chuyển hướng về trang chủ tương ứng với role
        String redirectUrl = getHomePageByRole(userRole);
        String fullUrl = request.getContextPath() + redirectUrl;
        
        if (DEBUG) {
            System.out.println("🔄 Redirecting " + userRole + " to: " + fullUrl);
        }
        
        response.sendRedirect(fullUrl);
    }
    
    /**
     * 🏠 Lấy trang chủ theo role
     */
    private String getHomePageByRole(String role) {
        switch (role.toUpperCase()) {
            case "PATIENT":
                return "/jsp/patient/user_services.jsp";
            case "DOCTOR": 
                return "/doctor/doctor_homepage.jsp";
            case "STAFF":
                return "/staff_homepage.jsp";
            case "MANAGER":
                return "/manager_tongquan.jsp";
            default:
                return "/login.jsp";
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (DEBUG) {
            System.out.println("🏥 Dental Clinic RoleFilter initialized");
            System.out.println("📋 Supported roles: " + ROLE_ACCESS_MAP.keySet());
        }
    }

    @Override
    public void destroy() {
        this.filterConfig = null;
        if (DEBUG) {
            System.out.println("🏥 Dental Clinic RoleFilter destroyed");
        }
    }
    
    /**
     * 📝 Log message với timestamp
     */
    private void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log("[RoleFilter] " + new Date() + ": " + msg);
        }
        if (DEBUG) {
            System.out.println("[RoleFilter] " + msg);
        }
    }
}
