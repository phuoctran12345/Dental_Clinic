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
        String appointmentId = request.getParameter("appointmentId");
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<html><head><title>Đổi lịch hẹn</title></head><body>");
        response.getWriter().println("<h2>Đổi lịch hẹn cho appointmentId: " + appointmentId + "</h2>");
        response.getWriter().println("<form method='post'>");
        response.getWriter().println("Chọn ngày mới: <input type='date' name='newDate' required><br><br>");
        response.getWriter().println("Chọn giờ mới: <input type='time' name='newTime' required><br><br>");
        response.getWriter().println("<input type='hidden' name='appointmentId' value='" + appointmentId + "'>");
        response.getWriter().println("<button type='submit'>Xác nhận đổi lịch</button>");
        response.getWriter().println("</form>");
        response.getWriter().println("<a href='staff/staff_quanlylichhen.jsp'>&larr; Quay lại</a>");
        response.getWriter().println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String appointmentIdStr = request.getParameter("appointmentId");
        String doctorIdStr = request.getParameter("doctorId");
        String serviceIdStr = request.getParameter("serviceId");
        String newDate = request.getParameter("newDate");
        String newSlotIdStr = request.getParameter("newSlotId");
        String reason = request.getParameter("reason");
        String message = "";
        boolean success = false;
        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            int newSlotId = Integer.parseInt(newSlotIdStr);
            // Gọi DAO update lịch hẹn (KHÔNG đổi doctorId)
            success = dao.AppointmentDAO.rescheduleAppointment(appointmentId, serviceId, newDate, newSlotId, reason);
            if (success) {
                message = "Đổi lịch thành công!";
            } else {
                message = "Đổi lịch thất bại!";
            }
        } catch (Exception e) {
            message = "Lỗi đổi lịch: " + e.getMessage();
        }
        request.setAttribute("message", message);
        // Sau khi đổi lịch, forward về trang quản lý lịch hẹn
        request.getRequestDispatcher("jsp/staff/staff_quanlylichhen.jsp").forward(request, response);
    }
} 