package Controller;

import Model.Appointment;
import Model.DoctorDB;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Servlet xử lý yêu cầu lấy danh sách cuộc hẹn của bác sĩ dựa trên userId từ
 * session. Yêu cầu người dùng phải đăng nhập với vai trò DOCTOR để truy cập.
 * Chuyển tiếp danh sách cuộc hẹn đến lichkham.jsp để hiển thị.
 */
public class DoctorAppointmentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Xử lý yêu cầu GET để lấy danh sách cuộc hẹn của bác sĩ.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException nếu có lỗi liên quan đến servlet
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("Debug: Session null hoặc user không tồn tại");
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        // Kiểm tra vai trò người dùng
        User user = (User) session.getAttribute("user");
        if (!"DOCTOR".equalsIgnoreCase(user.getRole())) {
            System.out.println("Debug: User không phải DOCTOR, role=" + user.getRole());
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        try {
            // Lấy doctorId và lấy danh sách cuộc hẹn
            int doctorId = user.getUserId();
            System.out.println("Debug: Doctor ID = " + doctorId);
            List<Appointment> appointments = DoctorDB.getAppointmentsByDoctorId(doctorId);

            // Kiểm tra dữ liệu
            if (appointments == null) {
                System.out.println("Debug: appointments là null");
                request.setAttribute("message", "Lỗi: Không lấy được danh sách cuộc hẹn.");
            } else if (appointments.isEmpty()) {
                System.out.println("Debug: appointments rỗng");
                request.setAttribute("message", "Không có cuộc hẹn nào cho bác sĩ này.");
            } else {
                System.out.println("Debug: Số cuộc hẹn = " + appointments.size());
                request.setAttribute("appointments", appointments);
            }

            // Chuyển tiếp đến lichkham.jsp
            System.out.println("Debug: Chuyển tiếp đến lichkham.jsp");
            request.getRequestDispatcher("lichkham.jsp").forward(request, response);

        } catch (Exception e) {
            // Xử lý lỗi
            System.err.println("Lỗi trong DoctorAppointmentsServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy danh sách cuộc hẹn: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý yêu cầu POST bằng cách chuyển hướng đến doGet.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException nếu có lỗi liên quan đến servlet
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Mô tả ngắn về servlet.
     *
     * @return mô tả của servlet
     */
    @Override
    public String getServletInfo() {
        return "Servlet hiển thị danh sách cuộc hẹn của bác sĩ";
    }
}
