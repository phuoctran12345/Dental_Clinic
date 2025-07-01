package controller;

import dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import model.User;

public class UpdateUserServlet extends HttpServlet {
    private static final String RETURN_URL = "/jsp/patient/user_taikhoan.jsp";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            request.setAttribute("error", "Phiên đăng nhập đã hết hạn");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/patient/user_taikhoan.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        String type = request.getParameter("type");
        
        // Xử lý đổi mật khẩu
        if ("password".equals(type)) {
                    String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
                    String confirmPassword = request.getParameter("confirmPassword");
                    
            // Kiểm tra các trường không được rỗng
            if (oldPassword == null || newPassword == null || confirmPassword == null || 
                oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/patient/user_taikhoan.jsp");
                dispatcher.forward(request, response);
                        return;
                    }
                    
            // Kiểm tra mật khẩu mới và xác nhận mật khẩu phải giống nhau
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/patient/user_taikhoan.jsp");
                dispatcher.forward(request, response);
                        return;
                    }
                    
            // Kiểm tra mật khẩu cũ có đúng không
            if (!oldPassword.equals(currentUser.getPasswordHash())) {
                request.setAttribute("error", "Mật khẩu cũ không đúng");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/patient/user_taikhoan.jsp");
                dispatcher.forward(request, response);
                    return;
            }
            
            // Cập nhật mật khẩu mới
            boolean success = UserDAO.updatePasswordHash(currentUser.getId(), newPassword);
            
            if (success) {
                // Cập nhật lại session
                currentUser.setPasswordHash(newPassword);
                    session.setAttribute("user", currentUser);
                request.setAttribute("success", "Đổi mật khẩu thành công");
            } else {
                request.setAttribute("error", "Lỗi khi cập nhật mật khẩu");
            }
        } else {
            request.setAttribute("error", "Yêu cầu không hợp lệ");
    }
    
        // Forward về trang user_taikhoan.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/patient/user_taikhoan.jsp");
        dispatcher.forward(request, response);
    }
}
