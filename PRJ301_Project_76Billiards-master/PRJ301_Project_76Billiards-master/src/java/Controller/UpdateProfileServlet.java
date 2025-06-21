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

@WebServlet("/update_profile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy thông tin từ form cập nhật
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // Lấy đối tượng Customer từ session
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");

        // Cập nhật thông tin khách hàng
        try (Connection conn = CustomerDAO.getConnect()) {
            customer.setName(name);
            customer.setEmail(email);
            customer.setPhoneNumber(phone);

            // Cập nhật thông tin vào database
            CustomerDAO.updateCustomer(conn, customer);

            // Cập nhật lại thông tin trong session
            session.setAttribute("customer", customer);

            // Chuyển hướng lại về trang profile với thông báo thành công
            response.sendRedirect("profile.jsp?updateSuccess=true");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?updateError=true");
        }
    }
}
