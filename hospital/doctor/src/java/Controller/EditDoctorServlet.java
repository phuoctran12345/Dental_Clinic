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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.sql.Date;

@WebServlet("/doctor_caidat")
public class EditDoctorServlet extends HttpServlet {
    private DoctorDB doctorDB;

    @Override
    public void init() throws ServletException {
        super.init();
        doctorDB = new DoctorDB();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin bác sĩ từ session
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/jsp/doctor/login.jsp").forward(request, response);
            return;
        }

        try {
            // Luôn lấy thông tin chi tiết bác sĩ mới nhất từ database
            int userId = doctor.getUserId();
            Doctors doctorInfo = doctorDB.getInforDoctor(userId);
            if (doctorInfo == null) {
                request.setAttribute("errorMessage", "Không tìm thấy thông tin bác sĩ");
                request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
                return;
            }

            // Debug logging
            System.out.println("DEBUG doGet - Gender from DB: '" + doctorInfo.getGender() + "'");
            System.out.println("DEBUG doGet - Status from DB: '" + doctorInfo.getStatus() + "'");

            // Cập nhật lại session với thông tin mới nhất từ database
            request.getSession().setAttribute("doctor", doctorInfo);
            
            // Đặt thông tin bác sĩ vào request để hiển thị trên form
            request.setAttribute("doctor", doctorInfo);
            request.setAttribute("pageTitle", "Chỉnh sửa thông tin bác sĩ");
            request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/error_page.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin bác sĩ từ session để đảm bảo chỉ bác sĩ đang đăng nhập chỉnh sửa được thông tin của mình
        Doctors sessionDoctor = (Doctors) request.getSession().getAttribute("doctor");
        if (sessionDoctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/jsp/doctor/login.jsp").forward(request, response);
            return;
        }

        try {
            // Lấy dữ liệu từ form
            int userId = sessionDoctor.getUserId();
            String fullName = request.getParameter("full_name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String dateOfBirthStr = request.getParameter("date_of_birth");
            String gender = request.getParameter("gender");
            String specialty = request.getParameter("specialty");
            String licenseNumber = request.getParameter("license_number");
            // Không cho phép bác sĩ tự thay đổi status - giữ nguyên status hiện tại
            String status = sessionDoctor.getStatus(); // Lấy từ session thay vì form
            String avatar = request.getParameter("avatar");

            // Debug logging
            System.out.println("DEBUG doPost - Gender from form: '" + gender + "'");
            System.out.println("DEBUG doPost - Status kept from session: '" + status + "'");

            // Chuyển đổi date_of_birth từ String sang java.sql.Date
            Date dateOfBirth = null;
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date parsedDate = sdf.parse(dateOfBirthStr);
                    dateOfBirth = new Date(parsedDate.getTime());
                } catch (ParseException e) {
                    request.setAttribute("errorMessage", "Định dạng ngày sinh không hợp lệ");
                    request.setAttribute("doctor", doctorDB.getInforDoctor(userId));
                    request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
                    return;
                }
            }

            // Tạo đối tượng Doctors với dữ liệu mới
            Doctors doctor = new Doctors();
            doctor.setUserId(userId);
            doctor.setFullName(fullName);
            doctor.setPhone(phone);
            doctor.setAddress(address);
            doctor.setDateOfBirth(dateOfBirth);
            doctor.setGender(gender);
            doctor.setSpecialty(specialty);
            doctor.setLicenseNumber(licenseNumber);
            doctor.setStatus(status);
            doctor.setAvatar(avatar);

            // Cập nhật thông tin bác sĩ
            boolean updated = doctorDB.updateDoctor(doctor);
            if (updated) {
                // Cập nhật lại session với thông tin mới
                Doctors updatedDoctor = doctorDB.getInforDoctor(userId);
                request.getSession().setAttribute("doctor", updatedDoctor);
                
                // Đặt thông báo thành công và chuyển hướng về lại trang cài đặt
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin thành công!");
                response.sendRedirect("/doctor/doctor_caidat"); // Chuyển về lại trang cài đặt
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật thông tin bác sĩ");
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/jsp/doctor/doctor_caidat.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to edit the personal profile of a logged-in doctor.";
    }
}