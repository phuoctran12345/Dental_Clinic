/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author ASUS
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_URL = "jdbc:sqlserver://TOAN;databaseName=Doctor;encrypt=false;trustServerCertificate=false;loginTimeout=30";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

     public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = java.sql.DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException | java.sql.SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    // ✅ Hàm main để test kết nối
    

}
