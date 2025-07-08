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

        String staffIdParam = request.getParameter("staffId");
        if (staffIdParam == null || staffIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu mã nhân viên để xóa!");
        } else {
            try {
                int staffId = Integer.parseInt(staffIdParam);
                boolean deleted = staffDAO.deleteStaffById(staffId);
                if (deleted) {
                    request.setAttribute("successMessage", "Xóa nhân viên thành công!");
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy nhân viên để xóa!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Mã nhân viên không hợp lệ!");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "SQL error when deleting staff", e);
                request.setAttribute("errorMessage", "Lỗi khi xóa nhân viên: " + e.getMessage());
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