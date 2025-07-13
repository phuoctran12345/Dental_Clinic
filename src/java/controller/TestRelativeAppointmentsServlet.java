package controller;

import dao.AppointmentDAO;
import model.Appointment;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "TestRelativeAppointmentsServlet", urlPatterns = {"/TestRelativeAppointments"})
public class TestRelativeAppointmentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Test Relative Appointments</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
            out.println("table { border-collapse: collapse; width: 100%; margin: 20px 0; }");
            out.println("table, th, td { border: 1px solid #ddd; }");
            out.println("th, td { padding: 12px; text-align: left; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println(".section { margin: 30px 0; }");
            out.println(".highlight { background-color: #ffffcc; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            
            out.println("<h1>🔍 Test Relative Appointments Data</h1>");
            
            // 1. Kiểm tra tất cả appointments có booked_by_user_id
            out.println("<div class='section'>");
            out.println("<h2>1. Tất cả Appointments có booked_by_user_id</h2>");
            checkAllAppointmentsWithBookedBy(out);
            out.println("</div>");
            
            // 2. Kiểm tra bảng Relatives
            out.println("<div class='section'>");
            out.println("<h2>2. Dữ liệu bảng Relatives</h2>");
            checkRelativesData(out);
            out.println("</div>");
            
            // 3. Test method getRelativeAppointments với các user ID khác nhau
            out.println("<div class='section'>");
            out.println("<h2>3. Test getRelativeAppointments với các User ID</h2>");
            testGetRelativeAppointments(out);
            out.println("</div>");
            
            // 4. Hiển thị cấu trúc bảng Appointment
            out.println("<div class='section'>");
            out.println("<h2>4. Cấu trúc bảng Appointment</h2>");
            showAppointmentTableStructure(out);
            out.println("</div>");
            
            out.println("</body>");
            out.println("</html>");
            
        } catch (Exception e) {
            out.println("<h2>❌ Lỗi: " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
    }
    
    private void checkAllAppointmentsWithBookedBy(PrintWriter out) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT a.appointment_id, a.patient_id, a.doctor_id, a.booked_by_user_id, 
                       a.work_date, a.status, a.reason,
                       p.full_name as patient_name,
                       u.email as booked_by_email
                FROM Appointment a
                LEFT JOIN Patients p ON a.patient_id = p.patient_id
                LEFT JOIN users u ON a.booked_by_user_id = u.user_id
                WHERE a.booked_by_user_id IS NOT NULL
                ORDER BY a.appointment_id DESC
            """;
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>Appointment ID</th>");
            out.println("<th>Patient ID</th>");
            out.println("<th>Doctor ID</th>");
            out.println("<th>Booked By User ID</th>");
            out.println("<th>Work Date</th>");
            out.println("<th>Status</th>");
            out.println("<th>Patient Name</th>");
            out.println("<th>Booked By Email</th>");
            out.println("</tr>");
            
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("appointment_id") + "</td>");
                out.println("<td>" + rs.getInt("patient_id") + "</td>");
                out.println("<td>" + rs.getLong("doctor_id") + "</td>");
                out.println("<td class='highlight'><strong>" + rs.getInt("booked_by_user_id") + "</strong></td>");
                out.println("<td>" + rs.getDate("work_date") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
                out.println("<td>" + rs.getString("patient_name") + "</td>");
                out.println("<td>" + rs.getString("booked_by_email") + "</td>");
                out.println("</tr>");
            }
            
            if (!hasData) {
                out.println("<tr><td colspan='8'>⚠️ Không có appointment nào có booked_by_user_id</td></tr>");
            }
            
            out.println("</table>");
            
            conn.close();
        } catch (Exception e) {
            out.println("<p>❌ Lỗi: " + e.getMessage() + "</p>");
        }
    }
    
    private void checkRelativesData(PrintWriter out) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT r.relative_id, r.user_id, r.full_name, r.phone, 
                       r.relationship, u.email as user_email
                FROM Relatives r
                JOIN users u ON r.user_id = u.user_id
                ORDER BY r.relative_id DESC
            """;
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>Relative ID</th>");
            out.println("<th>User ID</th>");
            out.println("<th>Full Name</th>");
            out.println("<th>Phone</th>");
            out.println("<th>Relationship</th>");
            out.println("<th>User Email</th>");
            out.println("</tr>");
            
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("relative_id") + "</td>");
                out.println("<td class='highlight'><strong>" + rs.getInt("user_id") + "</strong></td>");
                out.println("<td>" + rs.getString("full_name") + "</td>");
                out.println("<td>" + rs.getString("phone") + "</td>");
                out.println("<td>" + rs.getString("relationship") + "</td>");
                out.println("<td>" + rs.getString("user_email") + "</td>");
                out.println("</tr>");
            }
            
            if (!hasData) {
                out.println("<tr><td colspan='6'>⚠️ Không có dữ liệu trong bảng Relatives</td></tr>");
            }
            
            out.println("</table>");
            
            conn.close();
        } catch (Exception e) {
            out.println("<p>❌ Lỗi: " + e.getMessage() + "</p>");
        }
    }
    
    private void testGetRelativeAppointments(PrintWriter out) {
        try {
            // Test với các user ID từ 1 đến 10
            for (int userId = 1; userId <= 10; userId++) {
                List<Appointment> appointments = AppointmentDAO.getRelativeAppointments(userId);
                
                out.println("<h4>👤 User ID " + userId + ": " + 
                          (appointments != null ? appointments.size() : 0) + " appointments</h4>");
                
                if (appointments != null && !appointments.isEmpty()) {
                    out.println("<table>");
                    out.println("<tr>");
                    out.println("<th>Appointment ID</th>");
                    out.println("<th>Patient Name</th>");
                    out.println("<th>Doctor Name</th>");
                    out.println("<th>Work Date</th>");
                    out.println("<th>Status</th>");
                    out.println("</tr>");
                    
                    for (Appointment ap : appointments) {
                        out.println("<tr>");
                        out.println("<td>" + ap.getAppointmentId() + "</td>");
                        out.println("<td>" + ap.getPatientName() + "</td>");
                        out.println("<td>" + ap.getDoctorName() + "</td>");
                        out.println("<td>" + ap.getFormattedWorkDate() + "</td>");
                        out.println("<td>" + ap.getStatus() + "</td>");
                        out.println("</tr>");
                    }
                    
                    out.println("</table>");
                }
            }
            
        } catch (Exception e) {
            out.println("<p>❌ Lỗi: " + e.getMessage() + "</p>");
        }
    }
    
    private void showAppointmentTableStructure(PrintWriter out) {
        try {
            Connection conn = DBContext.getConnection();
            String sql = """
                SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
                FROM INFORMATION_SCHEMA.COLUMNS
                WHERE TABLE_NAME = 'Appointment'
                ORDER BY ORDINAL_POSITION
            """;
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            out.println("<table>");
            out.println("<tr>");
            out.println("<th>Column Name</th>");
            out.println("<th>Data Type</th>");
            out.println("<th>Nullable</th>");
            out.println("<th>Default</th>");
            out.println("</tr>");
            
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME");
                out.println("<tr" + 
                          (columnName.equals("booked_by_user_id") ? " class='highlight'" : "") + ">");
                out.println("<td><strong>" + columnName + "</strong></td>");
                out.println("<td>" + rs.getString("DATA_TYPE") + "</td>");
                out.println("<td>" + rs.getString("IS_NULLABLE") + "</td>");
                out.println("<td>" + rs.getString("COLUMN_DEFAULT") + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
            
            conn.close();
        } catch (Exception e) {
            out.println("<p>❌ Lỗi: " + e.getMessage() + "</p>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 