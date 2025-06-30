package controller;

import dao.StaffDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Staff;
import model.User;

public class UpdateStaffInfoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        try {
            // Lấy thông tin từ form và kiểm tra null/empty
            String staffIdStr = request.getParameter("staff_id");
            String userIdStr = request.getParameter("user_id");
            
            if (staffIdStr == null || staffIdStr.trim().isEmpty() || 
                userIdStr == null || userIdStr.trim().isEmpty()) {
                response.sendRedirect("staff_taikhoan.jsp?error=missing_id");
                return;
            }
            
            int staffId = Integer.parseInt(staffIdStr);
            int userId = Integer.parseInt(userIdStr);
            
            String fullName = request.getParameter("full-name");
            String phone = request.getParameter("phone");
            String dateOfBirth = request.getParameter("date_of_birth");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String email = request.getParameter("email");
            
            // Kiểm tra các trường bắt buộc
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                response.sendRedirect("staff_taikhoan.jsp?error=missing_required_fields");
                return;
            }
            
            // Cập nhật thông tin trong bảng users
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setEmail(email);
                userDAO.updateUser(user);
            }
            
            // Cập nhật thông tin trong bảng staff
            StaffDAO staffDAO = new StaffDAO();
            Staff staff = staffDAO.getStaffByUserId(userId);
            if (staff != null) {
                staff.setFullName(fullName);
                staff.setPhone(phone != null ? phone : "");
                staff.setDateOfBirth(dateOfBirth != null && !dateOfBirth.trim().isEmpty() ? 
                    java.sql.Date.valueOf(dateOfBirth) : null);
                staff.setGender(gender != null ? gender : "other");
                staff.setAddress(address != null ? address : "");
                staffDAO.updateStaff(staff);
            }
            
            // Cập nhật session
            session.setAttribute("user", user);
            session.setAttribute("staff", staff);
            
            response.sendRedirect("staff_taikhoan.jsp?success=true");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("staff_taikhoan.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("staff_taikhoan.jsp?error=true");
        }
    }
} 