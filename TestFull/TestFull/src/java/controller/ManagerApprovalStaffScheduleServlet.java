package controller;

import dao.StaffScheduleDAO;
import dao.DoctorScheduleDAO;
import model.StaffSchedule;
import model.DoctorSchedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý phê duyệt lịch làm việc/nghỉ phép của Staff bởi Manager
 * @author TranHongPhuoc
 */
@WebServlet(name = "ManagerApprovalStaffScheduleServlet", urlPatterns = {"/StaffScheduleApprovalServlet"})
public class ManagerApprovalStaffScheduleServlet extends HttpServlet {
    
    private StaffScheduleDAO staffScheduleDAO;
    private DoctorScheduleDAO doctorScheduleDAO;

    @Override
    public void init() throws ServletException {
        staffScheduleDAO = new StaffScheduleDAO();
        doctorScheduleDAO = new DoctorScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Không tạo session mới
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"MANAGER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            // Lấy danh sách staff requests chờ phê duyệt
            List<StaffSchedule> pendingStaffRequests = staffScheduleDAO.getPendingRequests();
            // Đảm bảo mỗi StaffSchedule có employmentType và slotId
            for (StaffSchedule s : pendingStaffRequests) {
                if (s.getEmploymentType() == null || s.getEmploymentType().isEmpty()) {
                    dao.StaffDAO staffDAO = new dao.StaffDAO();
                    model.Staff staff = staffDAO.getStaffById(s.getStaffId());
                    if (staff != null) {
                        s.setEmploymentType(staff.getEmploymentType());
                    }
                }
            }
            // Lấy danh sách doctor schedules chờ phê duyệt (nếu có)
            List<DoctorSchedule> pendingDoctorSchedules = doctorScheduleDAO.getAllPendingSchedules();
            // Set attributes
            request.setAttribute("pendingStaffRequests", pendingStaffRequests);
            request.setAttribute("pendingDoctorSchedules", pendingDoctorSchedules);
            // Forward đến JSP
            request.getRequestDispatcher("/jsp/manager/manager_phancong.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/manager_phancong.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false); // Không tạo session mới
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        Integer managerId = (session != null) ? (Integer) session.getAttribute("userId") : null;
        System.out.println("[DEBUG] POST /StaffScheduleApprovalServlet - role=" + role + ", managerId=" + managerId);
        if (!"MANAGER".equals(role) || managerId == null) {
            System.out.println("[ERROR] Không có quyền hoặc chưa đăng nhập, chuyển về login.jsp");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            String action = request.getParameter("action");
            String requestType = request.getParameter("request_type");
            System.out.println("[DEBUG] action=" + action + ", requestType=" + requestType);
            if ("staff".equals(requestType)) {
                handleStaffRequest(request, response, managerId, action);
            } else if ("doctor".equals(requestType)) {
                handleDoctorRequest(request, response, managerId, action);
            } else {
                System.out.println("[ERROR] Loại request không hợp lệ!");
                request.setAttribute("error", "Loại request không hợp lệ!");
            }
        } catch (Exception e) {
            System.out.println("[ERROR] Exception khi xử lý POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        // Luôn redirect về trang phê duyệt
        response.sendRedirect(request.getContextPath() + "/ScheduleApprovalServlet");
    }

    /**
     * Xử lý phê duyệt/từ chối staff request
     */
    private void handleStaffRequest(HttpServletRequest request, HttpServletResponse response, 
                                   int managerId, String action) throws ServletException, IOException {
        String scheduleIdStr = request.getParameter("schedule_id");
        System.out.println("[DEBUG] handleStaffRequest - schedule_id=" + scheduleIdStr + ", action=" + action + ", managerId=" + managerId);
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            System.out.println("[ERROR] Schedule ID không hợp lệ!");
            request.setAttribute("error", "Schedule ID không hợp lệ!");
            return;
        }
        try {
            long scheduleId = Long.parseLong(scheduleIdStr);
            String status = null;
            String message = null;
            if ("approve".equals(action)) {
                status = "approved";
                message = "Đã phê duyệt thành công!";
            } else if ("reject".equals(action)) {
                status = "rejected";
                message = "Đã từ chối request!";
            } else {
                System.out.println("[ERROR] Action không hợp lệ!");
                request.setAttribute("error", "Action không hợp lệ!");
                return;
            }
            System.out.println("[DEBUG] Gọi DAO updateRequestStatus với scheduleId=" + scheduleId + ", status=" + status + ", managerId=" + managerId);
            boolean success = staffScheduleDAO.updateRequestStatus((int) scheduleId, status, managerId);
            if (success) {
                System.out.println("[DEBUG] Cập nhật trạng thái thành công cho schedule_id=" + scheduleId + ", status=" + status);
                request.setAttribute("message", message);
            } else {
                System.out.println("[ERROR] Cập nhật trạng thái thất bại cho schedule_id=" + scheduleId + ", status=" + status);
                request.setAttribute("error", "Cập nhật trạng thái thất bại!");
            }
        } catch (NumberFormatException e) {
            System.out.println("[ERROR] Schedule ID không hợp lệ! " + e.getMessage());
            request.setAttribute("error", "Schedule ID không hợp lệ!");
        } catch (Exception e) {
            System.out.println("[ERROR] Exception khi cập nhật trạng thái: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
    }

    /**
     * Xử lý phê duyệt/từ chối doctor request
     */
    private void handleDoctorRequest(HttpServletRequest request, HttpServletResponse response, 
                                    int managerId, String action) throws ServletException, IOException {
        String scheduleIdStr = request.getParameter("schedule_id");
        if (scheduleIdStr == null || scheduleIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Schedule ID không hợp lệ!");
            return;
        }
        try {
            long scheduleId = Long.parseLong(scheduleIdStr);
            String status = null;
            String message = null;
            if ("approve".equals(action)) {
                status = "approved";
                message = "Đã phê duyệt lịch bác sĩ thành công!";
            } else if ("reject".equals(action)) {
                status = "rejected";
                message = "Đã từ chối lịch bác sĩ!";
            } else {
                request.setAttribute("error", "Action không hợp lệ!");
                return;
            }
            // Gọi DAO cập nhật trạng thái lịch bác sĩ
            boolean success = doctorScheduleDAO.updateScheduleStatus((int) scheduleId, status);
            if (success) {
                request.setAttribute("message", message);
            } else {
                request.setAttribute("error", "Cập nhật trạng thái bác sĩ thất bại!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Schedule ID không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
    }
} 