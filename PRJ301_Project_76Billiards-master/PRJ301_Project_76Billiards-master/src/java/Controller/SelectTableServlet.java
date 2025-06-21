/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.BillDAO;
import Model.BillDetails;
import Model.DBConnection;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Type;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Map;

/**
 *
 * @author DELL 7420
 */
public class SelectTableServlet extends HttpServlet {

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
            out.println("<title>Servlet SelectTableServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SelectTableServlet at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu JSON từ body của request
        BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String json = sb.toString();

        // Kiểm tra nếu JSON rỗng
        if (json.isEmpty()) {
            response.getWriter().write("Không nhận được dữ liệu JSON.");
            return;
        }

        // Parse JSON thành một Map (BillDetails)
        Gson gson = new Gson();
        Type type = new TypeToken<Map<String, BillDetails>>() {
        }.getType();
        Map<String, BillDetails> billDetailsMap = gson.fromJson(json, type);

        // Kiểm tra nếu billDetailsMap là null hoặc rỗng
        if (billDetailsMap == null || billDetailsMap.isEmpty()) {
            response.getWriter().write("Dữ liệu BillDetails không hợp lệ hoặc rỗng.");
            return;
        }

        // Lấy Bill_ID từ BillDAO
        try (Connection conn = DBConnection.getConnection()) {
            int billID = BillDAO.getLastBillID(conn); // Lấy Bill_ID mới nhất

            if (billID <= 0) {
                response.getWriter().write("Không tìm thấy Bill_ID!");
                return;
            }

            // Insert BillDetails vào cơ sở dữ liệu
            String sql = "INSERT INTO BillDetails (Bill_ID, Table_ID, Selected, Price, Total) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            // Duyệt qua từng BillDetails và chèn vào cơ sở dữ liệu
            for (Map.Entry<String, BillDetails> entry : billDetailsMap.entrySet()) {
                String tableId = entry.getKey();
                BillDetails details = entry.getValue();

                if (details.getSelected() > 0) {
                    double total = details.getSelected() * details.getPrice();

                    stmt.setInt(1, billID); // Bill_ID
                    stmt.setInt(2, Integer.parseInt(tableId)); // Table_ID
                    stmt.setInt(3, details.getSelected()); // Selected
                    stmt.setDouble(4, details.getPrice()); // Price
                    stmt.setDouble(5, total); // Total

                    stmt.addBatch();
                }
            }

            int[] result = stmt.executeBatch(); // Thực hiện batch insert
            if (result.length > 0) {
                response.getWriter().write("Insert thành công vào BillDetails!");
                HttpSession session = request.getSession();
                session.setAttribute("tableData", billDetailsMap);
            } else {
                response.getWriter().write("Không có dữ liệu nào được chèn.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Lỗi khi insert dữ liệu vào BillDetails: " + e.getMessage());
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
