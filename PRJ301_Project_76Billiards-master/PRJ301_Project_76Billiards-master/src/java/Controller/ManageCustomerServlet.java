package Controller;

import Model.Customer;
import Model.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageCustomerServlet", urlPatterns = {"/ManageCustomerServlet"})
public class ManageCustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra xem có đăng nhập và là admin không
        if (request.getSession().getAttribute("customer") == null || 
            ((Customer) request.getSession().getAttribute("customer")).getRole_ID() != 1) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // Lấy thông tin admin hiện tại
        Customer currentAdmin = (Customer) request.getSession().getAttribute("customer");
        CustomerDAO customerDAO = new CustomerDAO();
        String message = null;

        // Kiểm tra xem có phải admin chính không (Customer_ID = 1)
        boolean isMainAdmin = (currentAdmin.getCustomer_ID() == 1);

        String action = request.getParameter("action");
        if (action != null && isMainAdmin) { // Chỉ admin chính được thực hiện
            int customerId = Integer.parseInt(request.getParameter("id"));

            // Không cho phép hủy quyền của chính mình
            if (customerId == currentAdmin.getCustomer_ID()) {
                message = "Không thể hủy quyền của chính mình!";
            } else {
                try {
                    if ("grantAdmin".equals(action)) {
                        // Cấp quyền Admin
                        customerDAO.updateRole(customerId, 1);
                        message = "Đã cấp quyền Admin thành công!";
                    } else if ("revokeAdmin".equals(action)) {
                        // Hủy quyền Admin (cập nhật Role_ID về 2)
                        customerDAO.updateRole(customerId, 2);
                        message = "Đã hủy quyền Admin thành công!";
                    }
                } catch (Exception e) {
                    message = "Lỗi khi thực hiện hành động: " + e.getMessage();
                }
            }
        } else if (action != null && !isMainAdmin) {
            message = "Chỉ admin chính mới có quyền cấp hoặc hủy quyền!";
        }

        // Lấy danh sách khách hàng mới nhất
        List<Customer> customers = customerDAO.getAllCustomers();
        request.setAttribute("customers", customers);
        request.setAttribute("message", message);

        // Chuyển tiếp về manage_customers.jsp (không redirect)
        request.getRequestDispatcher("manage_customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
