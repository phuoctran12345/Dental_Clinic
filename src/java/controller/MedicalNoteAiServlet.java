package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.GeminiAiService;
import dao.MedicineDAO;
import model.Medicine;

/**
 * Servlet để cải thiện ghi chú y tế bằng AI
 * @author tranhongphuoc
 */
@WebServlet("/MedicalNoteAiServlet")
public class MedicalNoteAiServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain;charset=UTF-8");
        
        try {
            // Lấy thông tin từ form
            String diagnosis = request.getParameter("diagnosis");
            String treatmentPlan = request.getParameter("treatment_plan");
            String currentNote = request.getParameter("current_note");
            String patientId = request.getParameter("patient_id");
            String appointmentId = request.getParameter("appointment_id");
            
            // Lấy thông tin thuốc
            String[] medicineIds = request.getParameterValues("medicine_id");
            String[] quantities = request.getParameterValues("quantity");
            String[] usages = request.getParameterValues("usage");
            String numMedicines = request.getParameter("num_medicines");
            
            System.out.println("Medical Note AI Request - Diagnosis: " + diagnosis);
            System.out.println("Treatment Plan: " + treatmentPlan);
            System.out.println("Current Note: " + currentNote);
            System.out.println("Number of medicines: " + numMedicines);
            
            // Debug dữ liệu medicine chi tiết
            if (medicineIds != null) {
                System.out.println("Received " + medicineIds.length + " medicine IDs:");
                for (int i = 0; i < medicineIds.length; i++) {
                    System.out.println("  Medicine " + i + ": ID = " + medicineIds[i]);
                }
            } else {
                System.out.println("No medicine IDs received");
            }
            
            if (quantities != null) {
                System.out.println("Received " + quantities.length + " quantities:");
                for (int i = 0; i < quantities.length; i++) {
                    System.out.println("  Quantity " + i + ": " + quantities[i]);
                }
            } else {
                System.out.println("No quantities received");
            }
            
            if (usages != null) {
                System.out.println("Received " + usages.length + " usages:");
                for (int i = 0; i < usages.length; i++) {
                    System.out.println("  Usage " + i + ": " + usages[i]);
                }
            } else {
                System.out.println("No usages received");
            }
            
            // Tạo prompt chuyên biệt cho ghi chú y tế
            String medicalPrompt = createComprehensiveMedicalNotePrompt(
                diagnosis, treatmentPlan, currentNote, patientId, appointmentId,
                medicineIds, quantities, usages, numMedicines
            );
            
            // Gọi AI Service để lấy ghi chú được cải thiện
            String aiResponse = GeminiAiService.getMedicalNoteResponse(medicalPrompt);
            
            System.out.println("AI Medical Note Response: " + aiResponse);
            
            response.getWriter().write(aiResponse);
            
        } catch (Exception e) {
            System.out.println("Error in MedicalNoteAiServlet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("Xin lỗi, đã có lỗi xảy ra khi tạo ghi chú. Vui lòng thử lại sau.");
        }
    }
    
    /**
     * Tạo prompt chuyên biệt và chi tiết cho việc cải thiện ghi chú y tế
     */
    private String createComprehensiveMedicalNotePrompt(String diagnosis, String treatmentPlan, 
            String currentNote, String patientId, String appointmentId,
            String[] medicineIds, String[] quantities, String[] usages, String numMedicines) {
        
        StringBuilder prompt = new StringBuilder();
        
        prompt.append("Bạn là bác sĩ nha khoa chuyên nghiệp với nhiều năm kinh nghiệm. ");
        prompt.append("Hãy viết một ghi chú nha khoa chuyên nghiệp, chi tiết và hữu ích cho bệnh nhân ");
        prompt.append("dựa trên thông tin khám bệnh sau đây:\n\n");
        
        prompt.append("THÔNG TIN KHÁM BỆNH:\n");
        
        if (diagnosis != null && !diagnosis.trim().isEmpty()) {
            prompt.append("• Chẩn đoán: ").append(diagnosis.trim()).append("\n");
        } else {
            prompt.append("• Chẩn đoán: (chưa ghi rõ)\n");
        }
        
        if (treatmentPlan != null && !treatmentPlan.trim().isEmpty()) {
            prompt.append("• Kế hoạch điều trị: ").append(treatmentPlan.trim()).append("\n");
        } else {
            prompt.append("• Kế hoạch điều trị: (chưa ghi rõ)\n");
        }
        
        // Lấy thông tin chi tiết thuốc từ database
        if (numMedicines != null && !numMedicines.equals("0") && medicineIds != null && medicineIds.length > 0) {
            prompt.append("• Đơn thuốc đã kê:\n");
            for (int i = 0; i < medicineIds.length; i++) {
                if (medicineIds[i] != null && !medicineIds[i].trim().isEmpty()) {
                    try {
                        int medicineId = Integer.parseInt(medicineIds[i]);
                        Medicine medicine = MedicineDAO.getMedicineById(medicineId);
                        
                        if (medicine != null) {
                            prompt.append("  - Thuốc: ").append(medicine.getName());
                            prompt.append(" (").append(medicine.getDescription()).append(")");
                            
                            if (i < quantities.length && quantities[i] != null && !quantities[i].trim().isEmpty()) {
                                prompt.append(" - Số lượng: ").append(quantities[i]).append(" ").append(medicine.getUnit());
                            }
                            
                            if (usages != null && i < usages.length && usages[i] != null && !usages[i].trim().isEmpty()) {
                                prompt.append(" - Cách dùng: ").append(usages[i]);
                            }
                            prompt.append("\n");
                        } else {
                            prompt.append("  - Thuốc ID: ").append(medicineIds[i]).append(" (không tìm thấy thông tin)\n");
                        }
                    } catch (NumberFormatException e) {
                        prompt.append("  - Thuốc: ").append(medicineIds[i]).append(" (ID không hợp lệ)\n");
                    }
                }
            }
        } else {
            prompt.append("• Đơn thuốc: (không kê thuốc)\n");
        }
        
        if (currentNote != null && !currentNote.trim().isEmpty()) {
            prompt.append("• Ghi chú hiện tại: ").append(currentNote.trim()).append("\n");
        }
        
        prompt.append("\nYÊU CẦU VIẾT GHI CHÚ NHA KHOA:\n");
        prompt.append("Hãy tạo một ghi chú nha khoa chuyên nghiệp với:\n\n");
        
        prompt.append("1. **Tình trạng răng miệng**: Dựa vào chẩn đoán thực tế đã ghi\n");
        prompt.append("2. **Điều trị đã thực hiện**: Dựa vào kế hoạch điều trị thực tế\n");
        prompt.append("3. **Hướng dẫn chăm sóc**: Lời khuyên cụ thể về vệ sinh răng miệng\n");
        prompt.append("4. **Thuốc và cách dùng**: Nhắc nhở về việc tuân thủ đơn thuốc đã kê (tên thuốc thật)\n");
        prompt.append("5. **Theo dõi và tái khám**: Hướng dẫn về việc theo dõi và lịch tái khám\n");
        prompt.append("6. **Lưu ý quan trọng**: Các dấu hiệu cần lưu ý và khi nào cần liên hệ\n\n");
        
        prompt.append("PHONG CÁCH VIẾT:\n");
        prompt.append("• Bắt đầu bằng 'Ghi chú nha khoa'\n");
        prompt.append("• Văn phong bác sĩ chuyên nghiệp, thân thiện\n");
        prompt.append("• SỬ DỤNG ĐÚNG thông tin từ form (không bịa thêm)\n");
        prompt.append("• Ngôn ngữ dễ hiểu, tránh thuật ngữ phức tạp\n");
        prompt.append("• Độ dài: 120-180 từ\n");
        prompt.append("• Cấu trúc rõ ràng, logic\n");
        prompt.append("• Kết thúc bằng lời chúc sức khỏe\n\n");
        
        prompt.append("QUAN TRỌNG: Chỉ sử dụng thông tin có thật từ form, không được tự thêm thông tin.\n\n");
        
        prompt.append("Hãy viết ghi chú nha khoa chuyên nghiệp:");
        
        return prompt.toString();
    }
} 