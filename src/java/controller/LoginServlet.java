/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import dao.StaffDAO;
import dao.DoctorDAO;
import model.Patients;
import model.User;
import model.Staff;
import model.Doctors;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import dao.AppointmentDAO;
import dao.BlogDAO;
import dao.PatientDAO;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import java.security.SecureRandom;
import java.util.Base64;
import model.Appointment;
import model.BlogPost;
import org.json.JSONObject;

/**
 *
 * @author Home
 */
public class LoginServlet extends HttpServlet {

    /*
    Tóm lại: Nếu email Google chưa có trong database, hãy tự động tạo tài khoản mới rồi đăng nhập luôn. Nếu đã có thì đăng nhập như bình thường.
    */

    private static final String CLIENT_ID = "abc";
    private static final String CLIENT_SECRET = "abc";

 
    private String REDIRECT_URI;
    private static final HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static final JsonFactory JSON_FACTORY = new JacksonFactory();

    @Override
    public void init() throws ServletException {
        super.init();
        // Get the context path dynamically
        String contextPath = "/TestFull";  // Hardcode context path
        REDIRECT_URI = "http://localhost:8080" + contextPath + "/LoginGG/LoginGoogleHandler";
        System.out.println("[DEBUG] REDIRECT_URI initialized: " + REDIRECT_URI);
        System.out.println("[DEBUG] CLIENT_ID: " + CLIENT_ID);
        // Don't log the full client secret for security
        System.out.println("[DEBUG] CLIENT_SECRET (first 4 chars): " + 
            CLIENT_SECRET.substring(0, Math.min(4, CLIENT_SECRET.length())));
    }

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        String userName = (String) session.getAttribute("userName");

        if (userEmail != null) {
            User user = UserDAO.getUserByEmail(userEmail);
            if (user == null) {
                // Chưa có user, tạo mới (password_hash NULL)
                int userId = UserDAO.addUserGoogle(userEmail, userName);
                if (userId > 0) {
                    // Tạo patient mới
                    PatientDAO.addPatientFromGoogle(userId, userName);
                    user = UserDAO.getUserByEmail(userEmail);
                } else {
                    response.sendRedirect("login.jsp?error=system_error");
                    return;
                }
            }
            // Đăng nhập: set session
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getId());
            System.out.println("[DEBUG] Login thành công - role=" + user.getRole() + ", userId=" + user.getId());

            Patients patient = UserDAO.getPatientByUserId(user.getId());
            session.setAttribute("patient", patient);

            List<Doctors> doctors = DoctorDAO.getAllDoctorsOnline();
            request.setAttribute("doctors", doctors);
            
            String role = user.getRole();

            if ("DOCTOR".equalsIgnoreCase(role)) {
                Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
                if (doctor != null) {
                    session.setAttribute("doctor_id", doctor.getDoctor_id());
                    session.setAttribute("doctor", doctor);
                    System.out.println("Google login - doctor_id set in session: " + doctor.getDoctor_id());
                }
                response.sendRedirect(request.getContextPath() + "/DoctorHomePageServlet");
            } else if ("PATIENT".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
            } else if ("STAFF".equalsIgnoreCase(role)) {
                try {
                    Staff staff = StaffDAO.getStaffByUserId(user.getId());
                    if (staff != null) {
                        session.setAttribute("staff_id", staff.getStaffId());
                        session.setAttribute("staff", staff);
                        System.out.println("[DEBUG] Login STAFF - staff_id set in session: " + staff.getStaffId());
                    } else {
                        System.out.println("[DEBUG] Login STAFF - Không tìm thấy staff theo user_id: " + user.getId());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("[ERROR] Lỗi khi lấy staff: " + e.getMessage());
                }
                request.getRequestDispatcher("/jsp/staff/staff_tongquan.jsp").forward(request, response);
            } else if ("MANAGER".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("/jsp/manager/manager_tongquan.jsp").forward(request, response);
            } else {
                System.out.println("Invalid role: " + role);
                response.sendRedirect("login.jsp?error=invalid_role");
            }
        } else {
            // Xử lý OAuth callback từ Google
            String code = request.getParameter("code");
            String error = request.getParameter("error");
            
            System.out.println("[DEBUG] Google OAuth callback - code: " + code);
            System.out.println("[DEBUG] Google OAuth callback - error: " + error);
            
            if (error != null) {
                System.out.println("[ERROR] Google OAuth error: " + error);
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=google_oauth_error");
                return;
            }
            
            if (code != null) {
                try {
                    System.out.println("[DEBUG] Starting token request...");
                    // Lấy access token từ code
                    GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                        HTTP_TRANSPORT,
                        JSON_FACTORY,
                        CLIENT_ID,
                        CLIENT_SECRET,
                        code,
                        REDIRECT_URI)
                        .execute();

                    String accessToken = tokenResponse.getAccessToken();
                    System.out.println("Got access token: " + accessToken);

                    // Lấy thông tin người dùng từ Google API
                    URL url = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestProperty("Authorization", "Bearer " + accessToken);
                    conn.setRequestMethod("GET");
                    conn.setRequestProperty("Accept", "application/json");

                    int responseCode = conn.getResponseCode();
                    System.out.println("Google API Response Code: " + responseCode);

                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        StringBuilder result = new StringBuilder();
                        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                            String line;
                            while ((line = reader.readLine()) != null) {
                                result.append(line);
                            }
                        }

                        String jsonResponse = result.toString();
                        System.out.println("Google API Response: " + jsonResponse);

                        // Parse thông tin người dùng từ JSON
                        JSONObject userInfo = new JSONObject(jsonResponse);
                        String email = userInfo.getString("email");
                        String name = userInfo.getString("name");
                        
                        System.out.println("User info from Google - Email: " + email + ", Name: " + name);
                        
                        // Lưu thông tin vào session và redirect lại để xử lý
                        session.setAttribute("userEmail", email);
                        session.setAttribute("userName", name);
                        response.sendRedirect(request.getContextPath() + "/LoginServlet");
                    }
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=google_auth_failed");
                }
            }
        }
    }

    private String generateRandomPassword() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[16];
        random.nextBytes(bytes);
        return Base64.getEncoder().encodeToString(bytes);
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
        String email = request.getParameter("email");
        String password = request.getParameter("password_hash"); // Actually plain text from form
        
        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);
        System.out.println("Password (plain): " + password);
        System.out.println("Password (hashed): " + UserDAO.hashPassword(password));
        
        // Use loginUser which handles hashing internally
        User user = UserDAO.loginUser(email, password);
        System.out.println("User found: " + (user != null));
        
        if (user != null) {
            System.out.println("User role: " + user.getRole());
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getId());
            System.out.println("[DEBUG] Login thành công - role=" + user.getRole() + ", userId=" + user.getId());

            Patients patient = UserDAO.getPatientByUserId(user.getId());
            session.setAttribute("patient", patient);

            List<Doctors> doctors = DoctorDAO.getAllDoctorsOnline();
            request.setAttribute("doctors", doctors);
            
            String role = user.getRole();  // Lấy role từ user

            if ("DOCTOR".equalsIgnoreCase(role)) {
    // Lấy doctor từ DB bằng user_id
    Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
    if (doctor != null) {
        session.setAttribute("doctor_id", doctor.getDoctor_id());
        session.setAttribute("doctor", doctor); // ✅ THÊM DÒNG NÀY
        System.out.println("Form login - doctor_id set in session: " + doctor.getDoctor_id());
    } else {
        System.out.println("Form login - Không tìm thấy doctor theo user_id: " + user.getId());
    }
    response.sendRedirect(request.getContextPath() + "/DoctorHomePageServlet");

            } else if ("PATIENT".equalsIgnoreCase(role)) {
                 List<Appointment> upcomingAppointments = AppointmentDAO.getUpcomingAppointmentsByPatientId(patient.getPatientId());
                request.setAttribute("upcomingAppointments", upcomingAppointments);

                int totalVisits = PatientDAO.getTotalVisitsByPatientId(patient.getPatientId());
                request.setAttribute("totalVisits", totalVisits);

                System.out.println("Patient ID: " + patient.getPatientId());
                System.out.println("Total visits: " + totalVisits);
                
                   BlogDAO BlogDAO = new BlogDAO();

                List<BlogPost> latestBlogs = BlogDAO.getLatest(2); // hoặc tất cả nếu cần
                request.setAttribute("latestBlogs", latestBlogs);
                
                
                request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
            } else if ("STAFF".equalsIgnoreCase(role)) {
                try {
                    Staff staff = StaffDAO.getStaffByUserId(user.getId());
                    if (staff != null) {
                        session.setAttribute("staff_id", staff.getStaffId());
                        session.setAttribute("staff", staff);
                        System.out.println("[DEBUG] Login STAFF - staff_id set in session: " + staff.getStaffId());
                    } else {
                        System.out.println("[DEBUG] Login STAFF - Không tìm thấy staff theo user_id: " + user.getId());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("[ERROR] Lỗi khi lấy staff: " + e.getMessage());
                }
                request.getRequestDispatcher("/jsp/staff/staff_tongquan.jsp").forward(request, response);
            } else if ("MANAGER".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("/jsp/manager/manager_tongquan.jsp").forward(request, response);
            } else {
                System.out.println("Invalid role: " + role);
                response.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("invalid_role", "UTF-8"));
            }
        } else {
            System.out.println("Login failed - User not found");
            response.sendRedirect("login.jsp?error=1");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Login Servlet";
    }// </editor-fold>

}
