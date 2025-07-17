/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.DoctorScheduleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.DoctorSchedule;


/**
 *
 * @author tranhongphuoc
 * 
 */
//@WebServlet(name = "DoctorRegisterScheduleServlet", urlPatterns = {"/DoctorRegisterScheduleServlet"})

@WebServlet(name = "DoctorRegisterScheduleServlet", urlPatterns = {"/DoctorRegisterScheduleServlet"})
public class DoctorRegisterScheduleServlet extends HttpServlet {
    private DoctorScheduleDAO scheduleDAO;

      // Danh sách ca làm việc cố định
    private static final List<Map<String, Object>> SHIFTS = new ArrayList<>();
    static {
        Map<String, Object> caSang = new HashMap<>();
        caSang.put("slotId", 1);
        caSang.put("name", "Sáng (8h-12h)");
        SHIFTS.add(caSang);
        Map<String, Object> caChieu = new HashMap<>();
        caChieu.put("slotId", 2);
        caChieu.put("name", "Chiều (13h-17h)");
        SHIFTS.add(caChieu);
        Map<String, Object> caCaNgay = new HashMap<>();
        caCaNgay.put("slotId", 3);
        caCaNgay.put("name", "Cả ngày (8h-17h)");
        SHIFTS.add(caCaNgay);
    }

    @Override
    public void init() throws ServletException {
        scheduleDAO = new DoctorScheduleDAO();
    }
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setAttribute("shifts", SHIFTS);

    String doctorIdParam = request.getParameter("doctor_id");
    HttpSession session = request.getSession();
    Long doctorId = null;
    if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
        doctorId = Long.parseLong(doctorIdParam);
        session.setAttribute("doctor_id", doctorId);
    } else {
        Object doctorIdObj = session.getAttribute("doctor_id");
        if (doctorIdObj instanceof Integer) {
            doctorId = ((Integer) doctorIdObj).longValue();
        } else if (doctorIdObj instanceof Long) {
            doctorId = (Long) doctorIdObj;
        }
    }
    System.out.println("doctor_id in session: " + doctorId);
    // ✅ LOGIC MỚI: DoctorSchedule chỉ lưu LỊCH NGHỈ, không cần tự động tạo lịch làm việc
    // Mặc định bác sĩ làm việc tất cả ngày, chỉ nghỉ khi có bản ghi trong DoctorSchedule
    if (doctorId != null) {
        System.out.println("💡 Bác sĩ " + doctorId + " mặc định làm việc tất cả ngày, trừ ngày có đăng ký nghỉ");
        // scheduleDAO.autoGenerateFullDaySchedules(doctorId); // ❌ DEPRECATED - đã xóa
    }
    List<DoctorSchedule> schedules = new ArrayList<>();
    List<DoctorSchedule> approvedSchedules = new ArrayList<>();
    if (doctorId != null) {
        schedules = scheduleDAO.getSchedulesByDoctorId(doctorId);
        approvedSchedules = scheduleDAO.getApprovedSchedulesByDoctorId(doctorId);
        for (DoctorSchedule s : schedules) {
            if (s.getSlotId() == 1) s.setStatus("Sáng (8h-12h)");
            else if (s.getSlotId() == 2) s.setStatus("Chiều (13h-17h)");
            else if (s.getSlotId() == 3) s.setStatus("Cả ngày (8h-17h)");
        }
    }
    request.setAttribute("schedules", schedules);
    request.setAttribute("approvedSchedules", approvedSchedules);

    String page = request.getParameter("page");
    if ("calendar".equals(page)) {
        request.getRequestDispatcher("/jsp/doctor/doctor_lichtrongthang.jsp").forward(request, response);
        return;
    } else {
    request.getRequestDispatcher("/jsp/doctor/doctor_dangkilich.jsp").forward(request, response);
        return;
    }
}

     @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    long doctorId = Long.parseLong(request.getParameter("doctor_id"));
    Date workDate = Date.valueOf(request.getParameter("work_date"));
    String requestType = request.getParameter("request_type");
    
    // Lấy thêm tham số mới
    String leaveType = request.getParameter("leaveType");
    String reason = request.getParameter("reason");
    
    DoctorSchedule schedule = new DoctorSchedule();
    schedule.setDoctorId(doctorId);
    schedule.setWorkDate(workDate);
    
    if ("leave".equals(requestType)) {
        // Đăng ký nghỉ phép cho bác sĩ fulltime
        schedule.setSlotId((Integer) null); // nghỉ phép
        schedule.setStatus("pending");
        System.out.println("[DEBUG] Đăng ký nghỉ phép cho doctorId=" + doctorId + ", workDate=" + workDate + ", leaveType=" + leaveType + ", reason=" + reason);
        
    } else {
        // Đăng ký ca làm cho bác sĩ parttime
        String slotIdParam = request.getParameter("slot_id");
        if (slotIdParam != null && !slotIdParam.isEmpty()) {
            int slotId = Integer.parseInt(slotIdParam);
            schedule.setSlotId(slotId);
        } else {
            schedule.setSlotId((Integer) null);
        }
        schedule.setStatus("pending");
        System.out.println("[DEBUG] Đăng ký ca làm cho doctorId=" + doctorId + ", workDate=" + workDate + ", slotId=" + schedule.getSlotId());
    }
    scheduleDAO.addSchedule(schedule);
    // Sau khi đăng ký xong, chuyển hướng về lại trang đăng ký và truyền doctor_id để hiển thị lịch vừa đăng ký
    response.sendRedirect(request.getContextPath() + "/DoctorRegisterScheduleServlet?doctor_id=" + doctorId);
}
} 
