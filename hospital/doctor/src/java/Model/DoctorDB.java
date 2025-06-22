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

    /**
     * ⚠️ NGUY HIỂM: Đăng nhập với mật khẩu KHÔNG mã hóa - CHỈ DÙNG ĐỂ TEST!
     */
    public static User getUserByEmailAndPasswordPlainText(String email, String password) {
        System.out.println("⚠️ [CẢNH BÁO] Đang đăng nhập với plain text - NGUY HIỂM!");
        System.out.println("📧 Email: " + email);
        System.out.println("🔓 Plain password: " + password);
        
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // So sánh trực tiếp với plain text
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("user_id"),
                        rs.getString("password_hash"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at")
                );
                System.out.println("✅ Đăng nhập plain text thành công!");
            } else {
                System.err.println("❌ Đăng nhập thất bại");
            }

            conn.close();
        } catch (Exception e) {
            System.err.println("❌ Lỗi SQL: " + e.getMessage());
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

    /**
     * Lấy thông tin bệnh nhân từ patient_id
     */
    public static Patients getPatientByPatientId(int patientId) {
        Patients patient = null;
        String sql = "SELECT * FROM Patients WHERE patient_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setPhone(rs.getString("phone"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patient;
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
        Doctors doctor = null;
        try {
            // Kết nối đến cơ sở dữ liệu
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Doctors WHERE user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

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
                
                System.out.println("Found doctor: " + doctor.getFullName() + " - " + doctor.getSpecialty());
            } else {
                System.out.println("No doctor found with user_id: " + userId);
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            System.err.println("Error in getDoctorByUserId: " + e.getMessage());
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
    public List<Appointment> getAppointmentsByUserId(int userId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        
        // Sửa lại query để phù hợp với database schema
        // Lấy appointments cho doctor dựa trên userId -> doctorId
        String query = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason
            FROM Appointment a
            INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
            WHERE d.user_id = ?
            ORDER BY a.work_date DESC, a.slot_id ASC
        """;

        System.out.println("Executing query for userId: " + userId);
        System.out.println("Query: " + query);

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            // Thiết lập tham số userId trong câu truy vấn
            stmt.setInt(1, userId);

            // Thực thi câu truy vấn
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    // Tạo một đối tượng Appointment mới cho mỗi bản ghi
                    Appointment appointment = new Appointment();
                    appointment.setAppointmentId(rs.getInt("appointment_id"));
                    appointment.setPatientId(rs.getInt("patient_id"));
                    appointment.setDoctorId(rs.getInt("doctor_id"));
                    appointment.setWorkDate(rs.getDate("work_date"));
                    appointment.setSlotId(rs.getInt("slot_id"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setReason(rs.getString("reason"));
//                     appointment.setPreviousAppointmentId(rs.getInt("previousAppointmentId")); 

                    // Thêm cuộc hẹn vào danh sách
                    appointments.add(appointment);
                    
                    System.out.println("Added appointment: ID=" + appointment.getAppointmentId() + 
                                     ", Patient=" + appointment.getPatientId() + 
                                     ", Date=" + appointment.getWorkDate());
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in getAppointmentsByUserId: " + e.getMessage());
            e.printStackTrace();
            // Xử lý hoặc ghi log lỗi nếu cần
            throw new SQLException("Lỗi khi lấy danh sách cuộc hẹn cho userId: " + userId, e);
        }

        System.out.println("Returning " + appointments.size() + " appointments");
        return appointments;
    }

    

    public int insertMedicalReport(int appointmentId, int doctorId, int patientId,
            String diagnosis, String treatmentPlan, String note, String sign) throws SQLException {
        String sql = "INSERT INTO MedicalReport (appointment_id, doctor_id, patient_id, diagnosis, treatment_plan, note, sign) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, appointmentId);
            ps.setInt(2, doctorId);
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

    /*-------------------------------------------------------------*/
    /* CÁC HÀM XEM BÁO CÁO Y TẾ */
    /*-------------------------------------------------------------*/
    
    /**
     * Lấy Medical Report theo ID
     */
    public static MedicalReport getMedicalReportById(int reportId) throws SQLException {
        String sql = "SELECT * FROM MedicalReport WHERE report_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                MedicalReport report = new MedicalReport();
                report.setReportId(rs.getInt("report_id"));
                report.setAppointmentId(rs.getInt("appointment_id"));
                report.setDoctorId(rs.getInt("doctor_id"));
                report.setPatientId(rs.getInt("patient_id"));
                report.setDiagnosis(rs.getString("diagnosis"));
                report.setTreatmentPlan(rs.getString("treatment_plan"));
                report.setNote(rs.getString("note"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setSign(rs.getString("sign"));
                return report;
            }
        }
        return null;
    }
    
    /**
     * Lấy Medical Report theo Appointment ID
     */
    public static MedicalReport getMedicalReportByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT * FROM MedicalReport WHERE appointment_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                MedicalReport report = new MedicalReport();
                report.setReportId(rs.getInt("report_id"));
                report.setAppointmentId(rs.getInt("appointment_id"));
                report.setDoctorId(rs.getInt("doctor_id"));
                report.setPatientId(rs.getInt("patient_id"));
                report.setDiagnosis(rs.getString("diagnosis"));
                report.setTreatmentPlan(rs.getString("treatment_plan"));
                report.setNote(rs.getString("note"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setSign(rs.getString("sign"));
                return report;
            }
        }
        return null;
    }
    
    /**
     * Lấy danh sách PrescriptionDetail theo Report ID
     */
    public static List<PrescriptionDetail> getPrescriptionsByReportId(int reportId) throws SQLException {
        List<PrescriptionDetail> prescriptions = new ArrayList<>();
        String sql = """
            SELECT p.prescription_id, p.quantity, p.usage,
                   m.medicine_id, m.name as medicine_name, m.unit
            FROM Prescription p
            JOIN Medicine m ON p.medicine_id = m.medicine_id
            WHERE p.report_id = ?
            ORDER BY p.prescription_id
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                PrescriptionDetail detail = new PrescriptionDetail();
                detail.setPrescriptionId(rs.getInt("prescription_id"));
                detail.setMedicineId(rs.getInt("medicine_id"));
                detail.setMedicineName(rs.getString("medicine_name"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setUnit(rs.getString("unit"));
                detail.setUsage(rs.getString("usage"));
                prescriptions.add(detail);
            }
        }
        return prescriptions;
    }
    
    /**
     * Lấy thông tin TimeSlot từ Appointment ID
     */
    public static String getTimeSlotByAppointmentId(int appointmentId) throws SQLException {
        String sql = """
            SELECT ts.start_time, ts.end_time
            FROM Appointment a
            JOIN TimeSlot ts ON a.slot_id = ts.slot_id
            WHERE a.appointment_id = ?
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getTime("start_time") + " - " + rs.getTime("end_time");
            }
        }
        return "N/A";
    }
    
    /**
     * Lấy tất cả Medical Reports của một bác sĩ
     */
    public static List<MedicalReport> getMedicalReportsByDoctorId(int doctorId) throws SQLException {
        List<MedicalReport> reports = new ArrayList<>();
        String sql = """
            SELECT mr.*, a.work_date
            FROM MedicalReport mr
            JOIN Appointment a ON mr.appointment_id = a.appointment_id
            WHERE mr.doctor_id = ?
            ORDER BY mr.created_at DESC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                MedicalReport report = new MedicalReport();
                report.setReportId(rs.getInt("report_id"));
                report.setAppointmentId(rs.getInt("appointment_id"));
                report.setDoctorId(rs.getInt("doctor_id"));
                report.setPatientId(rs.getInt("patient_id"));
                report.setDiagnosis(rs.getString("diagnosis"));
                report.setTreatmentPlan(rs.getString("treatment_plan"));
                report.setNote(rs.getString("note"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setSign(rs.getString("sign"));
                reports.add(report);
            }
        }
        return reports;
    }
    
    /**
     * Kiểm tra xem một appointment đã có medical report chưa
     */
    public static boolean hasMedialReport(int appointmentId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM MedicalReport WHERE appointment_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        }
        return false;
    }
    
    /**
     * Cập nhật Medical Report
     */
    public static boolean updateMedicalReport(MedicalReport report) throws SQLException {
        String sql = """
            UPDATE MedicalReport 
            SET diagnosis = ?, treatment_plan = ?, note = ?, sign = ?
            WHERE report_id = ?
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, report.getDiagnosis());
            ps.setString(2, report.getTreatmentPlan());
            ps.setString(3, report.getNote());
            ps.setString(4, report.getSign());
            ps.setInt(5, report.getReportId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    /**
     * Xóa Medical Report và các prescription liên quan
     */
    public static boolean deleteMedicalReport(int reportId) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // Xóa prescriptions trước
            String deletePrescriptionsSql = "DELETE FROM Prescription WHERE report_id = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(deletePrescriptionsSql)) {
                ps1.setInt(1, reportId);
                ps1.executeUpdate();
            }
            
            // Xóa medical report
            String deleteReportSql = "DELETE FROM MedicalReport WHERE report_id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(deleteReportSql)) {
                ps2.setInt(1, reportId);
                int rowsAffected = ps2.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit(); // Commit transaction
                    return true;
                } else {
                    conn.rollback(); // Rollback nếu không xóa được
                    return false;
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Rollback trong trường hợp lỗi
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true); // Reset auto commit
                conn.close();
            }
        }
    }

    /*-------------------------------------------------------------*/
    /* CÁC HÀM HỖ TRỢ CHỨC NĂNG TÁI KHÁM */
    /*-------------------------------------------------------------*/
    
    /**
     * Lấy danh sách cuộc hẹn đã hoàn tất của bác sĩ (để tái khám)
     */
    public static List<Appointment> getCompletedAppointmentsByDoctorId(int doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT DISTINCT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.doctor_id = ? AND a.status = N'Hoàn tất'
            AND NOT EXISTS (
                SELECT 1 FROM Appointment a2 
                WHERE a2.previous_appointment_id = a.appointment_id
            )
            ORDER BY a.work_date DESC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                appointment.setPreviousAppointmentId(rs.getInt("previous_appointment_id"));
                
                // Thêm thông tin bệnh nhân và slot time
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));
                appointment.setStartTime(rs.getTime("start_time"));
                appointment.setEndTime(rs.getTime("end_time"));
                
                appointments.add(appointment);
            }
        }
        
        return appointments;
    }
    
    /**
     * Kiểm tra xem khung giờ có còn trống không
     */
    public static boolean isSlotAvailable(int doctorId, String workDate, int slotId) throws SQLException {
        String sql = """
            SELECT COUNT(*) as count 
            FROM Appointment 
            WHERE doctor_id = ? AND work_date = ? AND slot_id = ? 
            AND status IN (N'Đã đặt', N'Hoàn tất')
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setString(2, workDate);
            ps.setInt(3, slotId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") == 0;
            }
        }
        
        return false;
    }
    
    /**
     * Tạo lịch hẹn tái khám mới
     */
    public static boolean createReexaminationAppointment(int patientId, int doctorId, 
            String workDate, int slotId, String reason, int previousAppointmentId) throws SQLException {
        
        String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status, reason, previous_appointment_id)
            VALUES (?, ?, ?, ?, N'Đã đặt', ?, ?)
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ps.setInt(2, doctorId);
            ps.setString(3, workDate);
            ps.setInt(4, slotId);
            ps.setString(5, reason);
            ps.setInt(6, previousAppointmentId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    /**
     * Lấy tất cả khung giờ
     */
    public static List<TimeSlot> getAllTimeSlots() throws SQLException {
        List<TimeSlot> timeSlots = new ArrayList<>();
        String sql = "SELECT * FROM TimeSlot ORDER BY start_time";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TimeSlot timeSlot = new TimeSlot();
                timeSlot.setSlotId(rs.getInt("slot_id"));
                
                // Convert java.sql.Time to LocalTime
                Time startTimeSql = rs.getTime("start_time");
                Time endTimeSql = rs.getTime("end_time");
                
                if (startTimeSql != null) {
                    timeSlot.setStartTime(startTimeSql.toLocalTime());
                }
                if (endTimeSql != null) {
                    timeSlot.setEndTime(endTimeSql.toLocalTime());
                }
                
                timeSlots.add(timeSlot);
            }
        }
        
        return timeSlots;
    }
    
    /**
     * Lấy thông tin chi tiết của một cuộc hẹn (bao gồm thông tin bệnh nhân)
     */
    public static Appointment getAppointmentWithPatientInfo(int appointmentId) throws SQLException {
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.appointment_id = ?
        """;
        
        System.out.println("DEBUG - getAppointmentWithPatientInfo for appointmentId: " + appointmentId);
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Handle null previous_appointment_id
                int prevAppId = rs.getInt("previous_appointment_id");
                if (!rs.wasNull()) {
                    appointment.setPreviousAppointmentId(prevAppId);
                }
                
                // Thông tin bệnh nhân
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));
                appointment.setStartTime(rs.getTime("start_time"));
                appointment.setEndTime(rs.getTime("end_time"));
                
                System.out.println("DEBUG - Found appointment: patient_id=" + appointment.getPatientId() + 
                                 ", patient_name=" + appointment.getPatientName());
                
                return appointment;
            } else {
                System.out.println("DEBUG - No appointment found with ID: " + appointmentId);
            }
        }
        
        return null;
    }

    /*-------------------------------------------------------------*/
    /* HÀM LẤY APPOINTMENT CHO DASHBOARD */
    /*-------------------------------------------------------------*/
    
    /**
     * Lấy danh sách cuộc hẹn hôm nay của bác sĩ kèm thông tin bệnh nhân
     */
    public static List<Appointment> getTodayAppointmentsByDoctorId(int doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.doctor_id = ? AND CAST(a.work_date AS DATE) = CAST(GETDATE() AS DATE)
            ORDER BY t.start_time ASC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Handle null previous_appointment_id
                int prevAppId = rs.getInt("previous_appointment_id");
                if (!rs.wasNull()) {
                    appointment.setPreviousAppointmentId(prevAppId);
                }
                
                // Thông tin bệnh nhân
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));
                appointment.setStartTime(rs.getTime("start_time"));
                appointment.setEndTime(rs.getTime("end_time"));
                
                appointments.add(appointment);
            }
        }
        
        return appointments;
    }

    /**
     * Lấy danh sách cuộc hẹn đang chờ khám hôm nay của bác sĩ
     */
    public static List<Appointment> getTodayWaitingAppointmentsByDoctorId(int doctorId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = """
            SELECT a.appointment_id, a.patient_id, a.doctor_id, a.work_date, 
                   a.slot_id, a.status, a.reason, a.previous_appointment_id,
                   p.full_name as patient_name, p.phone, p.date_of_birth, p.gender,
                   t.start_time, t.end_time
            FROM Appointment a
            INNER JOIN Patients p ON a.patient_id = p.patient_id
            INNER JOIN TimeSlot t ON a.slot_id = t.slot_id
            WHERE a.doctor_id = ? 
            AND CAST(a.work_date AS DATE) = CAST(GETDATE() AS DATE)
            AND a.status = N'Đã đặt'
            ORDER BY t.start_time ASC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setAppointmentId(rs.getInt("appointment_id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setWorkDate(rs.getDate("work_date"));
                appointment.setSlotId(rs.getInt("slot_id"));
                appointment.setStatus(rs.getString("status"));
                appointment.setReason(rs.getString("reason"));
                
                // Handle null previous_appointment_id
                int prevAppId = rs.getInt("previous_appointment_id");
                if (!rs.wasNull()) {
                    appointment.setPreviousAppointmentId(prevAppId);
                }
                
                // Thông tin bệnh nhân
                appointment.setPatientName(rs.getString("patient_name"));
                appointment.setPatientPhone(rs.getString("phone"));
                appointment.setPatientDateOfBirth(rs.getDate("date_of_birth"));
                appointment.setPatientGender(rs.getString("gender"));
                appointment.setStartTime(rs.getTime("start_time"));
                appointment.setEndTime(rs.getTime("end_time"));
                
                appointments.add(appointment);
            }
        }
        
        return appointments;
    }

    /*-------------------------------------------------------------*/
    /* CHỨC NĂNG CẬP NHẬT TRẠNG THÁI BÁC SĨ */
    /*-------------------------------------------------------------*/
    
    /**
     * Cập nhật trạng thái làm việc của bác sĩ
     * @param doctorId ID của bác sĩ
     * @param status Trạng thái mới (Active/Inactive)
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public static boolean updateDoctorStatus(int doctorId, String status) throws SQLException {
        String sql = "UPDATE Doctors SET status = ? WHERE doctor_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, doctorId);
            
            int rowsAffected = ps.executeUpdate();
            
            System.out.println("DEBUG: updateDoctorStatus - Rows affected: " + rowsAffected);
            System.out.println("DEBUG: updateDoctorStatus - Doctor ID: " + doctorId + ", Status: " + status);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Database error in updateDoctorStatus: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /*-------------------------------------------------------------*/
}
