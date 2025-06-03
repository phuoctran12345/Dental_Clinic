/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import static Model.DBConnection.getConnection;
import static Model.DatabaseInfo.DBURL;
import static Model.DatabaseInfo.DRIVERNAME;
import static Model.DatabaseInfo.PASSDB;
import static Model.DatabaseInfo.USERDB;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Map;
import java.util.HashMap;

public class DoctorDB implements DatabaseInfo {

    public static Connection getConnect() {
        try {
            Class.forName(DRIVERNAME);
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading driver" + e);
        }
        try {
            Connection con = DriverManager.getConnection(DBURL, USERDB, PASSDB);
            return con;
        } catch (SQLException e) {
            System.out.println("Error: " + e);
        }
        return null;
    }
    //-----------------------------------------------------------------------------------------

    public static User getUserByEmailAndPassword(String email, String passwordHash) {
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("user_id"),
                        rs.getString("password_hash"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at")
                );
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public static boolean isPatientExists(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Checking existence for email: " + email);
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                boolean exists = rs.next();
                System.out.println("Exists? " + exists);
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm khách hàng mới vào database
    public static int registerPatient(String email, String passwordHash) {
        String sql = "INSERT INTO Users (email, password_hash, role) VALUES (?, ?, 'PATIENT')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về int user_id
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public static boolean savePatientInfo(int userId, String fullName, String phone, String dateOfBirth, String gender) {
        String sql = "INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, fullName);
            ps.setString(3, phone);
            ps.setString(4, dateOfBirth); // yyyy-MM-dd
            ps.setString(5, gender);

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //--------------------------------------------------------------------------------------------//
    public static Patients getPatientByUserId(int userId) {
        Patients patients = null;
        String sql = "SELECT patient_id, user_id, full_name, phone, date_of_birth, gender "
                + "FROM Patients WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                patients = new Patients();
                patients.setPatientId(rs.getInt("patient_id"));
                patients.setUserId(rs.getInt("user_id"));
                patients.setFullName(rs.getString("full_name"));
                patients.setPhone(rs.getString("phone"));  // sửa chính tả
                patients.setDateOfBirth(rs.getDate("date_of_birth"));
                patients.setGender(rs.getString("gender"));
                patients.setCreatedAt(rs.getDate("created_at"));  // nếu có trường này trong DB

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;  // sửa tên biến trả về
    }

    //--------------------------------------------------------------------------------------------
    public static List<Doctors> getAllDoctorsOnline() {
        List<Doctors> list = new ArrayList<>();
        String sql = "SELECT * FROM Doctors WHERE status = 'Active'";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctors doctor = new Doctors();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setFullName(rs.getString("full_name"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setAddress(rs.getString("address"));
                doctor.setDateOfBirth(rs.getDate("date_of_birth"));
                doctor.setGender(rs.getString("gender"));

                doctor.setSpecialty(rs.getString("specialty"));
                doctor.setLicenseNumber(rs.getString("license_number"));
                doctor.setCreatedAt(rs.getDate("created_at"));
                doctor.setStatus(rs.getString("status"));
                doctor.setAvatar(rs.getString("avatar"));

                list.add(doctor);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

//    
    public static Doctors getDoctorById(int doctorId) throws SQLException {
        Doctors doctor = null;

        String sql = "SELECT doctor_id, full_name, specialty, phone, status FROM Doctors WHERE doctor_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                doctor = new Doctors();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setFullName(rs.getString("full_name"));
                doctor.setSpecialty(rs.getString("specialty"));
                doctor.setPhone(rs.getString("phone"));
                doctor.setStatus(rs.getString("status"));
            }
        }
        return doctor;
    }

    public static Doctors getDoctorByUserId(int userId) {
        // Logic để lấy thông tin bác sĩ từ cơ sở dữ liệu dựa trên userId
        // Ví dụ: Truy vấn SQL để lấy bác sĩ từ bảng Doctors
        Doctors doctor = null;
        try {
            // Kết nối đến cơ sở dữ liệu (giả sử bạn đã có kết nối sẵn)
            Connection conn = getConnection(); // Hàm lấy kết nối, bạn cần định nghĩa
            String sql = "SELECT * FROM Doctors WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                doctor = new Doctors();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                // Đặt các thuộc tính khác của đối tượng Doctors nếu cần
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctor;
    }

//    public static List<Integer> getWorkDaysByMonth(int doctorId, int year, int month) throws SQLException {
//        List<Integer> workDays = new ArrayList<>();
//        String sql = "SELECT DISTINCT DAY(work_date) as day FROM DoctorSchedule "
//                + "WHERE doctor_id = ? AND YEAR(work_date) = ? AND MONTH(work_date) = ?";
//
//        try (Connection conn = getConnect(); PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, doctorId);
//            ps.setInt(2, year);
//            ps.setInt(3, month);
//
//            System.out.println("Đang truy vấn với doctorId: " + doctorId + ", year: " + year + ", month: " + month);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    int day = rs.getInt("day");
//                    workDays.add(day);
//                    System.out.println("Tìm thấy ngày làm việc: " + day);
//                }
//            }
//        } catch (Exception e) {
//            System.out.println("Lỗi khi truy vấn: " + e.getMessage());
//            e.printStackTrace();
//        }
//
//        System.out.println("Tổng số ngày làm việc tìm thấy: " + workDays.size());
//        return workDays;
//    }
//    public static List<DoctorSchedule> getAvailableSchedulesByDoctor(int doctorId) throws SQLException {
//        List<DoctorSchedule> list = new ArrayList<>();
//
//        String sql = "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, "
//                + "ts.start_time, ts.end_time "
//                + "FROM DoctorSchedule ds "
//                + "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id "
//                + "WHERE ds.doctor_id = ? "
//                + "AND NOT EXISTS ("
//                + "    SELECT 1 FROM Appointment ap "
//                + "    WHERE ap.doctor_id = ds.doctor_id "
//                + "      AND ap.work_date = ds.work_date "
//                + "      AND ap.slot_id = ds.slot_id "
//                + "      AND ap.status = N'Đã đặt'"
//                + ")";
//
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, doctorId);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                DoctorSchedule ds = new DoctorSchedule();
//                ds.setScheduleId(rs.getInt("schedule_id"));
//                ds.setDoctorId(rs.getLong("doctor_id"));
//                ds.setWorkDate(rs.getDate("work_date").toLocalDate());
//                ds.setSlotId(rs.getInt("slot_id"));
//
//                TimeSlot ts = new TimeSlot();
//                ts.setStartTime(rs.getTime("start_time").toLocalTime());
//                ts.setEndTime(rs.getTime("end_time").toLocalTime());
//                ds.setTimeSlot(ts);
//
//                list.add(ds);
//            }
//        }
//
//        return list;
//    }
//
//    public static boolean insertAppointment(int scheduleId, int patientId, String workDate, String startTime) {
//        String sql = """
//            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status)
//            SELECT ?, ds.doctor_id, ?, ds.slot_id, N'Đã đặt'
//            FROM DoctorSchedule ds
//            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
//            WHERE ds.schedule_id = ? AND ts.start_time = ?
//        """;
//
//        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, patientId);
//            ps.setString(2, workDate);
//            ps.setInt(3, scheduleId);
//            ps.setString(4, startTime);
//
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//}
//    public static void main(String[] args) {
//    Connection conn = getConnect();
//    if (conn != null) {
//        System.out.println("✅ Kết nối database thành công!");
//        try {
//            conn.close(); // đóng kết nối sau khi kiểm tra
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    } else {
//        System.out.println("❌ Kết nối database thất bại!");
//    }
//}
    //--------------------------------------------------------------------------------------------
    // Các hàm xử lý TimeSlot
    //--------------------------------------------------------------------------------------------
    public List<DoctorSchedule> getAllDoctorSchedules() throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = """
            SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id,
                   d.full_name, d.specialty, d.phone, d.status,
                   ts.start_time, ts.end_time
            FROM DoctorSchedule ds
            JOIN Doctors d ON ds.doctor_id = d.doctor_id
            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
            ORDER BY ds.work_date, ts.start_time
            """;

        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            System.out.println("Executing query: " + sql);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    try {
                        DoctorSchedule schedule = new DoctorSchedule();
                        schedule.setScheduleId(resultSet.getInt("schedule_id"));
                        schedule.setDoctorId(resultSet.getInt("doctor_id"));

                        // Xử lý work_date an toàn
                        Date workDateSql = resultSet.getDate("work_date");
                        if (workDateSql != null) {
                            schedule.setWorkDate(new java.sql.Date(workDateSql.getTime()));
                        }

                        schedule.setSlotId(resultSet.getInt("slot_id"));

                        // Tạo Doctor object
                        Doctors doctor = new Doctors();
                        doctor.setDoctorId(resultSet.getInt("doctor_id"));
                        doctor.setFullName(resultSet.getString("full_name"));
                        doctor.setSpecialty(resultSet.getString("specialty"));
                        doctor.setPhone(resultSet.getString("phone"));
                        doctor.setStatus(resultSet.getString("status"));
                        schedule.setDoctor(doctor);

                        // Tạo TimeSlot object
                        TimeSlot timeSlot = new TimeSlot();
                        timeSlot.setSlotId(resultSet.getInt("slot_id"));

                        // Xử lý time an toàn
                        Time startTimeSql = resultSet.getTime("start_time");
                        Time endTimeSql = resultSet.getTime("end_time");

                        if (startTimeSql != null) {
                            timeSlot.setStartTime(startTimeSql.toLocalTime());
                        }
                        if (endTimeSql != null) {
                            timeSlot.setEndTime(endTimeSql.toLocalTime());
                        }

                        schedule.setTimeSlot(timeSlot);

                        schedules.add(schedule);
                        System.out.println("Added schedule: " + schedule.toString());
                    } catch (Exception e) {
                        System.err.println("Error processing row: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllDoctorSchedules: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        System.out.println("Total schedules found: " + schedules.size());
        return schedules;
    }

    // Lấy lịch làm việc của một bác sĩ cụ thể
    public List<DoctorSchedule> getSchedulesByDoctorId(int doctorId) throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = """
            SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id,
                   d.full_name, d.specialty, d.phone, d.status,
                   ts.start_time, ts.end_time
            FROM DoctorSchedule ds
            JOIN Doctors d ON ds.doctor_id = d.doctor_id
            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
            WHERE ds.doctor_id = ?
            ORDER BY ds.work_date, ts.start_time
            """;

        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            System.out.println("Executing query for doctor ID: " + doctorId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    try {
                        DoctorSchedule schedule = new DoctorSchedule();
                        schedule.setScheduleId(resultSet.getInt("schedule_id"));
                        schedule.setDoctorId(resultSet.getInt("doctor_id"));

                        // Xử lý work_date an toàn
                        Date workDateSql = resultSet.getDate("work_date");
                        if (workDateSql != null) {
                            schedule.setWorkDate(new java.sql.Date(workDateSql.getTime()));
                        }

                        schedule.setSlotId(resultSet.getInt("slot_id"));

                        // Tạo Doctor object
                        Doctors doctor = new Doctors();
                        doctor.setDoctorId(resultSet.getInt("doctor_id"));
                        doctor.setFullName(resultSet.getString("full_name"));
                        doctor.setSpecialty(resultSet.getString("specialty"));
                        doctor.setPhone(resultSet.getString("phone"));
                        doctor.setStatus(resultSet.getString("status"));
                        schedule.setDoctor(doctor);

                        // Tạo TimeSlot object
                        TimeSlot timeSlot = new TimeSlot();
                        timeSlot.setSlotId(resultSet.getInt("slot_id"));

                        // Xử lý time an toàn
                        Time startTimeSql = resultSet.getTime("start_time");
                        Time endTimeSql = resultSet.getTime("end_time");

                        if (startTimeSql != null) {
                            timeSlot.setStartTime(startTimeSql.toLocalTime());
                        }
                        if (endTimeSql != null) {
                            timeSlot.setEndTime(endTimeSql.toLocalTime());
                        }

                        schedule.setTimeSlot(timeSlot);

                        schedules.add(schedule);
                    } catch (Exception e) {
                        System.err.println("Error processing row for doctor " + doctorId + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getSchedulesByDoctorId: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        System.out.println("Schedules found for doctor " + doctorId + ": " + schedules.size());
        return schedules;
    }

    // Lấy lịch làm việc theo ngày
    public List<DoctorSchedule> getSchedulesByDate(LocalDate date) throws SQLException {
        List<DoctorSchedule> schedules = new ArrayList<>();
        String sql = """
            SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id,
                   d.full_name, d.specialty, d.phone, d.status,
                   ts.start_time, ts.end_time
            FROM DoctorSchedule ds
            JOIN Doctors d ON ds.doctor_id = d.doctor_id
            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
            WHERE ds.work_date = ?
            ORDER BY ts.start_time
            """;

        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, Date.valueOf(date));
            System.out.println("Executing query for date: " + date);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    try {
                        DoctorSchedule schedule = new DoctorSchedule();
                        schedule.setScheduleId(resultSet.getInt("schedule_id"));
                        schedule.setDoctorId(resultSet.getInt("doctor_id"));

                        // Xử lý work_date an toàn
                        Date workDateSql = resultSet.getDate("work_date");
                        if (workDateSql != null) {
                            schedule.setWorkDate(new java.sql.Date(workDateSql.getTime()));
                        }

                        schedule.setSlotId(resultSet.getInt("slot_id"));

                        // Tạo Doctor object
                        Doctors doctor = new Doctors();
                        doctor.setDoctorId(resultSet.getInt("doctor_id"));
                        doctor.setFullName(resultSet.getString("full_name"));
                        doctor.setSpecialty(resultSet.getString("specialty"));
                        doctor.setPhone(resultSet.getString("phone"));
                        doctor.setStatus(resultSet.getString("status"));
                        schedule.setDoctor(doctor);

                        // Tạo TimeSlot object
                        TimeSlot timeSlot = new TimeSlot();
                        timeSlot.setSlotId(resultSet.getInt("slot_id"));

                        // Xử lý time an toàn
                        Time startTimeSql = resultSet.getTime("start_time");
                        Time endTimeSql = resultSet.getTime("end_time");

                        if (startTimeSql != null) {
                            timeSlot.setStartTime(startTimeSql.toLocalTime());
                        }
                        if (endTimeSql != null) {
                            timeSlot.setEndTime(endTimeSql.toLocalTime());
                        }

                        schedule.setTimeSlot(timeSlot);

                        schedules.add(schedule);
                    } catch (Exception e) {
                        System.err.println("Error processing row for date " + date + ": " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getSchedulesByDate: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        System.out.println("Schedules found for date " + date + ": " + schedules.size());
        return schedules;
    }

    // Lấy tất cả bác sĩ
    public List<Doctors> getAllDoctors() throws SQLException {
        List<Doctors> doctors = new ArrayList<>();
        String sql = "SELECT doctor_id, full_name, specialty, phone, status FROM Doctors WHERE status = N'Đang hoạt động'";

        try (Connection connection = DBConnection.getConnection(); PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Doctors doctor = new Doctors();
                doctor.setDoctorId(resultSet.getInt("doctor_id"));
                doctor.setFullName(resultSet.getString("full_name"));
                doctor.setSpecialty(resultSet.getString("specialty"));
                doctor.setPhone(resultSet.getString("phone"));
                doctor.setStatus(resultSet.getString("status"));
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllDoctors: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        System.out.println("Total doctors found: " + doctors.size());
        return doctors;
    }

}
