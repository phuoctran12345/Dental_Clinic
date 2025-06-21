/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.BillDAO;
import Model.Customer;
import Model.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author DELL 7420
 */
public class ConfirmPayment extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ConfirmPayment</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ConfirmPayment at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DBConnection.getConnection()) {  // 🔥 Sử dụng try-with-resources
            conn.setAutoCommit(false);

            // 1️⃣ Lấy `Customer_ID` từ session
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("customer");
            if (customer == null) {
                response.getWriter().write("ANH NHAC EM");
                return;
            }
            int Customer_ID = customer.getCustomer_ID(); // 🔥 Lấy ID khách hàng

            // 2️⃣ Nhận dữ liệu từ request
            String totalBill = request.getParameter("totalBill");
            String date = request.getParameter("date");
            String startTime = request.getParameter("startTime");
            String statusBill = request.getParameter("statusBill");
            String receiptImage = request.getParameter("receiptImage");

            // 3️⃣ Chèn Bill vào database (THÊM customerID)
            int billID = BillDAO.insertBill(conn, Customer_ID, date, startTime, statusBill, receiptImage, new BigDecimal(totalBill));
            if (billID > 0) {
                System.out.println("✅ Tạo hóa đơn thành công với Bill_ID=" + billID);
            } else {
                System.out.println("❌ Lỗi khi tạo hóa đơn!");
            }
            // 4️⃣ Chèn danh sách bàn vào BillDetails
            // Lặp qua các tham số trong request

            for (String param : request.getParameterMap().keySet()) {
                if (param.startsWith("tableData[")) {
                    try {
                        // Lấy tableID từ param
                        String tableIdString = param.split("\\[")[1].split("\\]")[0];
                        int tableID = Integer.parseInt(tableIdString); // Đảm bảo rằng tableID hợp lệ

                        // Giả sử BillDetails_ID là tự động tăng, nếu không thì bạn có thể thay đổi cách tạo giá trị này
                        // Nếu sử dụng Auto Increment trong SQL, bạn không cần chèn BillDetails_ID, nó sẽ tự động tạo.
                        String sql = "INSERT INTO BillDetails (Bill_ID, Table_ID) VALUES (?, ?)";
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            stmt.setInt(1, billID);  // Chèn Bill_ID
                            stmt.setInt(2, tableID);  // Chèn Table_ID

                            int rowsInserted = stmt.executeUpdate();
                            if (rowsInserted > 0) {
                                System.out.println("✅ Đã thêm vào BillDetails: Bill_ID=" + billID + ", Table_ID=" + tableID);
                            } else {
                                System.out.println("⚠️ Không có hàng nào được chèn vào BillDetails!");
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        System.out.println("❌ Lỗi khi xử lý: " + e.getMessage());
                    }
                }
            }
            conn.commit();
            request.setAttribute("message", "Đã gửi đơn thanh toán, xin chờ xác nhận của shop.");
            request.getRequestDispatcher("/success.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
