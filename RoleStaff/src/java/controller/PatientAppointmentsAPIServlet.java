package controller;

import dao.AppointmentDAO;
import model.Appointment;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/api/patient/appointments")
public class PatientAppointmentsAPIServlet extends HttpServlet {
    
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy session và kiểm tra đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\":\"Chưa đăng nhập\",\"code\":\"UNAUTHORIZED\"}");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\":\"Phiên đăng nhập hết hạn\",\"code\":\"SESSION_EXPIRED\"}");
                return;
            }
            
            // Kiểm tra role patient
            if (!"PATIENT".equals(user.getRole())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.print("{\"error\":\"Không có quyền truy cập\",\"code\":\"FORBIDDEN\"}");
                return;
            }
            
            int patientId = user.getId();
            String type = request.getParameter("type"); // "all", "upcoming", "history"
            
            List<Appointment> appointments;
            
            switch (type != null ? type : "all") {
                case "upcoming":
                    appointments = AppointmentDAO.getUpcomingAppointmentsByPatientId(patientId);
                    break;
                case "history":
                    appointments = getHistoryAppointments(patientId);
                    break;
                case "all":
                default:
                    appointments = AppointmentDAO.getAppointmentsByPatientId(patientId);
                    break;
            }
            
            // Tạo response object
            AppointmentResponse apiResponse = new AppointmentResponse();
            apiResponse.success = true;
            apiResponse.message = "Lấy danh sách cuộc hẹn thành công";
            apiResponse.data = appointments;
            apiResponse.total = appointments.size();
            apiResponse.patientId = patientId;
            apiResponse.type = type != null ? type : "all";
            
            out.print(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.error = "Lỗi server: " + e.getMessage();
            errorResponse.code = "INTERNAL_ERROR";
            errorResponse.success = false;
            
            out.print(gson.toJson(errorResponse));
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy session và kiểm tra đăng nhập
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\":\"Chưa đăng nhập\",\"code\":\"UNAUTHORIZED\"}");
                return;
            }
            
            User user = (User) session.getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\":\"Phiên đăng nhập hết hạn\",\"code\":\"SESSION_EXPIRED\"}");
                return;
            }
            
            String action = request.getParameter("action");
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            
            boolean success = false;
            String message = "";
            
            switch (action) {
                case "cancel":
                    success = cancelAppointment(appointmentId, user.getId());
                    message = success ? "Hủy cuộc hẹn thành công" : "Không thể hủy cuộc hẹn";
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Hành động không hợp lệ\",\"code\":\"INVALID_ACTION\"}");
                    return;
            }
            
            SimpleResponse apiResponse = new SimpleResponse();
            apiResponse.success = success;
            apiResponse.message = message;
            
            if (!success) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            
            out.print(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.error = "Lỗi server: " + e.getMessage();
            errorResponse.code = "INTERNAL_ERROR";
            errorResponse.success = false;
            
            out.print(gson.toJson(errorResponse));
            e.printStackTrace();
        }
    }
    
    private List<Appointment> getHistoryAppointments(int patientId) {
        // Lấy các cuộc hẹn đã qua (work_date < today)
        List<Appointment> allAppointments = AppointmentDAO.getAppointmentsByPatientId(patientId);
        LocalDate today = LocalDate.now();
        
        return allAppointments.stream()
                .filter(apt -> apt.getWorkDate().isBefore(today))
                .toList();
    }
    
    private boolean cancelAppointment(int appointmentId, int patientId) {
        // Kiểm tra appointment có thuộc về patient này không
        List<Appointment> appointments = AppointmentDAO.getAppointmentsByPatientId(patientId);
        boolean isOwner = appointments.stream()
                .anyMatch(apt -> apt.getAppointmentId() == appointmentId);
        
        if (!isOwner) {
            return false;
        }
        
        // Hủy appointment bằng cách cập nhật status
        return AppointmentDAO.cancelReservation(appointmentId);
    }
    
    // Response classes
    public static class AppointmentResponse {
        public boolean success;
        public String message;
        public List<Appointment> data;
        public int total;
        public int patientId;
        public String type;
    }
    
    public static class SimpleResponse {
        public boolean success;
        public String message;
    }
    
    public static class ErrorResponse {
        public boolean success;
        public String error;
        public String code;
    }
    
    // JSON Adapters for LocalDate and LocalTime
    public static class LocalDateAdapter implements com.google.gson.JsonSerializer<LocalDate>, com.google.gson.JsonDeserializer<LocalDate> {
        @Override
        public com.google.gson.JsonElement serialize(LocalDate date, java.lang.reflect.Type typeOfSrc, com.google.gson.JsonSerializationContext context) {
            return new com.google.gson.JsonPrimitive(date.format(DateTimeFormatter.ISO_LOCAL_DATE));
        }
        
        @Override
        public LocalDate deserialize(com.google.gson.JsonElement json, java.lang.reflect.Type typeOfT, com.google.gson.JsonDeserializationContext context) {
            return LocalDate.parse(json.getAsString());
        }
    }
    
    public static class LocalTimeAdapter implements com.google.gson.JsonSerializer<LocalTime>, com.google.gson.JsonDeserializer<LocalTime> {
        @Override
        public com.google.gson.JsonElement serialize(LocalTime time, java.lang.reflect.Type typeOfSrc, com.google.gson.JsonSerializationContext context) {
            return new com.google.gson.JsonPrimitive(time.format(DateTimeFormatter.ofPattern("HH:mm")));
        }
        
        @Override
        public LocalTime deserialize(com.google.gson.JsonElement json, java.lang.reflect.Type typeOfT, com.google.gson.JsonDeserializationContext context) {
            return LocalTime.parse(json.getAsString());
        }
    }
} 