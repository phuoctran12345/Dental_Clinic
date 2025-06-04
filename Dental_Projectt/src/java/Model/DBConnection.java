
package Model;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_URL = "jdbc:sqlserver://MAINGAN;databaseName=BenhVien;encrypt=false;trustServerCertificate=false;loginTimeout=30";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }
    
    public static void main(String[] args) {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            System.out.println("Connection to the database established successfully!");
            try {
                // Optional: Print database name to confirm connection
                System.out.println("Connected to database: " + conn.getCatalog());
                // Close the connection
                conn.close();
                System.out.println("Connection closed.");
            } catch (SQLException e) {
                System.out.println("Error while accessing or closing the connection.");
                e.printStackTrace();
            }
        } else {
            System.out.println("Failed to connect to the database.");
        }
    }
}