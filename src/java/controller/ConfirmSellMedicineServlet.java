package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ConfirmSellMedicineServlet", urlPatterns = {"/ConfirmSellMedicineServlet"})
public class ConfirmSellMedicineServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String customerName = request.getParameter("customer_name");
        String medicineId = request.getParameter("medicine_id");
        String medicineName = request.getParameter("medicine_name");
        String quantity = request.getParameter("quantity");
        String price = request.getParameter("price");
        String paymentMethod = request.getParameter("payment_method");
        // Truyền lại sang JSP xác nhận
        request.setAttribute("customer_name", customerName);
        request.setAttribute("medicine_id", medicineId);
        request.setAttribute("medicine_name", medicineName);
        request.setAttribute("quantity", quantity);
        request.setAttribute("price", price);
        request.setAttribute("payment_method", paymentMethod);
        request.getRequestDispatcher("/jsp/staff/confirm_sell_medicine.jsp").forward(request, response);
    }
} 