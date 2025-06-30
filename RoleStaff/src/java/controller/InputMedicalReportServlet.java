/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.MedicineDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Home
 */
public class InputMedicalReportServlet extends HttpServlet {

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
            out.println("<title>Servlet InputMedicalReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InputMedicalReportServlet at " + request.getContextPath() + "</h1>");
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
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();
        
        try {
            // Validate các tham số đầu vào
            String appointmentIdStr = request.getParameter("appointment_id");
            String doctorIdStr = request.getParameter("doctor_id");
            String patientIdStr = request.getParameter("patient_id");
            String diagnosis = request.getParameter("diagnosis");
            String treatmentPlan = request.getParameter("treatment_plan");
            String note = request.getParameter("note");
            String sign = request.getParameter("sign");

            if (appointmentIdStr == null || doctorIdStr == null || patientIdStr == null 
                || diagnosis == null || treatmentPlan == null) {
                throw new IllegalArgumentException("Thiếu thông tin bắt buộc");
            }

            int appointmentId = Integer.parseInt(appointmentIdStr);
            long doctorId = Long.parseLong(doctorIdStr);
            int patientId = Integer.parseInt(patientIdStr);

            // Validate mảng đơn thuốc
            String[] medicineIds = request.getParameterValues("medicine_id");
            String[] quantities = request.getParameterValues("quantity");
            String[] usages = request.getParameterValues("usage");

            if (medicineIds == null || quantities == null || usages == null 
                || medicineIds.length != quantities.length || medicineIds.length != usages.length) {
                throw new IllegalArgumentException("Thông tin đơn thuốc không hợp lệ");
            }

            MedicineDAO dao = new MedicineDAO();

            // Tạo báo cáo y tế
            int reportId = dao.insertMedicalReport(appointmentId, doctorId, patientId, 
                diagnosis, treatmentPlan, note, sign);

            // Cập nhật trạng thái cuộc hẹn
            dao.updateAppointmentStatus(appointmentId, "Đã khám");

            // Xử lý đơn thuốc
            for (int i = 0; i < medicineIds.length; i++) {
                int medId = Integer.parseInt(medicineIds[i]);
                int qty = Integer.parseInt(quantities[i]);
                String usage = usages[i];

                if (qty <= 0) {
                    throw new IllegalArgumentException("Số lượng thuốc phải lớn hơn 0");
                }

                // Kiểm tra tồn kho
                if (!dao.hasEnoughStock(medId, qty)) {
                    throw new IllegalStateException("Không đủ thuốc trong kho cho thuốc ID: " + medId);
                }

                // Thêm đơn thuốc và cập nhật kho
                dao.insertPrescription(reportId, medId, qty, usage);
                if (!dao.reduceMedicineStock(medId, qty)) {
                    throw new IllegalStateException("Không thể cập nhật số lượng thuốc trong kho");
                }
            }

            // Thành công
            session.setAttribute("message", "Tạo báo cáo y tế thành công!");
            response.sendRedirect("success.jsp");

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            response.sendRedirect("error.jsp");
        } catch (IllegalArgumentException e) {
            session.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            response.sendRedirect("error.jsp");
        } catch (IllegalStateException e) {
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect("error.jsp");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet xử lý nhập báo cáo y tế";
    }// </editor-fold>

}
