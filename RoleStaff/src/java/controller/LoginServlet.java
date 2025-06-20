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
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import java.security.SecureRandom;
import java.util.Base64;
import org.json.JSONObject;

/**
 *
 * @author Home
 */
public class LoginServlet extends HttpServlet {

    private static final String CLIENT_ID = "ABC XYZ";
    private static final String CLIENT_SECRET = "Phuoc depzai";
    private static final String REDIRECT_URI = "http://localhost:8080/RoleStaff/login-google";
    private static final HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static final JsonFactory JSON_FACTORY = new JacksonFactory();

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
        // Xử lý callback từ Google OAuth2
        String code = request.getParameter("code");
        System.out.println("Received code from Google: " + code);
        
        if (code != null) {
            try {
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
                    
                    // Kiểm tra email trong database
                    User user = UserDAO.getUserByEmail(email);
                    
                    if (user != null) {
                        System.out.println("User found in database with role: " + user.getRole());
                        // Người dùng đã tồn tại -> Đăng nhập
                        HttpSession session = request.getSession();
                        
                        // Lưu user vào session (password_hash đã được hash trong UserDAO)
                        session.setAttribute("user", user);

                        Patients patient = UserDAO.getPatientByUserId(user.getId());
                        session.setAttribute("patient", patient);

                        List<Doctors> doctors = DoctorDAO.getAllDoctorsOnline();
                        request.setAttribute("doctors", doctors);
                        
                        String role = user.getRole();

                        if ("DOCTOR".equalsIgnoreCase(role)) {
                            // Lấy doctor_id từ DB bằng user_id
                            Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
                            if (doctor != null) {
                                session.setAttribute("doctor_id", doctor.getDoctor_id());
                                System.out.println("Google login - doctor_id set in session: " + doctor.getDoctor_id());
                            } else {
                                System.out.println("Google login - Không tìm thấy doctor theo user_id: " + user.getId());
                            }
                            request.getRequestDispatcher("/jsp/doctor/doctor_tongquan.jsp").forward(request, response);
                        } else if ("PATIENT".equalsIgnoreCase(role)) {
                            request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
                        } else if ("STAFF".equalsIgnoreCase(role)) {
                            request.getRequestDispatcher("/jsp/staff/staff_tongquan.jsp").forward(request, response);
                        } else if ("MANAGER".equalsIgnoreCase(role)) {
                            request.getRequestDispatcher("/jsp/manager/manager_tongquan.jsp").forward(request, response);
                        } else {
                            System.out.println("Invalid role: " + role);
                            response.sendRedirect("login.jsp?error=invalid_role");
                        }
                    } else {
                        System.out.println("User not found, creating new account");
                        // Tạo mật khẩu ngẫu nhiên cho người dùng mới
                        String randomPassword = generateRandomPassword();
                        
                        // Đăng ký người dùng mới với role PATIENT
                        int userId = UserDAO.registerPatient(name, email, randomPassword);
                        
                        if (userId > 0) {
                            System.out.println("New user created with ID: " + userId);
                            // Lấy thông tin user vừa tạo
                            user = UserDAO.getUserByEmail(email);
                            
                            // Đăng nhập
                            HttpSession session = request.getSession();
                            
                            // Lưu user vào session (password_hash đã được hash trong UserDAO)
                            session.setAttribute("user", user);
                            
                            // Chuyển đến trang đăng ký thông tin bệnh nhân
                            request.setAttribute("googleEmail", email);
                            request.setAttribute("googleName", name);
                            request.getRequestDispatcher("signup.jsp").forward(request, response);
                        } else {
                            System.out.println("Failed to create new user");
                            response.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("registration_failed", "UTF-8"));
                        }
                    }
                } else {
                    // Đọc error stream nếu có
                    try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getErrorStream()))) {
                        StringBuilder errorResult = new StringBuilder();
                        String line;
                        while ((line = reader.readLine()) != null) {
                            errorResult.append(line);
                        }
                        System.out.println("Google API Error Response: " + errorResult.toString());
                    }
                    System.out.println("Failed to get user info from Google API");
                    response.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("google_api_failed", "UTF-8"));
                }
            } catch (Exception e) {
                System.out.println("Error during Google OAuth2 process: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("google_auth_failed", "UTF-8"));
            }
        } else {
            // Nếu không phải callback từ Google -> Xử lý đăng nhập thông thường
            processRequest(request, response);
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

            Patients patient = UserDAO.getPatientByUserId(user.getId());
            session.setAttribute("patient", patient);

            List<Doctors> doctors = DoctorDAO.getAllDoctorsOnline();
            request.setAttribute("doctors", doctors);
            
            String role = user.getRole();  // Lấy role từ user

            if ("DOCTOR".equalsIgnoreCase(role)) {
                // Lấy doctor_id từ DB bằng user_id
                Doctors doctor = DoctorDAO.getDoctorByUserId(user.getId());
                if (doctor != null) {
                    session.setAttribute("doctor_id", doctor.getDoctor_id());
                    System.out.println("Form login - doctor_id set in session: " + doctor.getDoctor_id());
                } else {
                    System.out.println("Form login - Không tìm thấy doctor theo user_id: " + user.getId());
                }
                request.getRequestDispatcher("/jsp/doctor/doctor_tongquan.jsp").forward(request, response);
            } else if ("PATIENT".equalsIgnoreCase(role)) {
                request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
            } else if ("STAFF".equalsIgnoreCase(role)) {
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
