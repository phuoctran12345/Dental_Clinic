package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.N8nWebhookService;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/*
  @author: Trần Hồng Phước
  @version: 1.0
  @since: 2025-07-10
  @description: Servlet để test Google Calendar N8N Webhook và reset cache anti-spam
 */

@WebServlet("/calendar-test")
public class CalendarTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("reset".equals(action)) {
            handleResetCache(request, response);
        } else if ("test".equals(action)) {
            handleTestCalendar(request, response);
        } else {
            // Forward to test page
            request.getRequestDispatcher("/test_google_calendar.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("testCalendar".equals(action)) {
            handleTestCalendar(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * Reset cache anti-spam cho testing
     */
    private void handleResetCache(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Reset cả email và calendar cache
            N8nWebhookService.resetAntiSpamCache();
            
            int emailCount = N8nWebhookService.getSentEmailCount();
            int calendarCount = N8nWebhookService.getCreatedEventCount();
            
            System.out.println("🔄 CACHE RESET BY USER REQUEST");
            System.out.println("📧 Emails in cache: " + emailCount);
            System.out.println("📅 Calendar events in cache: " + calendarCount);
            
            out.println("{");
            out.println("  \"success\": true,");
            out.println("  \"message\": \"Cache anti-spam đã được reset\",");
            out.println("  \"emailCount\": " + emailCount + ",");
            out.println("  \"calendarCount\": " + calendarCount + ",");
            out.println("  \"timestamp\": \"" + java.time.LocalDateTime.now().toString() + "\"");
            out.println("}");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi reset cache: " + e.getMessage());
            e.printStackTrace();
            
            out.println("{");
            out.println("  \"success\": false,");
            out.println("  \"message\": \"Lỗi reset cache: " + e.getMessage() + "\"");
            out.println("}");
        }
    }
    
    /**
     * Test gửi calendar webhook
     */
    private void handleTestCalendar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy thông tin từ form hoặc dùng default
            String userEmail = request.getParameter("userEmail");
            String userName = request.getParameter("userName");
            String userPhone = request.getParameter("userPhone");
            String doctorEmail = request.getParameter("doctorEmail");
            String doctorName = request.getParameter("doctorName");
            String serviceName = request.getParameter("serviceName");
            String appointmentDate = request.getParameter("appointmentDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");
            String location = request.getParameter("location");
            String billId = request.getParameter("billId");
            String reason = request.getParameter("reason");
            
            // Sử dụng default values nếu không có input
            if (userEmail == null || userEmail.isEmpty()) {
                userEmail = "de180577tranhongphuoc@gmail.com";
            }
            if (userName == null || userName.isEmpty()) {
                userName = "Test User";
            }
            if (userPhone == null || userPhone.isEmpty()) {
                userPhone = "0901234567";
            }
            if (doctorEmail == null || doctorEmail.isEmpty()) {
                doctorEmail = "choheo.soss@gmail.com";
            }
            if (doctorName == null || doctorName.isEmpty()) {
                doctorName = "BS. Test Doctor";
            }
            if (serviceName == null || serviceName.isEmpty()) {
                serviceName = "Test Calendar Service";
            }
            if (appointmentDate == null || appointmentDate.isEmpty()) {
                appointmentDate = LocalDate.now().plusDays(1).format(DateTimeFormatter.ISO_LOCAL_DATE);
            }
            if (startTime == null || startTime.isEmpty()) {
                startTime = "09:00";
            }
            if (endTime == null || endTime.isEmpty()) {
                endTime = "09:30";
            }
            if (location == null || location.isEmpty()) {
                location = "FPT University Đà Nẵng";
            }
            if (billId == null || billId.isEmpty()) {
                billId = "TEST_CAL_" + System.currentTimeMillis();
            }
            if (reason == null || reason.isEmpty()) {
                reason = "Test calendar webhook functionality";
            }
            
            // Tạo appointmentTime
            String appointmentTime = startTime + " - " + endTime;
            
            System.out.println("🧪 === TEST GOOGLE CALENDAR WEBHOOK ===");
            System.out.println("📧 User: " + userName + " (" + userEmail + ")");
            System.out.println("👨‍⚕️ Doctor: " + doctorName + " (" + doctorEmail + ")");
            System.out.println("📅 Date: " + appointmentDate);
            System.out.println("⏰ Time: " + appointmentTime);
            System.out.println("🏥 Service: " + serviceName);
            System.out.println("📍 Location: " + location);
            System.out.println("💼 Bill ID: " + billId);
            
            // Gửi calendar webhook
            N8nWebhookService.createGoogleCalendarEvent(
                userEmail,
                userName,
                userPhone,
                doctorEmail,
                doctorName,
                appointmentDate,
                appointmentTime,
                serviceName,
                billId,
                "Phòng khám Nha khoa DentalClinic",
                location,
                reason
            );
            
            System.out.println("✅ TEST CALENDAR WEBHOOK SENT SUCCESSFULLY");
            
            out.println("{");
            out.println("  \"success\": true,");
            out.println("  \"message\": \"Test calendar webhook đã gửi thành công\",");
            out.println("  \"data\": {");
            out.println("    \"userEmail\": \"" + userEmail + "\",");
            out.println("    \"doctorEmail\": \"" + doctorEmail + "\",");
            out.println("    \"userName\": \"" + userName + "\",");
            out.println("    \"doctorName\": \"" + doctorName + "\",");
            out.println("    \"appointmentDate\": \"" + appointmentDate + "\",");
            out.println("    \"appointmentTime\": \"" + appointmentTime + "\",");
            out.println("    \"serviceName\": \"" + serviceName + "\",");
            out.println("    \"billId\": \"" + billId + "\",");
            out.println("    \"location\": \"" + location + "\",");
            out.println("    \"reason\": \"" + reason + "\"");
            out.println("  },");
            out.println("  \"webhookUrl\": \"https://kinggg123.app.n8n.cloud/webhook/create-calendar-event\",");
            out.println("  \"timestamp\": \"" + java.time.LocalDateTime.now().toString() + "\"");
            out.println("}");
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi test calendar: " + e.getMessage());
            e.printStackTrace();
            
            out.println("{");
            out.println("  \"success\": false,");
            out.println("  \"message\": \"Lỗi test calendar: " + e.getMessage() + "\"");
            out.println("}");
        }
    }
} 