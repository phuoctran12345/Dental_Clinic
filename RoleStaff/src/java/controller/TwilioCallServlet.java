package controller;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Call;
import com.twilio.type.PhoneNumber;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.JsonObject;
import java.io.PrintWriter;

@WebServlet(name = "TwilioCallServlet", urlPatterns = {"/twilio-call"})
public class TwilioCallServlet extends HttpServlet {
    
    // Twilio credentials - cần đăng ký tại twilio.com
    // TODO: Move to environment variables or config file
    public static final String ACCOUNT_SID = "YOUR_TWILIO_ACCOUNT_SID"; // Get from .env file
    public static final String AUTH_TOKEN = "YOUR_TWILIO_AUTH_TOKEN"; // Get from .env file  
    public static final String TWILIO_PHONE = "+1234567890"; // Get from .env file
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String customerPhone = request.getParameter("phone");
            String patientName = request.getParameter("patientName");
            
            // Khởi tạo Twilio
            Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
            
            // Tạo cuộc gọi
            Call call = Call.creator(
                new PhoneNumber(customerPhone), // Số nhận
                new PhoneNumber(TWILIO_PHONE),  // Số gọi (của bạn)
                "http://demo.twilio.com/docs/voice.xml" // TwiML URL
            ).create();
            
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", "Đang gọi cho " + patientName);
            jsonResponse.addProperty("callSid", call.getSid());
            
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi: " + e.getMessage());
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
} 