package controller;

import com.google.gson.Gson;
import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.TimeSlot;

@WebServlet(name = "GetAvailableSlotsServlet", urlPatterns = {"/GetAvailableSlotsServlet"})
public class GetAvailableSlotsServlet extends HttpServlet {
    
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String date = request.getParameter("date");
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            
            List<TimeSlot> availableSlots = AppointmentDAO.getAvailableSlots(doctorId, date, appointmentId);
            
            String json = gson.toJson(availableSlots);
            response.getWriter().write(json);
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
