package controller;

import dao.PatientDAO;
import jakarta.servlet.RequestDispatcher;
import model.Patients;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class StaffViewPatientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String gender = request.getParameter("gender");
        PatientDAO patientDAO = new PatientDAO();
        List<Patients> patients;
        if (keyword != null && !keyword.isEmpty()) {
            patients = patientDAO.searchPatients(keyword);
        } else if (gender != null && !gender.isEmpty()) {
            patients = patientDAO.filterPatientsByGender(gender);
        } else {
            patients = patientDAO.getAllPatients();
        }
        request.setAttribute("patients", patients);
        request.setAttribute("keyword", keyword);
        request.setAttribute("gender", gender);
        RequestDispatcher rd = request.getRequestDispatcher("staff_view_patient.jsp");
        rd.forward(request, response);
    }
}