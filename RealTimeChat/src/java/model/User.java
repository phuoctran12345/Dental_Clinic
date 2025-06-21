/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Home
 */
public class User {

    private int userId;
    private String passwordHash;
    private String email;
    private String role; // 'ADMIN', 'DOCTOR', 'PATIENT', 'STAFF'
    private Date createdAt;
    private String fullName;

    public User() {
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public User(int userId, String passwordHash, String email, String role, Date createdAt, String fullName) {
        this.userId = userId;
        this.passwordHash = passwordHash;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
        this.fullName = fullName;
    }

    @Override
    public String toString() {
        return "User{" + "userId=" + userId + ", passwordHash=" + passwordHash + ", email=" + email + ", role=" + role + ", createdAt=" + createdAt + ", fullName=" + fullName + '}';
    }


   
}
