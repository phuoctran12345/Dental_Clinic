package controller;

import dao.DoctorScheduleDAO;
import dao.StaffScheduleDAO;
import model.DoctorSchedule;
import model.StaffSchedule;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet load data cho trang phê duyệt lịch của manager
 * Load cả doctor schedules và staff requests
 */
@WebServlet("/ManagerApprovalPage")
public class ManagerApprovalDoctorSchedulerServlet extends HttpServlet {
    
    private DoctorScheduleDAO doctorScheduleDAO;
    private StaffScheduleDAO staffScheduleDAO;
    
    @Override
    public void init() {
        doctorScheduleDAO = new DoctorScheduleDAO();
        staffScheduleDAO = new StaffScheduleDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền truy cập - chỉ manager
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Lấy danh sách doctor schedules chờ phê duyệt
            List<DoctorSchedule> pendingDoctorSchedules = new ArrayList<>();
            try {
                // Sử dụng method đúng có trong DoctorScheduleDAO
                pendingDoctorSchedules = doctorScheduleDAO.getAllPendingSchedules();
            } catch (Exception e) {
                // Method might not be implemented yet
                System.out.println("DoctorScheduleDAO.getAllPendingSchedules() error: " + e.getMessage());
                pendingDoctorSchedules = new ArrayList<>();
            }
            
            // Lấy danh sách staff requests chờ phê duyệt
            List<StaffSchedule> pendingStaffRequests = staffScheduleDAO.getPendingRequests();
            
            // Đảm bảo mỗi StaffSchedule có employmentType và slotId
            for (StaffSchedule s : pendingStaffRequests) {
                if (s.getEmploymentType() == null || s.getEmploymentType().isEmpty()) {
                    // Lấy employmentType từ Staff nếu chưa có
                    // (Giả sử StaffDAO có hàm getStaffById)
                    dao.StaffDAO staffDAO = new dao.StaffDAO();
                    model.Staff staff = staffDAO.getStaffById(s.getStaffId());
                    if (staff != null) {
                        s.setEmploymentType(staff.getEmploymentType());
                    }
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("pendingDoctorSchedules", pendingDoctorSchedules);
            request.setAttribute("pendingStaffRequests", pendingStaffRequests);
            
            // Debug info
            System.out.println("Manager approval page - Doctor schedules: " + pendingDoctorSchedules.size() + 
                             ", Staff requests: " + pendingStaffRequests.size());
            
            // Forward to JSP
            request.getRequestDispatcher("jsp/manager/manager_phancong.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("jsp/manager/manager_phancong.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST requests are redirected to GET
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        if (doctorScheduleDAO != null) {
            doctorScheduleDAO = null;
        }
        if (staffScheduleDAO != null) {
            staffScheduleDAO.close();
        }
    }
} 