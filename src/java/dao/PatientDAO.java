package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Patients;
import utils.DBContext;
import model.User;

public class PatientDAO {

    private static final String GET_ALL = "SELECT * FROM Patients";
    private static final String GET_BY_ID = "SELECT * FROM Patients WHERE patient_id = ?";
    private static final String GET_BY_USER_ID = "SELECT * FROM Patients WHERE user_id = ?";
    private static final String INSERT = "INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE = "UPDATE Patients SET full_name = ?, phone = ?, date_of_birth = ?, gender = ? WHERE patient_id = ?";
    private static final String DELETE = "DELETE FROM Patients WHERE patient_id = ?";
    private static final String COUNT_BY_NAME = "SELECT COUNT(*) as total FROM Patients WHERE full_name = ?";

    public List<Patients> getAll() throws SQLException {
        List<Patients> patients = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_ALL);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(rs.getInt("user_id"));
                    
                    Patients patient = new Patients();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setDateOfBirth(rs.getDate("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setCreatedAt(rs.getDate("created_at"));
                    patient.setAvatar(rs.getString("avatar"));
                    
                    patients.add(patient);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return patients;
    }

    public static Patients getPatientById(int id) throws SQLException {
        Patients patient = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_BY_ID);
                ptm.setInt(1, id);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(rs.getInt("user_id"));
                    
                    patient = new Patients();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setDateOfBirth(rs.getDate("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setCreatedAt(rs.getDate("created_at"));
                    patient.setAvatar(rs.getString("avatar"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return patient;
    }

    public static Patients getPatientByUserId(int userId) throws SQLException {
        Patients patient = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_BY_USER_ID);
                ptm.setInt(1, userId);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    UserDAO userDAO = new UserDAO();
                    User user = userDAO.getUserById(rs.getInt("user_id"));
                    
                    patient = new Patients();
                    patient.setPatientId(rs.getInt("patient_id"));
                    patient.setId(rs.getInt("user_id"));
                    patient.setFullName(rs.getString("full_name"));
                    patient.setPhone(rs.getString("phone"));
                    patient.setDateOfBirth(rs.getDate("date_of_birth"));
                    patient.setGender(rs.getString("gender"));
                    patient.setCreatedAt(rs.getDate("created_at"));
                    patient.setAvatar(rs.getString("avatar"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return patient;
    }

    public boolean insert(int userId, String fullName, String phone, String dateOfBirth, String gender) {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(INSERT);
                ptm.setInt(1, userId);
                ptm.setString(2, fullName);
                ptm.setString(3, phone);
                ptm.setString(4, dateOfBirth);
                ptm.setString(5, gender);
                int rowsAffected = ptm.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ptm != null) ptm.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean update(int patientId, String fullName, String phone, String dateOfBirth, String gender) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(UPDATE);
                ptm.setString(1, fullName);
                ptm.setString(2, phone);
                ptm.setString(3, dateOfBirth);
                ptm.setString(4, gender);
                ptm.setInt(5, patientId);
                int rowsAffected = ptm.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return false;
    }

    public boolean delete(int patientId) throws SQLException {
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(DELETE);
                ptm.setInt(1, patientId);
                int rowsAffected = ptm.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return false;
    }

    public int countByName(String name) throws SQLException {
        int count = 0;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(COUNT_BY_NAME);
                ptm.setString(1, name);
                rs = ptm.executeQuery();
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (ptm != null) ptm.close();
            if (conn != null) conn.close();
        }
        return count;
    }

    // Test main
    public static void main(String[] args) {
        try {
            PatientDAO dao = new PatientDAO();
            
            // Test getAll
            List<Patients> patients = dao.getAll();
            System.out.println("All patients:");
            for (Patients p : patients) {
                System.out.println(p.getFullName());
            }
            
            // Test getById
            Patients patient = dao.getPatientById(1);
            if (patient != null) {
                System.out.println("\nPatient with ID 1:");
                System.out.println("Name: " + patient.getFullName());
                System.out.println("Phone: " + patient.getPhone());
            }
            
            // Test count
            String testName = "Nguyễn Văn A";
            int count = dao.countByName(testName);
            System.out.println("\nNumber of patients named '" + testName + "': " + count);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static Patients findByPhoneOrCCCD(String searchTerm) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public List<Patients> getAllPatients() {
        List<Patients> list = new ArrayList<>();
        String query = "SELECT * FROM Patients";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Patients(
                        rs.getInt("patient_id"),
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getDate("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return list;
    }

    public List<Patients> searchPatients(String keyword) {
        List<Patients> list = new ArrayList<>();
        String query = "SELECT * FROM Patients WHERE full_name LIKE ? OR phone LIKE ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Patients(
                        rs.getInt("patient_id"),
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getDate("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return list;
    }

    public List<Patients> filterPatientsByGender(String gender) {
        List<Patients> list = new ArrayList<>();
        String query = "SELECT * FROM Patients WHERE gender = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, gender);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Patients(
                        rs.getInt("patient_id"),
                        rs.getInt("id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getDate("date_of_birth"),
                        rs.getString("gender"),
                        rs.getDate("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBContext.closeConnection(conn, ps, rs);
        }
        return list;
    }

    // Thêm dữ liệu mẫu
//    public void addSampleData() {
//        String query = "INSERT INTO Patients (id, full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?, ?)";
//        try {
//            conn = DBContext.getConnection();
//            ps = conn.prepareStatement(query);
//            
//            // Thêm bệnh nhân 1
//            ps.setInt(1, 1);
//            ps.setString(2, "Nguyễn Văn A");
//            ps.setString(3, "0123456789");
//            ps.setDate(4, java.sql.Date.valueOf("1990-01-01"));
//            ps.setString(5, "male");
//            ps.executeUpdate();
//
//            // Thêm bệnh nhân 2
//            ps.setInt(1, 2);
//            ps.setString(2, "Trần Thị B");
//            ps.setString(3, "0987654321");
//            ps.setDate(4, java.sql.Date.valueOf("1995-05-15"));
//            ps.setString(5, "female");
//            ps.executeUpdate();
//
//            // Thêm bệnh nhân 3
//            ps.setInt(1, 3);
//            ps.setString(2, "Lê Văn C");
//            ps.setString(3, "0369852147");
//            ps.setDate(4, java.sql.Date.valueOf("1988-12-31"));
//            ps.setString(5, "other");
//            ps.executeUpdate();
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        } finally {
//           DBContext.closeConnection(conn, ps, rs);
//        }
//    }
    public static int getTotalVisitsByPatientId(int patientId) {
        String sql = "SELECT COUNT(*) FROM Appointment WHERE patient_id = ? AND status = N'Đã khám'";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
       public static int findOrInsertRelativePatient(String fullName, String phone, String dateOfBirth, String gender) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int patientId = -1;

        try {
            conn = DBContext.getConnection();
       
            // Kiểm tra xem người thân đã tồn tại chưa (dựa vào SĐT)
            String checkSql = "SELECT patient_id FROM Patients WHERE phone = ?";
            ps = conn.prepareStatement(checkSql);
            ps.setString(1, phone);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Nếu đã tồn tại, trả về patient_id
                patientId = rs.getInt("patient_id");
            } else {
                // Nếu chưa tồn tại, thêm mới
                String insertSql = "INSERT INTO Patients (full_name, phone, date_of_birth, gender) VALUES (?, ?, ?, ?)";
                ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, fullName);
                ps.setString(2, phone);
                ps.setString(3, dateOfBirth);
                ps.setString(4, gender);

                int affectedRows = ps.executeUpdate();
                if (affectedRows > 0) {
                    rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        patientId = rs.getInt(1);
                }
            }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, ps, conn);
        }
        return patientId;
    }

    public List<Patients> searchByPhone(String phone) {
        List<Patients> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patients WHERE phone LIKE ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + phone + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Patients patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setId(rs.getInt("user_id")); 
                patient.setFullName(rs.getString("full_name"));
                patient.setPhone(rs.getString("phone"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
                patient.setCreatedAt(rs.getDate("created_at"));
                
                patients.add(patient);
            }
        } catch (SQLException e) {
            System.out.println("searchByPhone: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return patients;
    }

    public List<Patients> searchByName(String name) {
        List<Patients> patients = new ArrayList<>();
        String sql = "SELECT * FROM Patients WHERE full_name LIKE ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Patients patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setId(rs.getInt("user_id")); 
                patient.setFullName(rs.getString("full_name"));
                patient.setPhone(rs.getString("phone"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
                patient.setCreatedAt(rs.getDate("created_at"));
                
                patients.add(patient);
            }
        } catch (SQLException e) {
            System.out.println("searchByName: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return patients;
    }

    public int createPatient(Patients relativePatient) {
        String sql = "INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender, avatar) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            ps.setObject(1, relativePatient.getId()); // user_id có thể null cho người thân
            ps.setString(2, relativePatient.getFullName());
            ps.setString(3, relativePatient.getPhone());
            ps.setDate(4, new java.sql.Date(relativePatient.getDateOfBirth().getTime()));
            ps.setString(5, relativePatient.getGender());
            ps.setString(6, relativePatient.getAvatar());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Trả về patient_id vừa được tạo
                }
            }
        } catch (SQLException e) {
            System.out.println("createPatient: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return -1; // Trả về -1 nếu có lỗi
    }
    
    // Đảm bảo có hàm close để tránh lỗi linter
    public static void close(java.sql.ResultSet rs, java.sql.PreparedStatement ps, java.sql.Connection conn) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    // Thêm patient mới từ Google
    public static boolean addPatientFromGoogle(int userId, String fullName) {
        try (Connection conn = DBContext.getConnection()) {
            String sql = "INSERT INTO Patients (user_id, full_name) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, fullName);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    //=================================================================================
    //code của C.TRung =======================================================
    public static boolean updatePatientAvatar(int patientId, String avatarPath) {
        String sql = "UPDATE Patients SET avatar = ? WHERE patient_id = ?";
        System.out.println("Executing SQL: " + sql);
        System.out.println("Parameters: patientId=" + patientId + ", avatarPath=" + avatarPath);
        
        try (Connection conn = DBContext.getConnection()) {
            if (conn == null) {
                System.out.println("Error: Could not connect to database");
                return false;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, avatarPath);
                stmt.setInt(2, patientId);
                int rowsAffected = stmt.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean insertNewPatient(Patients patient) {
        String sql = "INSERT INTO Patients (user_id, full_name, phone, date_of_birth, gender, avatar) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, patient.getId());
            stmt.setString(2, patient.getFullName());
            stmt.setString(3, patient.getPhone());
            stmt.setDate(4, patient.getDateOfBirth());
            stmt.setString(5, patient.getGender());
            stmt.setString(6, patient.getAvatar() != null ? patient.getAvatar() : null);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    public static boolean updatePatientInfo(Patients patient) {
        String sql = "UPDATE Patients SET full_name = ?, phone = ?, date_of_birth = ?, gender = ?, avatar = ? WHERE patient_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, patient.getFullName());
            stmt.setString(2, patient.getPhone());
            stmt.setDate(3, patient.getDateOfBirth());
            stmt.setString(4, patient.getGender());
            stmt.setString(5, patient.getAvatar() != null ? patient.getAvatar() : null);
            stmt.setInt(6, patient.getPatientId());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            return false;
        }
    }
    
    // =================================================================
    // CODE CỦA BẢO CHÂU
    
    
    /* Lấy tất cả bệnh nhân với phân trang*/
    public List<Patients> getAllPatientsWithPagination(int offset, int limit) {
        List<Patients> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Patients patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
                patient.setAvatar(rs.getString("avatar"));                
                patients.add(patient);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return patients;
    }
    
    // Lấy tổng số bệnh nhân
    public int getTotalPatients() {
        String sql = "SELECT COUNT(*) FROM patients";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Lấy số bệnh nhân hoạt động (giả sử tất cả đều hoạt động)
    public int getActivePatients() {
        String sql = "SELECT COUNT(*) FROM patients WHERE status = 'active' OR status IS NULL";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return getTotalPatients(); // Nếu không có cột status, trả về tổng số
    }
    
    // Lấy số bệnh nhân mới trong tháng này
    public int getNewPatientsThisMonth() {
        String sql = "SELECT COUNT(*) FROM patients WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) AND YEAR(created_at) = YEAR(CURRENT_DATE())";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    
    // Tìm kiếm bệnh nhân theo tên hoặc phone
    public List<Patients> searchPatients(String keyword, int offset, int limit) {
        List<Patients> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients WHERE full_name LIKE ? OR phone LIKE ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchKeyword = "%" + keyword + "%";
            stmt.setString(1, searchKeyword);
            stmt.setString(2, searchKeyword);
            stmt.setInt(3, limit);
            stmt.setInt(4, offset);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Patients patient = new Patients();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setGender(rs.getString("gender"));
                patient.setAvatar(rs.getString("avatar"));
                
                patients.add(patient);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return patients;
    }
    
    // Thêm bệnh nhân mới
    public boolean addPatient(Patients patient) {
        String sql = "INSERT INTO patients (full_name, email, phone, date_of_birth, gender, avatar) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getFullName());
            stmt.setString(2, patient.getEmail());
            stmt.setString(3, patient.getPhone());
            stmt.setDate(4, patient.getDateOfBirth());
            stmt.setString(5, patient.getGender());
            stmt.setString(6, patient.getAvatar());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Cập nhật thông tin bệnh nhân
    public boolean updatePatient(Patients patient) {
        String sql = "UPDATE patients SET full_name = ?, email = ?, phone = ?, date_of_birth = ?, gender = ?, avatar = ?, updated_at = CURRENT_TIMESTAMP WHERE patient_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getFullName());
            stmt.setString(2, patient.getEmail());
            stmt.setString(3, patient.getPhone());
            stmt.setDate(4, patient.getDateOfBirth());
            stmt.setString(5, patient.getGender());
            stmt.setString(6, patient.getAvatar());
            stmt.setInt(7, patient.getPatientId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Xóa bệnh nhân
    public boolean deletePatient(int patientId) {
        String sql = "DELETE FROM patients WHERE patient_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, patientId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

}
