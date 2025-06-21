/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DBConnection;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author lebao
 */
public class UpdateTable extends HttpServlet {

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
            out.println("<title>Servlet UpdateTable</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateTable at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Lấy dữ liệu JSON từ request
        Gson gson = new Gson();
        JsonObject tableData = gson.fromJson(request.getReader(), JsonObject.class);

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Dùng transaction để xử lý nhiều bàn

            String updateSql = "UPDATE BillardTable SET Quantity = Quantity - ? WHERE Table_ID = ?";
            String update0Sql = "UPDATE BillardTable SET Quantity = 0 WHERE Table_ID = ?";

            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql); PreparedStatement updateToZeroStmt = conn.prepareStatement(update0Sql)) {

                boolean hasUpdate = false; // Kiểm tra có thao tác nào không

                for (String key : tableData.keySet()) {
                    JsonObject tableInfo = tableData.getAsJsonObject(key);
                    int tableId = Integer.parseInt(key);
                    int selected = tableInfo.get("selected").getAsInt();

                    System.out.println("Đang xử lý bàn ID: " + tableId + ", Selected: " + selected);

                    if (selected > 0) { // Chỉ xử lý bàn có selected > 0
                        // Kiểm tra số lượng thực tế của bàn trong DB trước khi cập nhật
                        String checkSql = "SELECT Quantity FROM BillardTable WHERE Table_ID = ?";
                        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                            checkStmt.setInt(1, tableId);
                            ResultSet rs = checkStmt.executeQuery();
                            if (rs.next()) {
                                int currentQuantity = rs.getInt("Quantity");

                                if (currentQuantity > selected) {
                                    // Giảm số lượng bàn
                                    updateStmt.setInt(1, selected);
                                    updateStmt.setInt(2, tableId);
                                    updateStmt.addBatch();
                                    System.out.println("Giảm số lượng bàn ID " + tableId);
                                } else {
                                    // Đưa số lượng bàn về 0
                                    updateToZeroStmt.setInt(1, tableId);
                                    updateToZeroStmt.addBatch();
                                    System.out.println("Đặt Quantity = 0 cho bàn ID " + tableId);
                                }
                                hasUpdate = true;
                            }
                        }
                    }
                }

                if (hasUpdate) {
                    updateStmt.executeBatch(); // Thực hiện giảm số lượng bàn
                    updateToZeroStmt.executeBatch(); // Đưa số lượng bàn về 0
                    conn.commit(); // Xác nhận thay đổi trong DB
                    response.getWriter().write("{\"status\":\"success\", \"message\":\"Tất cả bàn đã được cập nhật\"}");
                } else {
                    conn.rollback();
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Không có bàn nào được xử lý\"}");
                }
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi khi cập nhật bàn: " + e.getMessage() + "\"}");
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
