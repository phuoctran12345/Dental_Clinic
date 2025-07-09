/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

/**
 *
 * @author Home
 */
public class User implements Serializable{
    private int id;
    private String username;
    private String passwordHash;
    private String email;
    private String role; // 'ADMIN', 'DOCTOR', 'PATIENT', 'STAFF'
    private Date createdAt;
    private String avatar;
    private String phone; // Thêm thuộc tính phone

    public User(int aInt, String string, String string0, String string1, Timestamp timestamp) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public User() {
        // Constructor default
    }

    public User(int id, String username, String passwordHash, String email, String role, Date createdAt, String avatar) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "User{" + "id=" + id + ", username=" + username + ", passwordHash=" + passwordHash + ", email=" + email + ", role=" + role + ", createdAt=" + createdAt + ", avatar=" + avatar + '}';
    }

    public Object getPermissions() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean isActive() {
        // Mặc định tài khoản luôn active
        return true;
    }

    public Object getBirthday() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public String getGender() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    
}
