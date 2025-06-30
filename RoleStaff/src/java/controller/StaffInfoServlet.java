package controller;

import dao.StaffDAO;
import model.Staff;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class StaffInfoServlet extends HttpServlet {
   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String idParam = request.getParameter("id");
    response.setContentType("text/html;charset=UTF-8");
    try (PrintWriter out = response.getWriter()) {
        // Nếu không có id hoặc id = 0 thì chuyển về trang đăng nhập
        if (idParam == null || idParam.equals("0")) {
            response.sendRedirect("login.jsp");
            return;
        }
        long userId = Long.parseLong(idParam);
        Staff staff = new StaffDAO().getStaffByUserId(userId);
        if (staff == null) {
            out.println("Không tìm thấy staff!");
        } else {
            out.println("<h1>Thông tin Staff</h1>");
            out.println("<ul>");
            out.println("<li>ID: " + staff.getStaff_id() + "</li>");
            out.println("<li>Họ tên: " + staff.getFull_name() + "</li>");
            out.println("<li>Số điện thoại: " + staff.getPhone() + "</li>");
            out.println("<li>Địa chỉ: " + staff.getAddress() + "</li>");
            out.println("<li>Ngày sinh: " + staff.getDate_of_birth() + "</li>");
            out.println("<li>Giới tính: " + staff.getGender() + "</li>");
            out.println("<li>Chức vụ: " + staff.getPosition() + "</li>");
            out.println("</ul>");
        }
    } catch (Exception e) {
        response.getWriter().println("Lỗi: " + e.getMessage());
    }
}
}