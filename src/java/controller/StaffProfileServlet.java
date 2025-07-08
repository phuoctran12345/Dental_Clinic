package controller;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import model.Staff;
import model.User;
import dao.StaffDAO;
import dao.UserDAO;


@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,  // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class StaffProfileServlet extends HttpServlet {
    private static final String RETURN_URL = "/jsp/staff/staff_taikhoan.jsp";
    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg"};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String staffIdStr = request.getParameter("staffId");
        String userIdStr = request.getParameter("userId");
        Staff staff = null;
        
        System.out.println("=== STAFFPROFILESERVLET DEBUG START ===");
        System.out.println("[StaffProfileServlet] Request URL: " + request.getRequestURL());
        System.out.println("[StaffProfileServlet] staffIdStr=" + staffIdStr + ", userIdStr=" + userIdStr);
        System.out.println("[StaffProfileServlet] Session ID: " + session.getId());
        
        // Debug session attributes
        User sessionUser = (User) session.getAttribute("user");
        System.out.println("[StaffProfileServlet] Session user: " + (sessionUser != null ? sessionUser.getId() + " - " + sessionUser.getEmail() : "null"));
        System.out.println("[StaffProfileServlet] Session role: " + session.getAttribute("role"));
        System.out.println("[StaffProfileServlet] Session staff_id: " + session.getAttribute("staff_id"));
        
        try {
            if (staffIdStr != null) {
                int staffId = Integer.parseInt(staffIdStr);
                System.out.println("[StaffProfileServlet] Lấy staff theo staffId=" + staffId);
                staff = StaffDAO.getStaffById(staffId);
            } else if (userIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                System.out.println("[StaffProfileServlet] Lấy staff theo userId=" + userId);
                staff = StaffDAO.getStaffByUserId(userId);
            } else if (sessionUser != null) {
                System.out.println("[StaffProfileServlet] Lấy staff theo user session: userId=" + sessionUser.getId());
                staff = StaffDAO.getStaffByUserId(sessionUser.getId());
            } else {
                System.out.println("[StaffProfileServlet] Không có staffId, userId, hoặc user session!");
            }
        } catch (Exception e) {
            System.out.println("[StaffProfileServlet] Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi lấy thông tin nhân viên: " + e.getMessage());
        }
        
        // Lấy thông báo thành công từ session (nếu có)
        String success = (String) session.getAttribute("success");
        if (success != null) {
            request.setAttribute("success", success);
            session.removeAttribute("success");
        }
        
        System.out.println("[StaffProfileServlet] staff=" + (staff != null ? staff.toString() : "null"));
        System.out.println("[StaffProfileServlet] Setting staff attribute in request...");
        request.setAttribute("staff", staff);
        // Lấy user theo staff.getUserId() nếu staff khác null
        if (staff != null) {
            User user = UserDAO.getUserById((int) staff.getUserId());
            request.setAttribute("user", user);
        }
        
        System.out.println("[StaffProfileServlet] Forwarding to: " + RETURN_URL);
        System.out.println("=== STAFFPROFILESERVLET DEBUG END ===");
        
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
            request.getRequestDispatcher(RETURN_URL).forward(request, response);
            return;
        }
        String type = request.getParameter("type");
        if ("update_info".equals(type)) {
            // Cập nhật thông tin staff
            String staffIdStr = request.getParameter("staffId");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dobStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String employmentType = request.getParameter("employmentType");
            String avatar = request.getParameter("avatar"); // Có thể truyền avatar nếu muốn
            if (staffIdStr == null || fullName == null || phone == null || dobStr == null || gender == null || address == null || position == null || employmentType == null ||
                staffIdStr.trim().isEmpty() || fullName.trim().isEmpty() || phone.trim().isEmpty() || dobStr.trim().isEmpty() || gender.trim().isEmpty() || address.trim().isEmpty() || position.trim().isEmpty() || employmentType.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin nhân viên.");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            try {
                int staffId = Integer.parseInt(staffIdStr);
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date utilDate = sdf.parse(dobStr);
                Date sqlDate = new Date(utilDate.getTime());
                Staff staff = StaffDAO.getStaffById(staffId);
                if (staff == null) {
                    request.setAttribute("error", "Không tìm thấy nhân viên");
                    request.getRequestDispatcher(RETURN_URL).forward(request, response);
                    return;
                }
                staff.setFullName(fullName);
                staff.setPhone(phone);
                staff.setDateOfBirth(sqlDate);
                staff.setGender(gender);
                staff.setAddress(address);
                staff.setPosition(position);
                staff.setEmploymentType(employmentType);
                if (avatar != null && !avatar.trim().isEmpty()) {
                    staff.setAvatar(avatar);
                }
                boolean updated = StaffDAO.updateStaff(staff);
                if (updated) {
                    request.setAttribute("success", "Cập nhật thông tin nhân viên thành công.");
                } else {
                    request.setAttribute("error", "Cập nhật thông tin thất bại.");
                }
            } catch (ParseException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ.");
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
        } else if ("update_avatar".equals(type)) {
            // Cập nhật avatar staff
            String staffIdStr = request.getParameter("staffId");
            if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Không tìm thấy ID nhân viên");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            int staffId;
            try {
                staffId = Integer.parseInt(staffIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID nhân viên không hợp lệ");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            Part filePart = request.getPart("profilePicture");
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Vui lòng chọn file ảnh");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            String fileName = extractFileName(filePart);
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!isValidExtension(fileExtension)) {
                request.setAttribute("error", "Chỉ chấp nhận file PNG, JPG hoặc JPEG");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            String newFileName = "staff_" + staffId + "_" + System.currentTimeMillis() + fileExtension;
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);
            String relativePath = "/" + UPLOAD_DIR + "/" + newFileName;
            try {
                Staff staff = StaffDAO.getStaffById(staffId);
                if (staff == null) {
                    request.setAttribute("error", "Không tìm thấy nhân viên");
                    request.getRequestDispatcher(RETURN_URL).forward(request, response);
                    return;
                }
                staff.setAvatar(relativePath);
                boolean updated = StaffDAO.updateStaff(staff);
                if (updated) {
                    // Sử dụng session để truyền thông báo và redirect
                    session.setAttribute("success", "Cập nhật ảnh đại diện thành công");
                    response.sendRedirect(request.getContextPath() + "/StaffProfileServlet");
                    return;
                } else {
                    request.setAttribute("error", "Lỗi khi cập nhật ảnh đại diện");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
            // Nếu có lỗi, forward như cũ
            request.getRequestDispatcher(RETURN_URL).forward(request, response);
            return;
        } else if ("insert".equals(type)) {
            // Thêm nhân viên mới
            String userIdStr = request.getParameter("userId");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dobStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String position = request.getParameter("position");
            String employmentType = request.getParameter("employmentType");
            if (userIdStr == null || fullName == null || phone == null || dobStr == null || gender == null || address == null || position == null || employmentType == null ||
                userIdStr.trim().isEmpty() || fullName.trim().isEmpty() || phone.trim().isEmpty() || dobStr.trim().isEmpty() || gender.trim().isEmpty() || address.trim().isEmpty() || position.trim().isEmpty() || employmentType.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin nhân viên.");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            try {
                int userId = Integer.parseInt(userIdStr);
                boolean inserted = StaffDAO.insert(userId, fullName, phone, dobStr, gender, address, position, employmentType);
                if (inserted) {
                    request.setAttribute("success", "Thêm nhân viên thành công.");
                } else {
                    request.setAttribute("error", "Thêm nhân viên thất bại.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
        } else if ("update_account".equals(type)) {
            String userIdStr = request.getParameter("userId");
            String email = request.getParameter("email");
            String oldPassword = request.getParameter("oldPassword");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            if (userIdStr == null || email == null || userIdStr.trim().isEmpty() || email.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin tài khoản.");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }
            try {
                int userId = Integer.parseInt(userIdStr);
                model.User user = dao.UserDAO.getUserById(userId);
                if ((password != null && !password.trim().isEmpty()) || (confirmPassword != null && !confirmPassword.trim().isEmpty()) || (oldPassword != null && !oldPassword.trim().isEmpty())) {
                    // Đổi mật khẩu: bắt buộc nhập đủ 3 trường
                    if (oldPassword == null || oldPassword.trim().isEmpty() || password == null || password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                        request.setAttribute("error", "Vui lòng nhập đủ mật khẩu cũ, mật khẩu mới và xác nhận mật khẩu mới.");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }
                    if (!password.equals(confirmPassword)) {
                        request.setAttribute("error", "Mật khẩu mới và xác nhận không khớp!");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }
                    // Validate mật khẩu mới: tối thiểu 5 ký tự, có ít nhất 1 chữ cái và 1 số
                    if (password.length() < 5 || !password.matches(".*[A-Za-z].*") || !password.matches(".*[0-9].*")) {
                        request.setAttribute("error", "Mật khẩu mới phải từ 5 ký tự trở lên, có ít nhất 1 chữ cái và 1 số!");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }
                    if (!oldPassword.equals(user.getPasswordHash())) {
                        request.setAttribute("error", "Mật khẩu cũ không đúng!");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }
                } else {
                    // Không đổi mật khẩu, chỉ đổi email
                    password = null;
                }
                boolean updated = dao.UserDAO.updateUserAccount(userId, email, password);
                if (updated) {
                    session.setAttribute("success", "Cập nhật tài khoản thành công");
                    response.sendRedirect(request.getContextPath() + "/StaffProfileServlet");
                    return;
                } else {
                    request.setAttribute("error", "Cập nhật tài khoản thất bại.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
            }
            request.getRequestDispatcher(RETURN_URL).forward(request, response);
            return;
        } else {
            request.setAttribute("error", "Yêu cầu không hợp lệ");
        }
        
        // Sau khi xử lý POST, luôn lấy lại staff mới nhất để hiển thị
        try {
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser != null) {
                Staff updatedStaff = StaffDAO.getStaffByUserId(sessionUser.getId());
                System.out.println("[StaffProfileServlet POST] Updated staff: " + (updatedStaff != null ? updatedStaff.toString() : "null"));
                request.setAttribute("staff", updatedStaff);
                // Lấy user theo staff.getUserId() nếu staff khác null
                if (updatedStaff != null) {
                    User user = UserDAO.getUserById((int) updatedStaff.getUserId());
                    request.setAttribute("user", user);
                }
            }
        } catch (Exception e) {
            System.out.println("[StaffProfileServlet POST] Error getting updated staff: " + e.getMessage());
        }
        
        request.getRequestDispatcher(RETURN_URL).forward(request, response);
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

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private boolean isValidExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equals(extension)) {
                return true;
            }
        }
        return false;
    }
} 