package controller;

import dao.DoctorScheduleDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ScheduleApprovalServlet", urlPatterns = {"/manager_phancong"})
public class ScheduleApprovalServlet extends HttpServlet {
    private DoctorScheduleDAO scheduleDAO;

    @Override
    public void init() throws ServletException {
        scheduleDAO = new DoctorScheduleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách lịch cần phê duyệt
        request.setAttribute("pendingSchedules", scheduleDAO.getAllPendingSchedules());
        request.getRequestDispatcher("/manager_phancong.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
        String action = request.getParameter("action");
        
        String status = action.equals("approve") ? "approved" : "rejected";
        
        if (scheduleDAO.updateScheduleStatus(scheduleId, status)) {
            request.setAttribute("message", "Cập nhật trạng thái thành công!");
        } else {
            request.setAttribute("error", "Cập nhật trạng thái thất bại!");
        }
        
        response.sendRedirect(request.getContextPath() + "/manager_phancong");
    }
} 