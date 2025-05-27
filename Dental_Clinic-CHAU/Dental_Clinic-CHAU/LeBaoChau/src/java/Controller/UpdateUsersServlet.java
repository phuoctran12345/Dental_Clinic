package Controller;

import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/UpdateUserServlet"})
public class UpdateUsersServlet extends HttpServlet {

    // Static salt for SHA-256 (not secure for production)
    private static final String SALT = "your_static_salt_123";

    // Get database connection
    private Connection getConnection() throws SQLException {
        try {
            InitialContext ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/yourDataSource");
            return ds.getConnection();
        } catch (NamingException e) {
            System.err.println("NamingException in getConnection: " + e.getMessage());
            // Fallback: Replace with your database credentials
            String url = "jdbc:mysql://localhost:3306/your_database?useSSL=false&serverTimezone=UTC";
            String username = "your_username";
            String password = "your_password";
            return DriverManager.getConnection(url, username, password);
        }
    }

    // Hash password with SHA-256 and salt
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            String saltedPassword = password + SALT;
            byte[] hash = digest.digest(saltedPassword.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not found: " + e.getMessage());
            return null;
        }
    }

    // Validate email format
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    }

    // Validate password complexity
    private boolean isValidPassword(String password) {
        return password != null && password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$");
    }

    // Check if email exists (excluding current user)
    private boolean isEmailExists(String email, int userId, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND id != ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setInt(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("SQLException in isEmailExists: " + e.getMessage());
            throw e;
        }
    }

    // Update email
    private boolean updateEmail(int userId, String email, Connection conn) throws SQLException {
        String sql = "UPDATE users SET email = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setInt(2, userId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updateEmail: " + e.getMessage());
            throw e;
        }
    }

    // Update password
    private boolean updatePassword(int userId, String hashedPassword, Connection conn) throws SQLException {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);
            int rows = stmt.executeUpdate();
            if (rows == 0) {
                System.err.println("No rows updated for userId: " + userId);
            }
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updatePassword: " + e.getMessage());
            throw e;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("user_taikhoan.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("user_taikhoan.jsp?error=Vui lòng đăng nhập lại");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.err.println("User object is null in session");
            response.sendRedirect("user_taikhoan.jsp?error=Phiên đăng nhập không hợp lệ");
            return;
        }

        String field = request.getParameter("field");
        String value = request.getParameter("value");

        // Validate input
        if (field == null || value == null || value.trim().isEmpty()) {
            System.err.println("Invalid input: field or value is null/empty");
            response.sendRedirect("user_taikhoan.jsp?error=Dữ liệu không hợp lệ");
            return;
        }

        try (Connection conn = getConnection()) {
            if ("email".equals(field)) {
                String email = value.trim();
                if (!isValidEmail(email)) {
                    response.sendRedirect("user_taikhoan.jsp?error=Email không hợp lệ");
                    return;
                }
                if (isEmailExists(email, user.getId(), conn)) {
                    response.sendRedirect("user_taikhoan.jsp?error=Email đã được sử dụng");
                    return;
                }
                if (updateEmail(user.getId(), email, conn)) {
                    user.setEmail(email);
                    session.setAttribute("user", user);
                    response.sendRedirect("user_taikhoan.jsp?update=success");
                } else {
                    response.sendRedirect("user_taikhoan.jsp?error=Cập nhật email thất bại");
                }
            } else if ("password".equals(field)) {
                if (!isValidPassword(value)) {
                    response.sendRedirect("user_taikhoan.jsp?error=Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
                    return;
                }
                String hashedPassword = hashPassword(value);
                if (hashedPassword == null) {
                    response.sendRedirect("user_taikhoan.jsp?error=Lỗi khi mã hóa mật khẩu");
                    return;
                }
                try {
                    if (updatePassword(user.getId(), hashedPassword, conn)) {
                        user.setPasswordHash(hashedPassword);
                        session.setAttribute("user", user);
                        response.sendRedirect("user_taikhoan.jsp?update=success");
                    } else {
                        response.sendRedirect("user_taikhoan.jsp?error=Cập nhật mật khẩu thất bại");
                    }
                } catch (SQLException e) {
                    response.sendRedirect("user_taikhoan.jsp?error=Lỗi cơ sở dữ liệu khi cập nhật mật khẩu: " + e.getMessage());
                }
            } else {
                response.sendRedirect("user_taikhoan.jsp?error=Trường dữ liệu không hợp lệ");
            }
        } catch (SQLException e) {
            System.err.println("SQLException in doPost: " + e.getMessage());
            response.sendRedirect("user_taikhoan.jsp?error=Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error in doPost: " + e.getMessage());
            response.sendRedirect("user_taikhoan.jsp?error=Lỗi không xác định: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for updating user email and password";
    }
}