package controller;

import dao.StaffDAO;
import dao.StaffScheduleDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Staff;
import model.StaffSchedule;
import model.User;

/**
 * Servlet xử lý phê duyệt/từ chối yêu cầu lịch làm việc của staff
 * Chỉ manager mới có quyền truy cập
 */
@WebServlet(name = "StaffScheduleApprovalServlet", urlPatterns = {"/StaffScheduleApprovalServlet"})
public class StaffScheduleApprovalServlet extends HttpServlet {
    
    private StaffDAO staffDAO;
    private StaffScheduleDAO scheduleDAO;
    
    @Override
    public void init() {
        staffDAO = new StaffDAO();
        scheduleDAO = new StaffScheduleDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        Staff manager = null;
        try {
            manager = staffDAO.getStaffByUserId(user.getId());
        } catch (SQLException ex) {
            Logger.getLogger(StaffScheduleApprovalServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (manager == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Lấy danh sách yêu cầu chờ phê duyệt
        List<StaffSchedule> pendingRequests = scheduleDAO.getPendingRequests();
        request.setAttribute("pendingRequests", pendingRequests);
        
        request.getRequestDispatcher("jsp/manager/manager_phancong.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        Staff manager = null;
        try {
            manager = staffDAO.getStaffByUserId(user.getId());
        } catch (SQLException ex) {
            Logger.getLogger(StaffScheduleApprovalServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (manager == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        String action = request.getParameter("action");

        if (scheduleIdStr == null || action == null) {
            response.sendRedirect("StaffScheduleApprovalServlet?error=missing_parameters");
            return;
        }

        int scheduleId = Integer.parseInt(scheduleIdStr);
        String status = "approved".equals(action) ? "approved" : "rejected";

        // Cập nhật trạng thái yêu cầu
        if (scheduleDAO.updateRequestStatus(scheduleId, status, (int) manager.getStaffId())) {
            response.sendRedirect("StaffScheduleApprovalServlet?success=request_" + status);
        } else {
            response.sendRedirect("StaffScheduleApprovalServlet?error=update_failed");
        }
    }
    
    @Override
    public void destroy() {
        if (staffDAO != null) {
            staffDAO.close();
        }
        if (scheduleDAO != null) {
            scheduleDAO.close();
        }
    }
} 