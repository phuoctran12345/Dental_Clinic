package controller;

import dao.DoctorDAO;
import dao.PatientDAO;
import dao.MedicineDAO;
import dao.AppointmentDAO;
import model.Doctors;
import model.Patients;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet xử lý tạo báo cáo y tế
 * @author ASUS
 */

public class MedicalReportServlet extends HttpServlet {

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
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MedicalReportServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MedicalReportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Kiểm tra và validate các parameter trước khi parse
            String appointmentIdStr = request.getParameter("appointment_id");
            String doctorIdStr = request.getParameter("doctor_id");
            String patientIdStr = request.getParameter("patient_id");
            String diagnosis = request.getParameter("diagnosis");
            String treatmentPlan = request.getParameter("treatment_plan");
            String note = request.getParameter("note");
            String sign = request.getParameter("sign");

            // Debug logging
            System.out.println("DEBUG - MedicalReportServlet doPost:");
            System.out.println("  - appointment_id: '" + appointmentIdStr + "'");
            System.out.println("  - doctor_id: '" + doctorIdStr + "'");
            System.out.println("  - patient_id: '" + patientIdStr + "'");
            System.out.println("  - diagnosis: '" + diagnosis + "'");

            // Validate required parameters
            if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
                response.getWriter().println("Lỗi: Thiếu ID cuộc hẹn.");
                return;
            }
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                response.getWriter().println("Lỗi: Thiếu ID bác sĩ.");
                return;
            }
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                response.getWriter().println("Lỗi: Thiếu ID bệnh nhân.");
                return;
            }
            if (diagnosis == null || diagnosis.trim().isEmpty()) {
                response.getWriter().println("Lỗi: Thiếu chẩn đoán.");
                return;
            }

            // Parse các ID sau khi đã validate
            int appointmentId = Integer.parseInt(appointmentIdStr.trim());
            long doctorId = Long.parseLong(doctorIdStr.trim());
            int patientId = Integer.parseInt(patientIdStr.trim());

            System.out.println("DEBUG - Parsed values:");
            System.out.println("  - appointmentId: " + appointmentId);
            System.out.println("  - doctorId: " + doctorId);
            System.out.println("  - patientId: " + patientId);

            // Mảng đơn thuốc
            String[] medicineIds = request.getParameterValues("medicine_id");
            String[] quantities = request.getParameterValues("quantity");
            String[] usages = request.getParameterValues("usage");

            // Kiểm tra patient có tồn tại không
            Patients patient = PatientDAO.getPatientById(patientId);
            if (patient == null) {
                response.getWriter().println("Lỗi: Không tìm thấy bệnh nhân với ID: " + patientId);
                return;
            }
            
            // Kiểm tra doctor có tồn tại không
            Doctors doctor = DoctorDAO.getDoctorById((int) doctorId);
            if (doctor == null) {
                response.getWriter().println("Lỗi: Không tìm thấy bác sĩ với ID: " + doctorId);
                return;
            }

            // Tạo báo cáo y tế
            int reportId = DoctorDAO.insertMedicalReport(appointmentId, doctorId, patientId, diagnosis, treatmentPlan, note, sign);
            if (reportId != -1) {
                AppointmentDAO.updateAppointmentStatusStatic(appointmentId, "completed");
            } else {
                response.getWriter().println("Không thể tạo báo cáo y tế.");
                return;
            }

            // Xử lý đơn thuốc nếu có
            if (medicineIds != null && medicineIds.length > 0) {
                for (int i = 0; i < medicineIds.length; i++) {
                    // Kiểm tra từng medicine item có rỗng không
                    if (medicineIds[i] == null || medicineIds[i].trim().isEmpty() ||
                        quantities[i] == null || quantities[i].trim().isEmpty()) {
                        continue; // Bỏ qua item rỗng
                    }

                    try {
                        int medId = Integer.parseInt(medicineIds[i].trim());
                        int qty = Integer.parseInt(quantities[i].trim());
                        String usage = usages[i] != null ? usages[i].trim() : "";

                        // Kiểm tra tồn kho
                        MedicineDAO medicineDAO = new MedicineDAO();
                        if (medicineDAO.hasEnoughStock(medId, qty)) {
                            DoctorDAO.insertPrescription(reportId, medId, qty, usage);
                            medicineDAO.reduceMedicineStock(medId, qty); // Trừ kho
                        } else {
                            response.getWriter().println("Không đủ thuốc trong kho cho thuốc ID: " + medId);
                            return; // Dừng nếu thiếu thuốc
                        }
                    } catch (NumberFormatException e) {
                        response.getWriter().println("Lỗi: Dữ liệu thuốc không hợp lệ ở vị trí " + (i + 1));
                        return;
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/jsp/doctor/success.jsp");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi: Dữ liệu nhập vào không hợp lệ. Vui lòng kiểm tra lại các trường số.");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý tạo báo cáo y tế";
    }
} 