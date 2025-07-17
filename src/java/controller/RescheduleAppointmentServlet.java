package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RescheduleAppointmentServlet", urlPatterns = {"/RescheduleAppointmentServlet"})
public class RescheduleAppointmentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách lịch hẹn cho staff (có thể lọc theo trạng thái)
        java.util.List<model.Appointment> appointments = new dao.AppointmentDAO().getAllAppointmentsWithDetails();
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("jsp/staff/staff_doilich.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("appointmentId");
        String newDate = request.getParameter("newDate");
        String newSlotIdStr = request.getParameter("newSlotId");
        String reason = request.getParameter("reason");
        String message = "";
        boolean success = false;
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int newSlotId = Integer.parseInt(newSlotIdStr);
            // Chỉ update work_date và slot_id
            success = dao.AppointmentDAO.updateAppointmentForReschedule(appointmentId, newDate, newSlotId);
            if (success) {
                message = "Đổi lịch thành công!";
            } else {
                message = "Đổi lịch thất bại!";
            }
        } catch (Exception e) {
            message = "Lỗi đổi lịch: " + e.getMessage();
        }
        request.setAttribute("message", message);
        // Load lại danh sách lịch hẹn
        java.util.List<model.Appointment> appointments = new dao.AppointmentDAO().getAllAppointmentsWithDetails();
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("jsp/staff/staff_doilich.jsp").forward(request, response);
    }
} 