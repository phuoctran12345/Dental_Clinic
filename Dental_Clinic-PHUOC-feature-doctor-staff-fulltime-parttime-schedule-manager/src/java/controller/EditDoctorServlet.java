package controller;

import dao.DoctorDAO;
import model.Doctors;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.sql.Date;

@WebServlet("/EditDoctorServlet")
public class EditDoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Kiểm tra session an toàn
            HttpSession session = request.getSession(false);
            if (session == null) {
                System.out.println("DEBUG: Session is null");
                request.setAttribute("errorMessage", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin user từ session
            User user = (User) session.getAttribute("user");
            if (user == null) {
                System.out.println("DEBUG: User is null in session");
                request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Kiểm tra userId
            if (user.getUserId() <= 0) {
                System.out.println("DEBUG: User ID is invalid: " + user.getUserId());
                request.setAttribute("errorMessage", "Thông tin người dùng không hợp lệ");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            System.out.println("DEBUG: User ID = " + user.getUserId());

            // Luôn lấy thông tin chi tiết bác sĩ mới nhất từ database
            Doctors doctorInfo = DoctorDAO.getDoctorByUserId(user.getUserId());
            if (doctorInfo == null) {
                System.out.println("DEBUG: Doctor info is null for user ID: " + user.getUserId());
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            // Debug logging
            System.out.println("DEBUG doGet - Doctor found: " + doctorInfo.getFullName());
            System.out.println("DEBUG doGet - Gender from DB: '" + doctorInfo.getGender() + "'");
            System.out.println("DEBUG doGet - Status from DB: '" + doctorInfo.getStatus() + "'");

            // Cập nhật lại session với thông tin mới nhất từ database
            session.setAttribute("doctor", doctorInfo);
            
            // Đặt thông tin bác sĩ vào request để hiển thị trên form
            request.setAttribute("doctor", doctorInfo);
            request.setAttribute("pageTitle", "Chỉnh sửa thông tin bác sĩ");
            request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            try {
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
            } catch (Exception ex) {
                // Nếu forward thất bại, chỉ ghi log
                System.out.println("Failed to forward to error page: " + ex.getMessage());
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Kiểm tra session an toàn
            HttpSession session = request.getSession(false);
            if (session == null) {
                System.out.println("DEBUG POST: Session is null");
                request.setAttribute("errorMessage", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin user từ session để đảm bảo chỉ user đang đăng nhập chỉnh sửa được thông tin của mình
            User user = (User) session.getAttribute("user");
            if (user == null) {
                System.out.println("DEBUG POST: User is null in session");
                request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Kiểm tra userId
            if (user.getUserId() <= 0) {
                System.out.println("DEBUG: User ID is invalid: " + user.getUserId());
                request.setAttribute("errorMessage", "Thông tin người dùng không hợp lệ");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin doctor hiện tại để giữ status
            Doctors currentDoctor = DoctorDAO.getDoctorByUserId(user.getUserId());
            if (currentDoctor == null) {
                System.out.println("DEBUG POST: Current doctor is null for user ID: " + user.getUserId());
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            // Lấy dữ liệu từ form
            String fullName = request.getParameter("full_name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String dateOfBirthStr = request.getParameter("date_of_birth");
            String gender = request.getParameter("gender");
            String specialty = request.getParameter("specialty");
            String licenseNumber = request.getParameter("license_number");
            // Không cho phép bác sĩ tự thay đổi status - giữ nguyên status hiện tại
            String status = currentDoctor.getStatus(); // Lấy từ DB thay vì form
            String avatar = request.getParameter("avatar");

            // Debug logging
            System.out.println("DEBUG doPost - Gender from form: '" + gender + "'");
            System.out.println("DEBUG doPost - Status kept from DB: '" + status + "'");

            // Chuyển đổi date_of_birth từ String sang java.sql.Date
            Date dateOfBirth = null;
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date parsedDate = sdf.parse(dateOfBirthStr);
                    dateOfBirth = new Date(parsedDate.getTime());
                } catch (ParseException e) {
                    request.setAttribute("errorMessage", "Định dạng ngày sinh không hợp lệ");
                    request.setAttribute("doctor", currentDoctor);
                    request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
                    return;
                }
            }

            // Tạo đối tượng Doctors với dữ liệu mới
            Doctors doctor = new Doctors();
            doctor.setUser_id(user.getUserId());
            doctor.setFull_name(fullName);
            doctor.setPhone(phone);
            doctor.setAddress(address);
            doctor.setDate_of_birth(dateOfBirth);
            doctor.setGender(gender);
            doctor.setSpecialty(specialty);
            doctor.setLicense_number(licenseNumber);
            doctor.setStatus(status);
            doctor.setAvatar(avatar);

            // Cập nhật thông tin bác sĩ
            boolean updated = DoctorDAO.updateDoctor(doctor);
            if (updated) {
                // Cập nhật lại session với thông tin mới
                Doctors updatedDoctor = DoctorDAO.getDoctorByUserId(user.getUserId());
                session.setAttribute("doctor", updatedDoctor);
                
                // Đặt thông báo thành công và chuyển hướng về lại trang cài đặt
                session.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                response.sendRedirect(request.getContextPath() + "/EditDoctorServlet");
                return;
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thông tin bác sĩ");
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("DEBUG POST: Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to edit the personal profile of a logged-in doctor.";
    }
} 