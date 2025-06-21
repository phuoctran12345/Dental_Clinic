package Controller;

import Model.Bill;
import Model.BillDAO;
import Model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewHistoryServlet", urlPatterns = {"/history"})
public class ViewHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy session của người dùng
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("customer");

            if (customer == null) {
                // Chuyển hướng về trang đăng nhập nếu chưa đăng nhập
                response.sendRedirect("Login.jsp");
                return;
            }

            List<Bill> billList;
            
            // Kiểm tra role của người dùng
            if (customer.getRole_ID() == 1) { // Admin
                // Admin sẽ thấy tất cả hóa đơn
                billList = BillDAO.getAllBills();
                System.out.println("👤 Admin đang xem tất cả hóa đơn");
            } else {
                // Customer chỉ thấy hóa đơn của mình
                billList = BillDAO.getBillsByCustomer(customer.getCustomer_ID());
                System.out.println("👤 Customer ID=" + customer.getCustomer_ID() + " đang xem hóa đơn của mình");
            }

            // Lưu thông tin vào request
            request.setAttribute("billList", billList);
            request.setAttribute("isAdmin", customer.getRole_ID() == 1);
            
            // Forward đến trang history.jsp
            request.getRequestDispatcher("history.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Lỗi trong ViewHistoryServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}