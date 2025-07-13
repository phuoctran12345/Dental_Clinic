package controller;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Staff;
import model.User;
import dao.StaffDAO;
import dao.UserDAO;

@WebServlet(name = "StaffProfileServlet", urlPatterns = {"/StaffProfileServlet"})
public class StaffProfileServlet extends HttpServlet {

    private static final String RETURN_URL = "/jsp/staff/staff_taikhoan.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String staffIdStr = request.getParameter("staffId");
        String userIdStr = request.getParameter("userId");
        Staff staff = null;

        User sessionUser = (User) session.getAttribute("user");

        try {
            if (staffIdStr != null) {
                int staffId = Integer.parseInt(staffIdStr);
                staff = StaffDAO.getStaffById(staffId);
            } else if (userIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                staff = StaffDAO.getStaffByUserId(userId);
            } else if (sessionUser != null) {
                staff = StaffDAO.getStaffByUserId(sessionUser.getId());
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi lấy thông tin nhân viên: " + e.getMessage());
        }

        // Lấy thông báo thành công từ session (nếu có)
        String success = (String) session.getAttribute("success");
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }

        request.setAttribute("staff", staff);
        if (staff != null) {
            User user = UserDAO.getUserById((int) staff.getUserId());
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher(RETURN_URL).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            request.setAttribute("error", "Phiên đăng nhập đã hết hạn");
            loadStaffToRequest(request, currentUser);
            request.getRequestDispatcher(RETURN_URL).forward(request, response);
            return;
        }

        String type = request.getParameter("type");

        try {
            switch (type) {
                case "update_info":
                    handleUpdateInfo(request);
                    break;
                case "insert":
                    handleInsertStaff(request);
                    break;
                case "update_account":
                    if (handleUpdateAccount(request, session)) {
                        response.sendRedirect(request.getContextPath() + "/StaffProfileServlet");
                        return;
                    }
                    break;
                default:
                    request.setAttribute("error", "Yêu cầu không hợp lệ");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
        }

        loadStaffToRequest(request, currentUser);
        request.getRequestDispatcher(RETURN_URL).forward(request, response);
    }

    private void handleUpdateInfo(HttpServletRequest request) throws Exception {
        String staffIdStr = request.getParameter("staffId");
        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Thiếu ID nhân viên.");
            return;
        }
        int staffId = Integer.parseInt(staffIdStr);
        Staff staff = StaffDAO.getStaffById(staffId);
        if (staff == null) {
            request.setAttribute("error", "Không tìm thấy nhân viên.");
            return;
        }

        String fullName = request.getParameter("fullName");
        if (fullName != null && !fullName.trim().isEmpty()) staff.setFullName(fullName);

        String phone = request.getParameter("phone");
        if (phone != null && !phone.trim().isEmpty()) staff.setPhone(phone);

        String dobStr = request.getParameter("dateOfBirth");
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                staff.setDateOfBirth(new Date(sdf.parse(dobStr).getTime()));
            } catch (ParseException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ.");
                return;
            }
        }

        String gender = request.getParameter("gender");
        if (gender != null && !gender.trim().isEmpty()) staff.setGender(gender);

        String address = request.getParameter("address");
        if (address != null && !address.trim().isEmpty()) staff.setAddress(address);

        String position = request.getParameter("position");
        if (position != null && !position.trim().isEmpty()) staff.setPosition(position);

        String employmentType = request.getParameter("employmentType");
        if (employmentType != null && !employmentType.trim().isEmpty()) staff.setEmploymentType(employmentType);

        if (StaffDAO.updateStaff(staff)) {
            request.setAttribute("success", "Cập nhật thông tin thành công.");
        } else {
            request.setAttribute("error", "Cập nhật thất bại.");
        }
    }

    private void handleInsertStaff(HttpServletRequest request) {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dob = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String employmentType = request.getParameter("employmentType");

            if (fullName == null || phone == null || dob == null || gender == null || address == null || position == null || employmentType == null ||
                fullName.isEmpty() || phone.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
                return;
            }

            if (StaffDAO.insert(userId, fullName, phone, dob, gender, address, position, employmentType)) {
                request.setAttribute("success", "Thêm nhân viên thành công.");
            } else {
                request.setAttribute("error", "Không thể thêm nhân viên.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    private boolean handleUpdateAccount(HttpServletRequest request, HttpSession session) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String email = request.getParameter("email");
        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            return false;
        }

        User user = UserDAO.getUserById(userId);
        if ((newPass != null && !newPass.trim().isEmpty()) ||
            (confirmPass != null && !confirmPass.trim().isEmpty()) ||
            (oldPass != null && !oldPass.trim().isEmpty())) {

            if (oldPass == null || newPass == null || confirmPass == null ||
                oldPass.isEmpty() || newPass.isEmpty() || confirmPass.isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đủ thông tin đổi mật khẩu.");
                return false;
            }

            if (!newPass.equals(confirmPass)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
                return false;
            }

            if (!oldPass.equals(user.getPasswordHash())) {
                request.setAttribute("error", "Mật khẩu cũ không đúng.");
                return false;
            }

            if (newPass.length() < 5 || !newPass.matches(".*[A-Za-z].*") || !newPass.matches(".*[0-9].*")) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 5 ký tự, gồm chữ và số.");
                return false;
            }
        } else {
            newPass = null;
        }

        if (UserDAO.updateUserAccount(userId, email, newPass)) {
            session.setAttribute("success", "Cập nhật tài khoản thành công.");
            return true;
        } else {
            request.setAttribute("error", "Không thể cập nhật tài khoản.");
            return false;
        }
    }

    private void loadStaffToRequest(HttpServletRequest request, User user) {
        try {
            if (user != null) {
                Staff staff = StaffDAO.getStaffByUserId(user.getId());
                request.setAttribute("staff", staff);
                if (staff != null) {
                    User account = UserDAO.getUserById((int) staff.getUserId());
                    request.setAttribute("user", account);
                }
            }
        } catch (Exception e) {
            System.out.println("[loadStaffToRequest] Error: " + e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String staffIdStr = request.getParameter("staffId");
        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            response.getWriter().write("Không tìm thấy ID nhân viên");
            return;
        }
        try {
            int staffId = Integer.parseInt(staffIdStr);
            boolean deleted = StaffDAO.delete(staffId);
            if (deleted) {
                response.getWriter().write("Xoá nhân viên thành công");
            } else {
                response.getWriter().write("Xoá nhân viên thất bại");
            }
        } catch (Exception e) {
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }
}
