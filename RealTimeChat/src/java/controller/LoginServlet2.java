package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Đảm bảo @WebServlet được bật
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap; // Không cần thiết nếu không dùng Map để lưu
import java.util.Map; // Không cần thiết nếu không dùng Map để lưu

public class LoginServlet2 extends HttpServlet {

    // --- Cấu hình Database (Giống trong ChatEndPoint.java) ---
    public static String DB_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static String DB_URL = "jdbc:sqlserver://DESKTOP-F84C0VL;databaseName=Demo;encrypt=false;trustServerCertificate=false;loginTimeout=30;";
    public static String DB_USER = "sa";
    public static String DB_PASSWORD = "123";

    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found in LoginServlet: " + DB_DRIVER);
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            String sql = "SELECT user_id, username, password, role FROM Users WHERE username = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedPasswordHash = rs.getString("password");

                // --- Kiểm tra mật khẩu (Sử dụng BCrypt trong thực tế) ---
                // if (BCrypt.checkpw(password, storedPasswordHash)) {
                if (password.equals(storedPasswordHash)) { // Dùng tạm cho demo, không an toàn cho production
                    // Đăng nhập thành công
                    HttpSession session = request.getSession();

                    // <<--- SỬA CHỮA TẠI ĐÂY ---
                    session.setAttribute("userId", rs.getInt("user_id"));       // Lưu trực tiếp Integer
                    session.setAttribute("username", rs.getString("username")); // Lưu trực tiếp String
                    session.setAttribute("role", rs.getString("role"));         // Lưu trực tiếp String
                    // Bỏ dòng: Map<String, Object> loggedInUser = new HashMap<>();
                    // Bỏ dòng: loggedInUser.put("userId", ...); ...
                    // Bỏ dòng: session.setAttribute("loggedInUser", loggedInUser);
                    // <<--- KẾT THÚC SỬA CHỮA ---

                    // THÊM CÁC DÒNG DEBUG ĐỂ KIỂM TRA LẠI TRONG LOG TOMCAT
                    System.out.println("--- DEBUG (LoginServlet2): Đã đặt các thuộc tính vào HttpSession ---");
                    System.out.println("  userId: " + session.getAttribute("userId") + " (Kiểu: " + (session.getAttribute("userId") != null ? session.getAttribute("userId").getClass().getName() : "null") + ")");
                    System.out.println("  username: " + session.getAttribute("username") + " (Kiểu: " + (session.getAttribute("username") != null ? session.getAttribute("username").getClass().getName() : "null") + ")");
                    System.out.println("  role: " + session.getAttribute("role") + " (Kiểu: " + (session.getAttribute("role") != null ? session.getAttribute("role").getClass().getName() : "null") + ")");
                    System.out.println("------------------------------------------------------------------");

                    String role = rs.getString("role");

                    response.sendRedirect(request.getContextPath() + "/chat.jsp");
                    
                    return;
                }
            }

            // Đăng nhập thất bại
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi server: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
