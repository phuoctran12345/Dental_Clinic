package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
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
import model.Staff;
import model.Doctors;

@WebServlet("/DeleteStaffServlet")
public class DeleteStaffServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DeleteStaffServlet.class.getName());
    private StaffDAO staffDAO;
    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        staffDAO = new StaffDAO();
        doctorDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"MANAGER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String type = request.getParameter("type");
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty() || type == null || type.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin để xóa!");
        } else {
            try {
                int id = Integer.parseInt(idParam);
                boolean deleted = false;
                if ("staff".equalsIgnoreCase(type)) {
                    deleted = staffDAO.delete(id);
                    request.setAttribute("successMessage", deleted ? "Xóa nhân viên thành công!" : "Không tìm thấy nhân viên để xóa!");
                } else if ("doctor".equalsIgnoreCase(type)) {
                    deleted = doctorDAO.delete(id);
                    request.setAttribute("successMessage", deleted ? "Xóa bác sĩ thành công!" : "Không tìm thấy bác sĩ để xóa!");
                } else {
                    request.setAttribute("errorMessage", "Loại tài khoản không hợp lệ!");
                }
                if (!deleted && ("staff".equalsIgnoreCase(type) || "doctor".equalsIgnoreCase(type))) {
                    request.setAttribute("errorMessage", "Không tìm thấy tài khoản để xóa!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Mã tài khoản không hợp lệ!");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "SQL error when deleting " + type, e);
                request.setAttribute("errorMessage", "Lỗi khi xóa tài khoản: " + e.getMessage());
            }
        }

        // Lấy lại danh sách nhân viên và bác sĩ để hiển thị
        try {
            List<Staff> staffList = staffDAO.getAllStaff();
            List<Doctors> doctorList = doctorDAO.getAllDoctors();
            request.setAttribute("staffList", staffList);
            request.setAttribute("doctorList", doctorList);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error when loading staff/doctor list", e);
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách: " + e.getMessage());
        }

        // Forward về trang danh sách
        request.getRequestDispatcher("/jsp/manager/manager_danhsach.jsp").forward(request, response);
    }
}