package Model;

import java.sql.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BidaDB implements DatabaseInfo {

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

    /*public static Connection getConnect(){
        try{
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
                    DataSource ds = (DataSource) envContext.lookup("jdbc/mydb");
                    return ds.getConnection();
        } catch (SQLException | NamingException ex){
            System.out.println("Error: " + ex);
        }
        return null;
    }*/
    public static Bida getBida(int Table_ID) {
        Bida s = null;
        try (Connection con = getConnect()) {
            PreparedStatement stmt = con.prepareStatement("Select Category, Quality, Price, Quantity, image from BillardTable where Table_ID=?");
            stmt.setInt(1, Table_ID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String Category = rs.getString(1);
                String Quality = rs.getString(2);
                int Price = rs.getInt(3);
                int Quantity = rs.getInt(4);
                String image = rs.getString(5);

                s = new Bida(Table_ID, Category, Quality, Price, Quantity, image);
            }
            con.close();
        } catch (Exception ex) {
            Logger.getLogger(BidaDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return s;
    }
//--------------------------------------------------------------------------------------------

    public static String login(String email) throws Exception {
        String pw = null;
        Connection con = getConnect();
        try {
            PreparedStatement stmt = con.prepareStatement("Select Password from Customert where email=?");

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {

                pw = rs.getString(1);

            }

        } catch (Exception ex) {
            Logger.getLogger(BidaDB.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            con.close();
        }
        return pw;
    }

//    public static int newFruit(Fruit s) {
//        int id = -1;
//        try (Connection con = getConnect()) {
//            PreparedStatement stmt = con.prepareStatement("Insert into Fruit(ProductID, ProductName, Description, Category, Price, StockQuantity, ProductImage, UnitOfMeasurement) output inserted.id values(?,?,?)");
//            stmt.setString(1, s.getProductName());
//            stmt.setString(2, s.getProductName());
//
//            ResultSet rs = stmt.executeQuery();
//            if (rs.next()) {
//                id = rs.getInt(1);
//            }
//            con.close();
//        } catch (Exception ex) {
//            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        return id;
//    }
//-----------------------------------------------------------------------------------
//    public static Fruit update(Fruit s) {
//        try (Connection con = getConnect()) {
//            PreparedStatement stmt = con.prepareStatement("Update Products set productName=?, description=?,price=? where productID =?");
//            stmt.setString(1, s.getProductName());
//            stmt.setString(2, s.getDescription());
//
//            int rc = stmt.executeUpdate();
//            con.close();
//            return s;
//        } catch (Exception ex) {
//            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
//            throw new RuntimeException("Invalid data");
//        }
//    }
//--------------------------------------------------------------------------------
//    public static int delete(int id) {
//        try (Connection con = getConnect()) {
//            PreparedStatement stmt = con.prepareStatement("Delete Products where productID =?");
//            stmt.setInt(1, id);
//            int rc = stmt.executeUpdate();
//            con.close();
//            return rc;
//        } catch (Exception ex) {
//            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        return 0;
//    }
//--------------------------------------------------------------------------------------------
//    public static ArrayList<Fruit> search(Predicate<Fruit> p) {
//        ArrayList<Fruit> list = listAll();
//        ArrayList<Fruit> res = new ArrayList<Fruit>();
//        for (Fruit s : list) {
//            if (p.test(s)) {
//                res.add(s);
//            }
//        }
//        return res;
//    }
//--------------------------------------------------------------------------------------------
    public static ArrayList<Bida> listAll() {
        ArrayList<Bida> list = new ArrayList<Bida>();
        //Connection con = getConnect();
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement stmt = con.prepareStatement("Select Table_ID, Category, Quality, Price, Quantity, image from BillardTable");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(new Bida(rs.getInt("Table_ID"), rs.getString("Category"), rs.getString("Quality"), rs.getInt("Price"), rs.getInt("Quantity"), rs.getString("image")));
            }
            con.close();
            return list;
        } catch (Exception ex) {
            Logger.getLogger(BidaDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
//--------------------------------------------------------------------------------------------

//    public static ArrayList<Customer> listAllCustomers() {
//        ArrayList<Customer> list = new ArrayList<>();
//        try (Connection con = DBConnection.getConnection()) { // Sử dụng class DatabaseConnection của bạn
//            PreparedStatement stmt = con.prepareStatement(
//                    "SELECT  Customer_ID\n"
//                    + "      ,PhoneNumber\n"
//                    + "      ,Name\n"
//                    + "      ,Email\n"
//                    + "      ,Password\n"
//            );
//            ResultSet rs = stmt.executeQuery();
//            while (rs.next()) {
//                list.add(new Customer(
//                        rs.getInt("Customer_ID"),
//                        rs.getInt("PhoneNumber"),
//                        rs.getString("Name"),
//                        rs.getString("Email"),
//                        rs.getString("Password")
//                ));
//            }
//        } catch (Exception ex) {
//            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        return list;
//    }
    //------------------------------------------------------------------------------------------
    public static Customer getCustomerByEmailAndPassword(String email, String password) {
        Customer customer = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Customer WHERE Email = ? AND Password = ? AND Status = 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                customer = new Customer(
                    rs.getInt("Customer_ID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("PhoneNumber"),
                    rs.getString("Password"),
                    rs.getInt("Role_ID"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Status")
                );
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }

//    public static List<Customer> getCustomersWithoutOrders() {
//        List<Customer> customers = new ArrayList<>();
//        try {
//            Connection conn = DBConnection.getConnection();
//            String sql = "SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)";
//            PreparedStatement ps = conn.prepareStatement(sql);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                customers.add(new Customer(
//                        rs.getInt("Customer_ID"),
//                        rs.getInt("PhoneNumber"),
//                        rs.getString("Name"),
//                        rs.getString("Email"),
//                        rs.getString("Password")
//                ));
//            }
//
//            conn.close();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return customers;
//    }
    
    
    // Kiểm tra xem Email hoặc Phone đã tồn tại chưa
    public static boolean isCustomerExists(String email, String phone) {
        String sql = "SELECT 1 FROM Customer WHERE (Email = ? OR PhoneNumber = ?) AND Status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có dòng kết quả thì đã tồn tại
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    //--------------------------------------------------------------------------------------------

    // Thêm khách hàng mới vào database
    public static boolean registerCustomer(String name, String email, String phone, String password) {
        String sql = "INSERT INTO Customer (Name, Email, PhoneNumber, Password, Role_ID, Status) VALUES (?, ?, ?, ?, 2, 1)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Kiểm tra dữ liệu đầu vào
            if (name == null || email == null || phone == null || password == null ||
                name.isEmpty() || email.isEmpty() || phone.isEmpty() || password.isEmpty()) {
                return false; // Tránh lỗi NULL
            }

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0; // Trả về true nếu thành công

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    
    
        //--------------------------------------------------------------------------------------------
 public void addOrUpdateTable(String category, String quality, int price, int quantity, String image) throws Exception {
        String checkSql = "SELECT Table_ID, Quantity FROM BillardTable WHERE Category = ? AND Quality = ? AND Price = ?";
        String updateSql = "UPDATE BillardTable SET Quantity = Quantity + ? WHERE Table_ID = ?";
        String insertSql = "INSERT INTO BillardTable (Category, Quality, Price, Quantity, image) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setString(1, category);
            checkStmt.setString(2, quality);
            checkStmt.setInt(3, price);

            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                int tableId = rs.getInt("Table_ID");
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, tableId);
                    updateStmt.executeUpdate();
                }
            } else {
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setString(1, category);
                    insertStmt.setString(2, quality);
                    insertStmt.setInt(3, price);
                    insertStmt.setInt(4, quantity);
                    insertStmt.setString(5, image);
                    insertStmt.executeUpdate();
                }
            }
        }
    }

    public void deleteTableByQuantity(int tableId, int amount) throws Exception {
        String checkSql = "SELECT Quantity FROM BillardTable WHERE Table_ID = ?";
        String updateSql = "UPDATE BillardTable SET Quantity = Quantity - ? WHERE Table_ID = ?";
        String deleteSql = "DELETE FROM BillardTable WHERE Table_ID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, tableId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                int currentQuantity = rs.getInt("Quantity");

                if (currentQuantity > amount) {
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, amount);
                        updateStmt.setInt(2, tableId);
                        updateStmt.executeUpdate();
                    }
                } else {
                    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                        deleteStmt.setInt(1, tableId);
                        deleteStmt.executeUpdate();
                    }
                }
            }
        }
    }
    //--------------------------------------------------------------------------------------------
     public Map<Integer, Integer> getTablePrices() {
    Map<Integer, Integer> tablePrices = new HashMap<>();
    String sql = "SELECT Table_ID, Price FROM BillardTable";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            tablePrices.put(rs.getInt("Table_ID"), rs.getInt("Price"));
        }
    } catch (SQLException ex) {
        Logger.getLogger(BidaDB.class.getName()).log(Level.SEVERE, "Lỗi khi truy vấn giá bàn bida", ex);
    }

    return tablePrices; // Trả về danh sách rỗng nếu có lỗi thay vì null
}


     
     
     

    //--------------------------------------------------------------------------------------------
    public static void main(String[] a) {
        ArrayList<Bida> list = BidaDB.listAll();
        for (Bida item : list) {
            System.out.println(item);
            
            
        }

    }

//---------------------------------------------------------------------------

    // Lấy danh sách tất cả khách hàng
    public static ArrayList<Customer> listAllCustomers() {
        ArrayList<Customer> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Customer WHERE Status = 1";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                list.add(new Customer(
                    rs.getInt("Customer_ID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("PhoneNumber"),
                    rs.getString("Password"),
                    rs.getInt("Role_ID"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật thông tin khách hàng
    public static boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET Name = ?, Email = ?, PhoneNumber = ?, Password = ?, Role_ID = ?, Status = ? WHERE Customer_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getPassword());
            ps.setInt(5, customer.getRole_ID());
            ps.setBoolean(6, customer.isStatus());
            ps.setInt(7, customer.getCustomer_ID());
            
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa khách hàng (soft delete)
    public static boolean deleteCustomer(int customerId) {
        String sql = "UPDATE Customer SET Status = 0 WHERE Customer_ID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy thông tin khách hàng theo ID
    public static Customer getCustomerById(int customerId) {
        Customer customer = null;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Customer WHERE Customer_ID = ? AND Status = 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                customer = new Customer(
                    rs.getInt("Customer_ID"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getString("PhoneNumber"),
                    rs.getString("Password"),
                    rs.getInt("Role_ID"),
                    rs.getTimestamp("Created_At"),
                    rs.getBoolean("Status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }
}
