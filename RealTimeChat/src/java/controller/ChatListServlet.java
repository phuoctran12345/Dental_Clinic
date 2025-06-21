package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import model.User;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/chatList")
public class ChatListServlet extends HttpServlet {

    public static String DB_URL = "jdbc:sqlserver://DESKTOP-F84C0VL;databaseName=Demo;encrypt=false;trustServerCertificate=false;";
    public static String DB_USER = "sa";
    public static String DB_PASSWORD = "123";

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String myRole = (String) session.getAttribute("role");

        String oppositeRole = myRole.equals("doctor") ? "patient" : "doctor";

        List<User> userList = new ArrayList<>();

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(
                "SELECT user_id, username, password_hash, role FROM Users WHERE role = ?")) {

            pstmt.setString(1, oppositeRole);
            ResultSet rs = pstmt.executeQuery();

//            while (rs.next()) {
//                userList.add(new User(
//                        rs.getInt("user_id"),
//                        rs.getString("username"),
//                        rs.getString("password_hash"),
//                        rs.getString("role")
//                ));
//            }

            request.setAttribute("userList", userList);

            // Chuyển đến đúng trang JSP theo role
            if (myRole.equals("doctor")) {
                request.getRequestDispatcher("/doctor_chat.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/patient_chat.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, "Database error");
        }
    }
}
