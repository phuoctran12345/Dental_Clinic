package controller;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.StaffDAO;
import dao.DoctorDAO;
import java.io.IOException;
import model.Staff;
import model.Doctors;

@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AddStaffServlet.class.getName());
    private StaffDAO staffDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"MANAGER".equals(role)) {
            LOGGER.warning("Unauthorized access attempt by role: " + role);
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleParam = request.getParameter("role");
        String position = request.getParameter("position");
        String staffPosition = request.getParameter("staffPosition"); // Thêm trường mới
        String employmentType = request.getParameter("employmentType");

        LOGGER.info("Received POST request with parameters: fullName=" + fullName + ", email=" + email + 
                   ", phone=" + phone + ", role=" + roleParam + ", position=" + position + 
                   ", staffPosition=" + staffPosition + ", employmentType=" + employmentType);

        // Kiểm tra tham số
        if (fullName == null || fullName.trim().isEmpty() || 
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() || 
            roleParam == null || roleParam.trim().isEmpty() ||
            ("DOCTOR".equalsIgnoreCase(roleParam) && (position == null || position.trim().isEmpty())) ||
            ("STAFF".equalsIgnoreCase(roleParam) && (employmentType == null || employmentType.trim().isEmpty())) ||
            ("STAFF".equalsIgnoreCase(roleParam) && (staffPosition == null || staffPosition.trim().isEmpty()))) {
            LOGGER.severe("Missing or empty required parameters: fullName=" + fullName + ", email=" + email + 
                         ", phone=" + phone + ", role=" + roleParam + ", position=" + position + 
                         ", staffPosition=" + staffPosition + ", employmentType=" + employmentType);
            request.setAttribute("error", "invalid_input");
            request.setAttribute("errorMessage", "Thiếu hoặc thông tin rỗng!");
            request.getRequestDispatcher("/jsp/manager/manager_danhsach.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng email
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            LOGGER.severe("Invalid email format: " + email);
            request.setAttribute("error", "invalid_input");
            request.setAttribute("errorMessage", "Định dạng email không hợp lệ!");
            request.getRequestDispatcher("/jsp/manager/manager_danhsach.jsp").forward(request, response);
            return;
        }

        // Kiểm tra định dạng số điện thoại
        if (!phone.matches("\\d{10}")) {
            LOGGER.severe("Invalid phone number format: " + phone);
            request.setAttribute("error", "invalid_input");
            request.setAttribute("errorMessage", "Số điện thoại phải có 10 chữ số!");
            request.getRequestDispatcher("/jsp/manager/manager_danhsach.jsp").forward(request, response);
            return;
        }

        String defaultPassword = "12345"; // Nên mã hóa trong thực tế
        try {
            if ("STAFF".equalsIgnoreCase(roleParam)) {
                Staff staff = new Staff();
                staff.setFullName(fullName);
                staff.setPhone(phone);
                staff.setPosition(staffPosition); // Sử dụng staffPosition thay vì position
                staff.setEmploymentType(employmentType != null && !employmentType.isEmpty() ? employmentType : "fulltime");
                staff.setUserEmail(email);
                staffDAO.addStaff(staff, defaultPassword);
                LOGGER.info("Added new staff with email: " + email);
            } else if ("DOCTOR".equalsIgnoreCase(roleParam)) {
                Doctors doctor = new Doctors();
                doctor.setFull_name(fullName);
                doctor.setPhone(phone);
                doctor.setSpecialty(position);
                doctor.setUserEmail(email);
                doctorDAO.addDoctor(doctor, defaultPassword);
                LOGGER.info("Added new doctor with email: " + email);
            }
            request.setAttribute("success", "true");
            request.setAttribute("successMessage", "Thêm nhân viên thành công!");
            response.sendRedirect("jsp/manager/success.jsp");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error occurred: ", e);
            request.setAttribute("error", "staff_creation_failed");
            request.setAttribute("errorMessage", "Lỗi khi tạo nhân viên: " + e.getMessage());
            request.getRequestDispatcher("/jsp/manager/success.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error occurred: ", e);
            request.setAttribute("error", "unexpected_error");
            request.setAttribute("errorMessage", "Lỗi không mong muốn: " + e.getMessage() + "\nStack Trace: " + getStackTrace(e));
            request.getRequestDispatcher("/jsp/manager/success.jsp").forward(request, response);
        }
    }

    private String getStackTrace(Exception e) {
        StringBuilder sb = new StringBuilder();
        for (StackTraceElement element : e.getStackTrace()) {
            sb.append(element.toString()).append("\n");
        }
        return sb.toString();
    }
}