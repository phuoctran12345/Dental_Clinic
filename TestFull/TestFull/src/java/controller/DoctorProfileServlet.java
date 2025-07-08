package controller;

import dao.DoctorDAO;
import model.Doctors;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet to display the personal profile of the logged-in doctor.
 */
@WebServlet("/doctor_trangcanhan")
public class DoctorProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin user từ session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy thông tin chi tiết bác sĩ dựa trên userId
            Doctors doctor_trangcanhan = DoctorDAO.getDoctorByUserId(user.getUserId());
            if (doctor_trangcanhan == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            // Đặt thông tin bác sĩ vào request để hiển thị trên JSP
            request.setAttribute("doctor_trangcanhan", doctor_trangcanhan);
            request.setAttribute("pageTitle", "Hồ Sơ Cá Nhân Bác Sĩ");

            // Chuyển hướng đến JSP
            request.getRequestDispatcher("/jsp/doctor/doctor_trangcanhan.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to display the personal profile of a logged-in doctor.";
    }
}