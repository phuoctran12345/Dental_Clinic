package Controller;

import Model.DoctorDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.User;
import java.io.IOException;

/**
 * Servlet xử lý chức năng đổi mật khẩu cho bác sĩ
 */
public class DoctorChangePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập mã hóa cho response và request
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // Lấy session
        HttpSession session = request.getSession(false); // Không tạo session mới nếu chưa tồn tại
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin user từ session
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getRole().equals("doctor")) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra dữ liệu đầu vào
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("doctor_changepassword.jsp").forward(request, response);
            return;
        }

        if (currentPassword == null || !currentPassword.equals(user.getPasswordHash())) {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("doctor_changepassword.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu mới
        boolean updated = DoctorDB.updatePassword(user.getUserId(), newPassword);
        if (updated) {
            user.setPasswordHash(newPassword); // Cập nhật session
            request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật mật khẩu!");
        }

        // Chuyển hướng về trang JSP
        request.getRequestDispatcher("doctor_changepassword.jsp").forward(request, response);
    }
}