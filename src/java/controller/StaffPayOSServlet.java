/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.PayOSUtil;
import dao.BillDAO;
import model.Bill;
import java.math.BigDecimal;

/**
 *
 * @author tranhongphuoc
 */
@WebServlet(name="StaffPayOSServlet", urlPatterns={"/StaffPayOSServlet"})
public class StaffPayOSServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet StaffPayOSServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffPayOSServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String paymentMethod = request.getParameter("payment_method");
        if ("payos".equals(paymentMethod)) {
            String customerName = request.getParameter("customer_name");
            String medicineName = request.getParameter("medicine_name");
            String quantityStr = request.getParameter("quantity");
            String priceStr = request.getParameter("price");
            int quantity = Integer.parseInt(quantityStr);
            BigDecimal price = new BigDecimal(priceStr);
            BigDecimal total = price.multiply(new BigDecimal(quantity));
            try {
                BillDAO billDAO = new BillDAO();
                String billId = billDAO.getNextPharmacyBillId();
                String orderId = "ORDER_" + System.currentTimeMillis();
                Bill bill = new Bill();
                bill.setBillId(billId);
                bill.setOrderId(orderId);
                bill.setServiceId(1); // ID dịch vụ bán thuốc, có thể sửa nếu cần
                bill.setAmount(total);
                bill.setOriginalPrice(total);
                bill.setCustomerName(customerName != null && !customerName.isEmpty() ? customerName : "Khách lẻ");
                bill.setPaymentMethod("PayOS");
                bill.setPaymentStatus("pending");
                // ... set các trường khác nếu cần
                billDAO.createBill(bill);
                // Gọi PayOSUtil để lấy QR
                String qrCode = utils.PayOSUtil.createPayOSPaymentRequest(bill, "Bán thuốc: " + medicineName);
                request.setAttribute("qrCode", qrCode);
                request.setAttribute("bill", bill);
                request.setAttribute("medicineName", medicineName);
                request.setAttribute("quantity", quantity);
                request.setAttribute("price", price);
                request.setAttribute("total", total);
                request.getRequestDispatcher("/jsp/staff/bill_qr.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        super.doPost(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
