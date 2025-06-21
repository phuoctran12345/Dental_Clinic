/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Home
 */
public class HospitalDB implements DatabaseInfo {

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
    //--------------------------------------------------------------------------------------------

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

//--------------------------------------------------------------------------------------------
    public static Patients getPatientByUserId(int userId) {
        String sql = "SELECT * FROM Patients WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Patients patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setPhone(rs.getString("phone"));  // sửa chính tả

                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
                patient.setCreatedAt(rs.getDate("created_at"));  // nếu có trường này trong DB

                patient.setAvatar(rs.getString("avatar"));
                // các field khác nếu cần
                return patient;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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

    public static List<Doctors> getAllDoctors() {
        List<Doctors> list = new ArrayList<>();
        String sql = "SELECT * FROM Doctors";

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

    public static List<DoctorSchedule> getAvailableSchedulesByDoctor(int doctorId) throws SQLException {
        List<DoctorSchedule> list = new ArrayList<>();

        String sql = "SELECT ds.schedule_id, ds.doctor_id, ds.work_date, ds.slot_id, "
                + "ts.start_time, ts.end_time "
                + "FROM DoctorSchedule ds "
                + "JOIN TimeSlot ts ON ds.slot_id = ts.slot_id "
                + "WHERE ds.doctor_id = ? "
                + "AND NOT EXISTS ("
                + "    SELECT 1 FROM Appointment ap "
                + "    WHERE ap.doctor_id = ds.doctor_id "
                + "      AND ap.work_date = ds.work_date "
                + "      AND ap.slot_id = ds.slot_id "
                + "      AND ap.status = N'Đã đặt'"
                + ")";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DoctorSchedule ds = new DoctorSchedule();
                ds.setScheduleId(rs.getInt("schedule_id"));
                ds.setDoctorId(rs.getLong("doctor_id"));
                ds.setWorkDate(rs.getDate("work_date").toLocalDate());
                ds.setSlotId(rs.getInt("slot_id"));

                TimeSlot ts = new TimeSlot();
                ts.setStartTime(rs.getTime("start_time").toLocalTime());
                ts.setEndTime(rs.getTime("end_time").toLocalTime());
                ds.setTimeSlot(ts);

                list.add(ds);
            }
        }

        return list;
    }

    public static boolean insertAppointment(int scheduleId, int patientId, String workDate, String startTime) {
        String sql = """
            INSERT INTO Appointment (patient_id, doctor_id, work_date, slot_id, status)
            SELECT ?, ds.doctor_id, ?, ds.slot_id, N'Đã đặt'
            FROM DoctorSchedule ds
            JOIN TimeSlot ts ON ds.slot_id = ts.slot_id
            WHERE ds.schedule_id = ? AND ts.start_time = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ps.setString(2, workDate);
            ps.setInt(3, scheduleId);
            ps.setString(4, startTime);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.appointment_id, a.work_date, a.slot_id, a.status, a.reason, "
                + "d.full_name AS doctor_name, "
                + "t.start_time, t.end_time "
                + "FROM Appointment a "
                + "JOIN Doctors d ON a.doctor_id = d.doctor_id "
                + "JOIN TimeSlot t ON a.slot_id = t.slot_id "
                + "WHERE a.patient_id = ? "
                + "ORDER BY a.work_date DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment ap = new Appointment();
                ap.setAppointmentId(rs.getInt("appointment_id"));
                ap.setPatientId(patientId);
                ap.setWorkDate(rs.getDate("work_date").toLocalDate());
                ap.setSlotId(rs.getInt("slot_id"));
                ap.setStatus(rs.getString("status"));
                ap.setReason(rs.getString("reason"));
                ap.setDoctorName(rs.getString("doctor_name"));
                ap.setStartTime(rs.getTime("start_time").toLocalTime());
                ap.setEndTime(rs.getTime("end_time").toLocalTime());

                list.add(ap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<Doctors> filterDoctors(String keyword, String specialty) {
        List<Doctors> list = new ArrayList<>();
        String sql = "SELECT * FROM Doctors WHERE 1=1";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND full_name LIKE ?";
        }
        if (specialty != null && !specialty.isEmpty()) {
            sql += " AND specialty = ?";
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }
            if (specialty != null && !specialty.isEmpty()) {
                ps.setString(i++, specialty);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Doctors d = new Doctors();
                d.setDoctorId(rs.getInt("doctor_id"));
                d.setFullName(rs.getString("full_name"));
                d.setSpecialty(rs.getString("specialty"));
                d.setPhone(rs.getString("phone"));
                d.setAvatar(rs.getString("avatar"));
                d.setStatus(rs.getString("status"));

                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<String> getAllSpecialties() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT specialty FROM Doctors";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("specialty"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
