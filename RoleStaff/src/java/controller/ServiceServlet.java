package controller;

import dao.ServiceDAO;
import model.Service;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet để xử lý các request liên quan đến dịch vụ y tế
 */

public class ServiceServlet extends HttpServlet {
    
    private ServiceDAO serviceDAO = new ServiceDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    handleListServices(request, response);
                    break;
                case "json":
                    handleJsonServices(request, response);
                    break;
                case "category":
                    handleServicesByCategory(request, response);
                    break;
                case "search":
                    handleSearchServices(request, response);
                    break;
                case "detail":
                    handleServiceDetail(request, response);
                    break;
                default:
                    handleListServices(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong ServiceServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi xử lý dịch vụ: " + e.getMessage());
        }
    }

    /**
     * Hiển thị danh sách dịch vụ cho JSP
     */
    private void handleListServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Service> services = serviceDAO.getActiveServices();
        List<String> categories = serviceDAO.getAllCategories();
        
        request.setAttribute("services", services);
        request.setAttribute("categories", categories);
        
        // Forward tới JSP hiển thị dịch vụ
        request.getRequestDispatcher("jsp/patient/user_services.jsp").forward(request, response);
    }

    /**
     * Trả về JSON danh sách dịch vụ cho AJAX
     */
    private void handleJsonServices(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        List<Service> services = serviceDAO.getActiveServices();
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(services));
        out.flush();
    }

    /**
     * Lấy dịch vụ theo danh mục
     */
    private void handleServicesByCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String category = request.getParameter("category");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        List<Service> services;
        if (category != null && !category.isEmpty()) {
            services = serviceDAO.getServicesByCategory(category);
        } else {
            services = serviceDAO.getActiveServices();
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(services));
        out.flush();
    }

    /**
     * Tìm kiếm dịch vụ
     */
    private void handleSearchServices(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String searchTerm = request.getParameter("q");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        List<Service> services;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            services = serviceDAO.searchServicesByName(searchTerm.trim());
        } else {
            services = serviceDAO.getActiveServices();
        }
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(services));
        out.flush();
    }

    /**
     * Chi tiết dịch vụ
     */
    private void handleServiceDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String serviceIdStr = request.getParameter("id");
        if (serviceIdStr == null || serviceIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID dịch vụ");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            Service service = serviceDAO.getServiceById(serviceId);
            
            if (service == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy dịch vụ");
                return;
            }

            String responseFormat = request.getParameter("format");
            if ("json".equals(responseFormat)) {
                // Trả về JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(service));
                out.flush();
            } else {
                // Forward tới JSP chi tiết
                request.setAttribute("service", service);
                request.getRequestDispatcher("/service-detail.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID dịch vụ không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding cho request
        request.setCharacterEncoding("UTF-8");
        
        // Kiểm tra quyền quản trị (STAFF hoặc MANAGER)
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");
        
        if (userRole == null || (!userRole.equals("STAFF") && !userRole.equals("MANAGER"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền thực hiện thao tác này");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu parameter action");
            return;
        }

        try {
            switch (action) {
                case "create":
                    handleCreateService(request, response);
                    break;
                case "update":
                    handleUpdateService(request, response);
                    break;
                case "delete":
                    handleDeleteService(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action không hợp lệ");
                    break;
            }
        } catch (Exception e) {
            System.err.println("Lỗi xử lý POST trong ServiceServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi xử lý dịch vụ: " + e.getMessage());
        }
    }

    /**
     * Tạo dịch vụ mới
     */
    private void handleCreateService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String serviceName = request.getParameter("serviceName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String image = request.getParameter("image");
        
        // Validation
        if (serviceName == null || serviceName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tên dịch vụ không được để trống");
            return;
        }
        
        if (priceStr == null || priceStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giá dịch vụ không được để trống");
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);
            if (price < 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giá dịch vụ phải >= 0");
                return;
            }

            Service service = new Service(serviceName.trim(), description, price, "active", category, image);
            boolean success = serviceDAO.insertService(service);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Thêm dịch vụ thành công\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Thêm dịch vụ thất bại\"}");
            }
            out.flush();
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Giá dịch vụ không hợp lệ");
        }
    }

    /**
     * Cập nhật dịch vụ
     */
    private void handleUpdateService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String serviceIdStr = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");
        String category = request.getParameter("category");
        String image = request.getParameter("image");
        
        if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID dịch vụ");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            double price = Double.parseDouble(priceStr);
            
            Service service = new Service(serviceId, serviceName, description, price, status, category, image);
            boolean success = serviceDAO.updateService(service);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Cập nhật dịch vụ thành công\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Cập nhật dịch vụ thất bại\"}");
            }
            out.flush();
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ");
        }
    }

    /**
     * Xóa dịch vụ (set status = inactive)
     */
    private void handleDeleteService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String serviceIdStr = request.getParameter("serviceId");
        if (serviceIdStr == null || serviceIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID dịch vụ");
            return;
        }

        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            boolean success = serviceDAO.deleteService(serviceId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Xóa dịch vụ thành công\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Xóa dịch vụ thất bại\"}");
            }
            out.flush();
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID dịch vụ không hợp lệ");
        }
    }
} 