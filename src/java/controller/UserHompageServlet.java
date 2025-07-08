package controller;

import dao.AppointmentDAO;
import dao.BlogDAO;
import dao.PatientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Patients;
import java.util.List;
import model.Appointment;
import model.BlogPost;

// @WebServlet annotation removed - using web.xml mapping instead
public class UserHompageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa có session → về trang login
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ✅ Có session nhưng patient null → về trang user_taikhoan
        Patients patient = (Patients) session.getAttribute("patient");
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/UserAccountServlet");
            return;
        }

        // ✅ Nếu có patient, xử lý bình thường
        List<Appointment> upcomingAppointments = AppointmentDAO.getUpcomingAppointmentsByPatientId(patient.getPatientId());
        request.setAttribute("upcomingAppointments", upcomingAppointments);

        int totalVisits = PatientDAO.getTotalVisitsByPatientId(patient.getPatientId());
        request.setAttribute("totalVisits", totalVisits);

        System.out.println("Patient ID: " + patient.getPatientId());
        System.out.println("Total visits: " + totalVisits);
        BlogDAO BlogDAO = new BlogDAO();

        List<BlogPost> latestBlogs = BlogDAO.getLatest(2); // hoặc tất cả nếu cần
        request.setAttribute("latestBlogs", latestBlogs);

        // Chuyển đến user_homepage.jsp
        request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
