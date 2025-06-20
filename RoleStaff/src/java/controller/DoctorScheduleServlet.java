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
//@WebServlet(name = "DoctorScheduleServlet", urlPatterns = {"/doctor_schedule"})
public class DoctorScheduleServlet extends HttpServlet {
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
    int slotId = Integer.parseInt(request.getParameter("slot_id"));
    DoctorSchedule schedule = new DoctorSchedule();
    schedule.setDoctorId(doctorId);
    schedule.setWorkDate(workDate);
    schedule.setSlotId(slotId);
    scheduleDAO.addSchedule(schedule);

    // Sau khi đăng ký xong, chuyển hướng về lại trang đăng ký và truyền doctor_id để hiển thị lịch vừa đăng ký
    response.sendRedirect(request.getContextPath() + "/DoctorScheduleServlet?doctor_id=" + doctorId);
}
} 
