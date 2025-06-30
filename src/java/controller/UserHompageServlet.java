package controller;

import dao.AppointmentDAO;
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

// @WebServlet annotation removed - using web.xml mapping instead
public class UserHompageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("patient") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

         Patients patient = (Patients) session.getAttribute("patient");
        List<Appointment> upcomingAppointments = AppointmentDAO.getUpcomingAppointmentsByPatientId(patient.getPatientId());
        request.setAttribute("upcomingAppointments", upcomingAppointments);
        
   
 
        int totalVisits = PatientDAO.getTotalVisitsByPatientId(patient.getPatientId());
        request.setAttribute("totalVisits", totalVisits);
      
        // Chuyển hướng đến trang chủ của user
        request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}