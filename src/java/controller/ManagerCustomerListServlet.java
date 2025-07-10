package controller;

import dao.PatientDAO;
import model.Patients;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ManagerCustomerListServlet")
public class ManagerCustomerListServlet extends HttpServlet {
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Lấy tham số page từ request, mặc định là 1
        int page = 1;
        int recordsPerPage = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Tính toán offset cho phân trang
        int offset = (page - 1) * recordsPerPage;
        
        try {
            // Lấy danh sách bệnh nhân với phân trang
            List<Patients> patientList = patientDAO.getAllPatientsWithPagination(offset, recordsPerPage);
            
            // Lấy tổng số bệnh nhân
            int totalCustomers = patientDAO.getTotalPatients();
            
            // Tính số trang
            int totalPages = (int) Math.ceil((double) totalCustomers / recordsPerPage);
            
            // Lấy số khách hàng hoạt động (giả sử tất cả đều hoạt động)
            int activeCustomers = patientDAO.getActivePatients();
            
            // Lấy số khách hàng mới trong tháng
            int newCustomersThisMonth = patientDAO.getNewPatientsThisMonth();
            
            // Set attributes cho JSP
            request.setAttribute("patientList", patientList);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("activeCustomers", activeCustomers);
            request.setAttribute("newCustomersThisMonth", newCustomersThisMonth);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            
            // Forward đến JSP
            request.getRequestDispatcher("manager_customers.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Lỗi khi tải danh sách khách hàng: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}