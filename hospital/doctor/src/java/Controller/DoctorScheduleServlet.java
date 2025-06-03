package Controller;

import Model.DoctorDB;
import Model.Doctors;
import Model.DoctorSchedule;
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
 * Servlet to manage and display the schedules of a logged-in doctor. Supports
 * viewing all schedules or filtering by a specific date.
 */
@WebServlet("/doctor-schedule")
public class DoctorScheduleServlet extends HttpServlet {

    private DoctorDB doctorScheduleDAO;

    /**
     * Initializes the servlet and creates a new instance of DoctorDB.
     */
    @Override
    public void init() throws ServletException {
        super.init();
        doctorScheduleDAO = new DoctorDB();
    }

    /**
     * Handles GET requests to display the doctor's schedules. Supports actions:
     * "list" (default) to show all schedules, and "byDate" to filter by date.
     *
     * @param request the HttpServletRequest object
     * @param response the HttpServletResponse object
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Determine the action (default to "list")
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
            // Handle database errors
            request.setAttribute("errorMessage", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    /**
     * Displays all schedules of the logged-in doctor.
     *
     * @param request the HttpServletRequest object
     * @param response the HttpServletResponse object
     * @throws SQLException if a database error occurs
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void showPersonalSchedule(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Retrieve the logged-in doctor from the session
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        int doctorId = doctor.getDoctorId();
        // Fetch all schedules for the logged-in doctor
        List<DoctorSchedule> schedules = doctorScheduleDAO.getSchedulesByDoctorId(doctorId);
        // Fetch all doctors (for display purposes, if needed)
        List<Doctors> doctors = doctorScheduleDAO.getAllDoctors();

        // Set attributes for the JSP
        request.setAttribute("schedules", schedules);
        request.setAttribute("doctors", doctors);
        request.setAttribute("selectedDoctorId", doctorId);
        request.setAttribute("pageTitle", "Lịch Làm Việc Của Bạn");

        // Forward to the JSP
        request.getRequestDispatcher("/doctor_trongtuan.jsp").forward(request, response);
    }

    /**
     * Displays schedules of the logged-in doctor for a specific date. Uses
     * getSchedulesByDoctorId and filters by date in Java.
     *
     * @param request the HttpServletRequest object
     * @param response the HttpServletResponse object
     * @throws SQLException if a database error occurs
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private void showSchedulesByDate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Retrieve the logged-in doctor from the session
        Doctors doctor = (Doctors) request.getSession().getAttribute("doctor");
        if (doctor == null) {
            request.setAttribute("errorMessage", "Bạn cần đăng nhập với vai trò bác sĩ");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        int doctorId = doctor.getDoctorId();
        String dateParam = request.getParameter("date");

        // Validate the date parameter
        // Validate the date parameter
        if (dateParam == null || dateParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng chọn ngày");
            showPersonalSchedule(request, response);
            return;
        }

        try {
            // Parse the date parameter (yyyy-MM-dd format)
            LocalDate localDate = LocalDate.parse(dateParam);
            // Convert LocalDate to java.sql.Date for comparison
            java.sql.Date sqlDate = java.sql.Date.valueOf(localDate);

            // Fetch all schedules for the doctor and filter by date in Java
            List<DoctorSchedule> allSchedules = doctorScheduleDAO.getSchedulesByDoctorId(doctorId);
            List<DoctorSchedule> schedules = allSchedules.stream()
                    .filter(schedule -> schedule.getWorkDate() != null && schedule.getWorkDate().equals(sqlDate))
                    .collect(Collectors.toList());

            // Fetch all doctors (for display purposes, if needed)
            List<Doctors> doctors = doctorScheduleDAO.getAllDoctors();

            // Set attributes for the JSP
            request.setAttribute("schedules", schedules);
            request.setAttribute("doctors", doctors);
            request.setAttribute("selectedDoctorId", doctorId);
            request.setAttribute("selectedDate", dateParam);
            request.setAttribute("pageTitle", "Lịch Làm Việc Ngày " + localDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));

            // Forward to the JSP
            request.getRequestDispatcher("/doctor_trongtuan.jsp").forward(request, response);
        } catch (DateTimeParseException e) {
            // Handle invalid date format
            request.setAttribute("errorMessage", "Ngày không hợp lệ. Vui lòng sử dụng định dạng yyyy-MM-dd");
            showPersonalSchedule(request, response);
        }
    }

    /**
     * Provides a short description of the servlet.
     *
     * @return a String containing the servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet to manage and display schedules for a logged-in doctor.";
    }
}
