package controller;

import dao.DoctorDAO;
import model.Doctors;
import model.DoctorSchedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet để quản lý và hiển thị lịch hẹn của bác sĩ đã đăng nhập.
 */

public class DoctorHaveAppointmentServlet extends HttpServlet {

    private DoctorDAO doctorScheduleDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        doctorScheduleDAO = new DoctorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    showPersonalSchedule(request, response);
                    break;
                case "byDate":
                    showSchedulesByDate(request, response);
                    break;
                default:
                    showPersonalSchedule(request, response);
                    break;
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Hiển thị toàn bộ lịch làm việc của bác sĩ đang đăng nhập.
     */
    private void showPersonalSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        System.out.println("DEBUG: doctor in session = " + doctor);
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        int doctorId = (int) doctor.getDoctorId();
        List<DoctorSchedule> schedules = doctorScheduleDAO.getSchedulesByDoctorId(doctorId);
        List<Doctors> doctors = doctorScheduleDAO.getAllDoctors();

        request.setAttribute("schedules", schedules);
        request.setAttribute("doctors", doctors);
        request.setAttribute("selectedDoctorId", doctorId);
        request.setAttribute("pageTitle", "Lịch Làm Việc Của Bạn");

        request.getRequestDispatcher("/jsp/doctor/doctor_trongtuan.jsp").forward(request, response);
    }

    /**
     * Hiển thị lịch làm việc theo ngày cụ thể.
     */
    private void showSchedulesByDate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        // ✅ Đảm bảo sử dụng đúng key "doctor"
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        int doctorId = (int) doctor.getDoctorId();
        String dateParam = request.getParameter("date");

        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ngày");
            showPersonalSchedule(request, response);
            return;
        }

        try {
            LocalDate localDate = LocalDate.parse(dateParam);
            java.sql.Date sqlDate = java.sql.Date.valueOf(localDate);

            List<DoctorSchedule> allSchedules = doctorScheduleDAO.getSchedulesByDoctorId(doctorId);
            List<DoctorSchedule> schedules = allSchedules.stream()
                    .filter(schedule -> schedule.getWorkDate() != null && schedule.getWorkDate().equals(sqlDate))
                    .collect(Collectors.toList());

            List<Doctors> doctors = doctorScheduleDAO.getAllDoctors();

            request.setAttribute("schedules", schedules);
            request.setAttribute("doctors", doctors);
            request.setAttribute("selectedDoctorId", doctorId);
            request.setAttribute("selectedDate", dateParam);
            request.setAttribute("pageTitle", "Lịch Làm Việc Ngày " +
                    localDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

            request.getRequestDispatcher("/jsp/doctor/doctor_trongtuan.jsp").forward(request, response);
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMessage", "Ngày không hợp lệ. Vui lòng sử dụng định dạng yyyy-MM-dd");
            showPersonalSchedule(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị lịch làm việc cho bác sĩ đã đăng nhập.";
    }
}
