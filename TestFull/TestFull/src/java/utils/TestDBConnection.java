package utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDBConnection {
    
    public static void main(String[] args) {
        System.out.println("=== Testing Database Connection ===");
        
        try {
            // Test 1: Basic connection
            System.out.println("1. Testing basic connection...");
            Connection conn = DBContext.getConnection();
            if (conn != null) {
                System.out.println("✅ Database connection successful!");
            } else {
                System.out.println("❌ Database connection failed!");
                return;
            }
            
            // Test 2: Check if Staff table exists
            System.out.println("\n2. Testing Staff table...");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Staff");
            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("✅ Staff table exists with " + total + " records");
            } else {
                System.out.println("❌ Staff table query failed");
            }
            
            // Test 3: Check if Users table exists
            System.out.println("\n3. Testing Users table...");
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM Users");
            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("✅ Users table exists with " + total + " records");
            } else {
                System.out.println("❌ Users table query failed");
            }
            
            // Test 4: Check table structure
            System.out.println("\n4. Testing table structure...");
            rs = stmt.executeQuery("SELECT TOP 1 * FROM Staff");
            if (rs.next()) {
                System.out.println("✅ Staff table structure OK");
                System.out.println("  - staff_id: " + rs.getInt("staff_id"));
                System.out.println("  - user_id: " + rs.getInt("user_id"));
                System.out.println("  - full_name: " + rs.getString("full_name"));
            } else {
                System.out.println("❌ Staff table structure test failed");
            }
            
            // Test 5: Test JOIN query
            System.out.println("\n5. Testing JOIN query...");
            rs = stmt.executeQuery("SELECT s.staff_id, s.full_name, u.email FROM Staff s LEFT JOIN Users u ON s.user_id = u.user_id");
            if (rs.next()) {
                System.out.println("✅ JOIN query successful");
                System.out.println("  - staff_id: " + rs.getInt("staff_id"));
                System.out.println("  - full_name: " + rs.getString("full_name"));
                System.out.println("  - email: " + rs.getString("email"));
            } else {
                System.out.println("❌ JOIN query failed");
            }
            
            // Close resources
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (Exception e) {
            System.out.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("\n=== Test completed ===");
    }
} 