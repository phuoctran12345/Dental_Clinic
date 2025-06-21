/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import static Model.DatabaseInfo.DBURL;
import static Model.DatabaseInfo.DRIVERNAME;
import static Model.DatabaseInfo.PASSDB;
import static Model.DatabaseInfo.USERDB;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;  // Import thêm dòng này
import java.util.ArrayList;
import java.util.List;

public class BillDAO implements DatabaseInfo {

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

    public static int insertBill(Connection conn, int Customer_ID, String date, String startTime, String statusBill, String receiptImage, BigDecimal totalBill) throws SQLException {
        String sql = "INSERT INTO Bill (Customer_ID, Date, Start_Time, Status_bill, Receipt_Image, Total_Bill) VALUES (?, ?, ?, ?, ?, ?) SELECT SCOPE_IDENTITY()";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, Customer_ID); // Thêm Customer_ID
            stmt.setString(2, date);
            stmt.setString(3, startTime);
            stmt.setString(4, statusBill);
            stmt.setString(5, receiptImage);
            stmt.setBigDecimal(6, totalBill);

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Lỗi khi tạo hóa đơn!");
            }

            // Lấy Bill_ID vừa tạo
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Không lấy được Bill_ID!");
                }
            }
        }
    }

    public static void insertBillDetails(Connection conn, int billID, int tableID, int quantity, double price, String category, String quality, double total) throws SQLException {
        String sql = "INSERT INTO BillDetails (Bill_ID, Table_ID, Quantity, Price, Category, Quality, Total) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, billID);
            stmt.setInt(2, tableID);
            stmt.setInt(3, quantity);
            stmt.setDouble(4, price);
            stmt.setString(5, category);
            stmt.setString(6, quality);
            stmt.setDouble(7, total);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✅ Đã thêm vào BillDetails: Bill_ID=" + billID + ", Table_ID=" + tableID + ", Quantity=" + quantity + ", Price=" + price + ", Category=" + category + ", Quality=" + quality + ", Total=" + total);
            } else {
                System.out.println("⚠️ Không có hàng nào được chèn vào BillDetails!");
            }
        }
    }

    public static List<Bill> getAllBills() {
        List<Bill> billList = new ArrayList<>();
        String sql = "SELECT * FROM Bill ORDER BY Bill_ID DESC";
        System.out.println("🔍 Đang truy vấn danh sách hóa đơn...");

        try (Connection conn = getConnect()) {
            if (conn == null) {
                System.out.println("❌ Không thể kết nối đến database!");
                return billList;
            }

            try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Bill bill = new Bill();
                    bill.setBillID(rs.getInt("Bill_ID"));
                    bill.setCustomerID(rs.getInt("Customer_ID"));
                    bill.setDate(rs.getString("Date"));
                    bill.setStartTime(rs.getString("Start_Time"));
                    bill.setStatusBill(rs.getString("Status_bill"));
                    bill.setReceiptImage(rs.getString("Receipt_Image"));
                    bill.setTotalBill(rs.getBigDecimal("Total_Bill"));

                    billList.add(bill);
                    System.out.println("✅ Đã đọc bill: ID=" + bill.getBillID() + ", Status=" + bill.getStatusBill());
                }

                System.out.println("✅ Tổng số hóa đơn: " + billList.size());

            } catch (SQLException e) {
                System.out.println("❌ Lỗi khi truy vấn dữ liệu: " + e.getMessage());
                e.printStackTrace();
            }

        } catch (SQLException e) {
            System.out.println("❌ Lỗi kết nối database: " + e.getMessage());
            e.printStackTrace();
        }

        return billList;
    }
public static List<Bill> getBillsByCustomer(int customerID) {
        List<Bill> billList = new ArrayList<>();
        String sql = "SELECT * FROM Bill WHERE Customer_ID = ? ORDER BY Bill_ID DESC";
        System.out.println("🔍 Đang truy vấn hóa đơn của khách hàng ID=" + customerID);
        
        try (Connection conn = getConnect()) {
            if (conn == null) {
                System.out.println("❌ Không thể kết nối đến database!");
                return billList;
            }
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, customerID);
                
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Bill bill = new Bill();
                        bill.setBillID(rs.getInt("Bill_ID"));
                        bill.setCustomerID(rs.getInt("Customer_ID"));
                        bill.setDate(rs.getString("Date"));
                        bill.setStartTime(rs.getString("Start_Time"));
                        bill.setStatusBill(rs.getString("Status_bill"));
                        bill.setReceiptImage(rs.getString("Receipt_Image"));
                        bill.setTotalBill(rs.getBigDecimal("Total_Bill"));
                        
                        billList.add(bill);
                        System.out.println("✅ Đã đọc bill: ID=" + bill.getBillID() + ", Status=" + bill.getStatusBill());
                    }
                }
                
                System.out.println("✅ Tổng số hóa đơn của khách hàng: " + billList.size());
                
            } catch (SQLException e) {
                System.out.println("❌ Lỗi khi truy vấn dữ liệu: " + e.getMessage());
                e.printStackTrace();
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Lỗi kết nối database: " + e.getMessage());
            e.printStackTrace();
        }
        
        return billList;
    }
    public static int getLastBillID(Connection conn) throws SQLException {
        String sql = "SELECT MAX(Bill_ID) FROM Bill";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new SQLException("Không tìm thấy Bill_ID!");
            }
        }
    }
}
