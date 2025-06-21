package util;

import java.sql.*;

public class DBUtil {
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=BenhVien;encrypt=false";
        String user = "sa";
        String pass = "123";
        return DriverManager.getConnection(url, user, pass);
    }
}
