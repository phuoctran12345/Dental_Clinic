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

import java.util.List;

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

    /*-------------------------------------------------------------*/
    public static Doctors getInforDoctor(int userId) throws SQLException {
        Doctors doctor = null;
        String sql = """
            SELECT doctor_id, user_id, full_name, phone, address, date_of_birth, gender,
                   specialty, license_number, status, created_at, avatar
            FROM Doctors
            WHERE user_id = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập tham số cho truy vấn
            ps.setInt(1, userId);

            // Thực thi truy vấn và lấy kết quả
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    doctor = new Doctors();
                    doctor.setDoctorId(rs.getInt("doctor_id"));
                    doctor.setUserId(rs.getInt("user_id"));
                    doctor.setFullName(rs.getString("full_name"));
                    doctor.setPhone(rs.getString("phone"));
                    doctor.setAddress(rs.getString("address"));
                    doctor.setDateOfBirth(rs.getDate("date_of_birth"));
                    doctor.setGender(rs.getString("gender"));
                    doctor.setSpecialty(rs.getString("specialty"));
                    doctor.setLicenseNumber(rs.getString("license_number"));
                    doctor.setStatus(rs.getString("status"));
                    doctor.setCreatedAt(rs.getTimestamp("created_at"));
                    doctor.setAvatar(rs.getString("avatar"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getInforDoctor: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return doctor;
    }

    /*-------------------------------------------------------------*/
    public static boolean updateDoctor(Doctors doctor) throws SQLException {
        String sql = """
            UPDATE Doctors
            SET full_name = ?, phone = ?, address = ?, date_of_birth = ?, 
                gender = ?, specialty = ?, license_number = ?, status = ?, avatar = ?
            WHERE user_id = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Thiết lập các tham số cho truy vấn
            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getPhone());
            ps.setString(3, doctor.getAddress());
            ps.setDate(4, (Date) doctor.getDateOfBirth());
            ps.setString(5, doctor.getGender());
            ps.setString(6, doctor.getSpecialty());
            ps.setString(7, doctor.getLicenseNumber());
            ps.setString(8, doctor.getStatus());
            ps.setString(9, doctor.getAvatar());
            ps.setInt(10, doctor.getUserId());

            // Thực thi cập nhật
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in updateDoctor: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /*-------------------------------------------------------------*/
    public static boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ? AND role = 'doctor'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /*-------------------------------------------------------------*/
    public static List<Appointment> getAppointmentsByDoctorId(int doctorId) {
//    if (doctorId <= 0) {
//        throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
//    }

        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT appointment_id, patient_id, doctor_id, work_date, slot_id, status, reason "
                + "FROM Appointment WHERE doctor_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setPatientId(rs.getInt("patient_id"));
                    a.setDoctorId(doctorId);
                    a.setWorkDate(rs.getDate("work_date"));
                    a.setSlotId(rs.getInt("slot_id"));
                    a.setStatus(rs.getString("status"));
                    a.setReason(rs.getString("reason"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy danh sách cuộc hẹn: " + e.getMessage());
            throw new RuntimeException("Không thể lấy danh sách cuộc hẹn cho doctorId: " + doctorId, e);
        }

        return list;
    }
    

    public int insertMedicalReport(int appointmentId, long doctorId, int patientId,
            String diagnosis, String treatmentPlan, String note, String sign) throws SQLException {
        String sql = "INSERT INTO MedicalReport (appointment_id, doctor_id, patient_id, diagnosis, treatment_plan, note, sign) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, appointmentId);
            ps.setLong(2, doctorId);
            ps.setInt(3, patientId);
            ps.setString(4, diagnosis);
            ps.setString(5, treatmentPlan);
            ps.setString(6, note);
            ps.setString(7, sign);

            ps.executeUpdate();

            // Lấy report_id vừa insert
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1; // lỗi
    }

    // Thêm đơn thuốc gắn với báo cáo
    public void insertPrescription(int reportId, int medicineId, int quantity, String usage) throws SQLException {
        String sql = "INSERT INTO Prescription (report_id, medicine_id, quantity, usage) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reportId);
            ps.setInt(2, medicineId);
            ps.setInt(3, quantity);
            ps.setString(4, usage);
            ps.executeUpdate();
        }
    }

    public static List<Medicine> getAllMedicine() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM Medicine";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineId(rs.getInt("medicine_id"));
                m.setName(rs.getString("name"));
                m.setUnit(rs.getString("unit"));
                m.setQuantityInStock(rs.getInt("quantity_in_stock"));
                m.setDescription(rs.getString("description"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean hasEnoughStock(int medicineId, int requiredQty) throws SQLException {
        String sql = "SELECT quantity_in_stock FROM Medicine WHERE medicine_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int currentStock = rs.getInt("quantity_in_stock");
                return currentStock >= requiredQty;
            }
        }
        return false;
    }

    public void reduceMedicineStock(int medicineId, int quantity) throws SQLException {
        String sql = "UPDATE Medicine SET quantity_in_stock = quantity_in_stock - ? WHERE medicine_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, medicineId);
            ps.executeUpdate();
        }
    }

    public void updateAppointmentStatus(int appointmentId, String status) throws SQLException {
        String sql = "UPDATE Appointment SET status = ? WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        }
    }

}
