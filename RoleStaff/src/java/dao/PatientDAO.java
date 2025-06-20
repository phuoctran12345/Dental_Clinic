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
       public static int findOrInsertRelativePatient(String fullName, String dateOfBirth, String gender) {
       
        // 2. Không tồn tại => insert mới
        String insertSql = "INSERT INTO Patients (full_name, date_of_birth, gender) VALUES (?, ?, ?)";

        try (Connection conn = DBContext.getConnection(); PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

            insertPs.setString(1, fullName);
            insertPs.setString(2, dateOfBirth);
            insertPs.setString(3, gender);

            int rows = insertPs.executeUpdate();
            if (rows > 0) {
                ResultSet generatedKeys = insertPs.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
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
    
    

}
