package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import model.Patients;
import dao.UserDAO;

@WebServlet(name = "UserHompageServlet", urlPatterns = {"/UserHompageServlet"})
public class UserHompageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy thông tin bệnh nhân
        Patients patient = UserDAO.getPatientByUserId(user.getId());
        if (patient != null) {
            session.setAttribute("patient", patient);
        }
        
        // Chuyển hướng đến trang chủ của user
        request.getRequestDispatcher("jsp/patient/user_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 