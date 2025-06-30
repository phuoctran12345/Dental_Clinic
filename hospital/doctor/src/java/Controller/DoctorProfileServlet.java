package Controller;

import Model.DoctorDB;
import Model.Doctors;
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
    private DoctorDB doctorDB;

    @Override
    public void init() throws ServletException {
        super.init();
        doctorDB = new DoctorDB();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin bác sĩ từ session
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/jsp/doctor/login.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy userId từ doctor trong session
            int userId = doctor.getUserId();
            // Lấy thông tin chi tiết bác sĩ dựa trên userId
            Doctors doctor_trangcanhan = doctorDB.getInforDoctor(userId);
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
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
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