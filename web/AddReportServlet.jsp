/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.MedicineDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author HOME
 */
@WebServlet(name = "AddReportServlet", urlPatterns = {"/AddReportServlet"})
public class AddReportServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddReportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
            long doctorId = Long.parseLong(request.getParameter("doctor_id"));
            int patientId = Integer.parseInt(request.getParameter("patient_id"));
            String diagnosis = request.getParameter("diagnosis");
            String treatmentPlan = request.getParameter("treatment_plan");
            String note = request.getParameter("note");
            String sign = request.getParameter("sign");

            // M?ng ??n thu?c
            String[] medicineIds = request.getParameterValues("medicine_id");
            String[] quantities = request.getParameterValues("quantity");
            String[] usages = request.getParameterValues("usage");
            System.out.println("appointment_id = " + appointmentId);
            System.out.println("patient_id = " + patientId);
            System.out.println("doctor_id = " + doctorId);
            System.out.println("diagnosis = " + diagnosis);
            System.out.println("treatment = " + treatmentPlan);

            MedicineDAO dao = new MedicineDAO();

            // T?o báo cáo y t?
            System.out.println("Doctor ID: " + doctorId);

            int reportId = dao.insertMedicalReport(appointmentId, doctorId, patientId, diagnosis, treatmentPlan, note, sign);
            if (reportId != -1) {
                dao.updateAppointmentStatus(appointmentId, "?ã khám");
            } else {
                response.getWriter().println("Không th? t?o báo cáo y t?.");
                return;
            }
            for (int i = 0; i < medicineIds.length; i++) {
                int medId = Integer.parseInt(medicineIds[i]);
                int qty = Integer.parseInt(quantities[i]);
                String usage = usages[i];

                // Ki?m tra t?n kho
                if (dao.hasEnoughStock(medId, qty)) {
                    dao.insertPrescription(reportId, medId, qty, usage);
                    dao.reduceMedicineStock(medId, qty); // Tr? kho
                } else {
                    response.getWriter().println("Không ?? thu?c trong kho cho thu?c ID: " + medId);
                    return; // D?ng n?u thi?u thu?c
                }
            }

            response.sendRedirect("success.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("L?i: " + e.getMessage());

        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
