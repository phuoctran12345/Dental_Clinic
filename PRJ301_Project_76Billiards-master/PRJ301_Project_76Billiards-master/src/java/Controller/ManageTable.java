package Controller;

import Model.BidaDB;
import Model.Customer;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

@MultipartConfig
public class ManageTable extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null || customer.getRole_ID() != 1) {
            response.sendRedirect("BidaShop");
            return;
        }
        response.sendRedirect("add_table.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null || customer.getRole_ID() != 1) {
            response.sendRedirect("BidaShop");
            return;
        }

        String action = request.getParameter("action");
        BidaDB bida = new BidaDB();
        String message = "";
        String status = "success"; // Default to success

        try {
            if ("add".equals(action)) {
                String category = request.getParameter("category");
                String quality = request.getParameter("quality");
                int price = Integer.parseInt(request.getParameter("price"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                // Get image URL from form
                String image = request.getParameter("imageUrl");
                
                // Check if file upload is used instead
                if ((image == null || image.isEmpty()) && request.getContentType() != null && request.getContentType().contains("multipart/form-data")) {
                    try {
                        Part filePart = request.getPart("imageFile");
                        if (filePart != null && filePart.getSize() > 0) {
                            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                            
                            // Create directory if it doesn't exist
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdir();
                            }
                            
                            // Save the file
                            filePart.write(uploadPath + File.separator + fileName);
                            
                            // Set the image path
                            image = "images/" + fileName;
                        } else {
                            throw new Exception("Vui lòng cung cấp ít nhất một ảnh (URL hoặc tệp).");
                        }
                    } catch (Exception e) {
                        throw new Exception("Lỗi khi tải lên ảnh: " + e.getMessage());
                    }
                }
                
                // Validate image
                if (image == null || image.isEmpty()) {
                    throw new Exception("Vui lòng cung cấp ít nhất một ảnh (URL hoặc tệp).");
                }

                // Add or update the table
                bida.addOrUpdateTable(category, quality, price, quantity, image);
                message = "Thêm bàn thành công!";
            } else if ("delete".equals(action)) {
                int tableId = Integer.parseInt(request.getParameter("table_id"));

                // Check if amount is entered, default to 1 if not
                String amountStr = request.getParameter("amount");
                int amount = (amountStr == null || amountStr.isEmpty()) ? 1 : Integer.parseInt(amountStr);

                // Validate tableId and amount
                if (tableId <= 0 || amount <= 0) {
                    throw new Exception("ID bàn hoặc số lượng không hợp lệ.");
                }

                bida.deleteTableByQuantity(tableId, amount);
                message = "Xóa bàn thành công!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi: " + e.getMessage();
            status = "error";
        }

        // Redirect to add_table.jsp with message and status
        response.sendRedirect("add_table.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8") + "&status=" + status);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to manage billiard tables";
    }
}