/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Model.Customer;
import Model.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/change_password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");

        // Kiểm tra mật khẩu cũ
        if (!customer.getPassword().equals(currentPassword)) {
            response.sendRedirect("change_password.jsp?error=wrongCurrentPassword");
            return;
        }

        // Kiểm tra mật khẩu mới và xác nhận
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("change_password.jsp?error=passwordMismatch");
            return;
        }

        try (Connection conn = CustomerDAO.getConnect()) {
            CustomerDAO.changePassword(conn, customer.getCustomer_ID(), newPassword);

            // Cập nhật mật khẩu trong session
            customer.setPassword(newPassword);
            session.setAttribute("customer", customer);

            // Chuyển hướng về profile.jsp và thông báo thành công
            response.sendRedirect("profile.jsp?updateSuccess=true");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("change_password.jsp?error=databaseError");
        }
    }
}
