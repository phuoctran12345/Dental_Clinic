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
public class Doctors {

    private int doctorId;    // patient_id (auto-increment)
    private int userId;       // id liên kết User (không null)
    private String fullName;   // full_name (mã hóa AES-256 ở tầng service)
    private String phone;      // phone (mã hóa AES-256)
    private String address;
    private Date dateOfBirth;  // date_of_birth (mã hóa AES-256)
    private String gender;     // gender ('male', 'female', 'other')
    private String specialty;
    private String licenseNumber;
    private Date createdAt;    // created_at
    private String status;
    private String avatar;

    public Doctors() {
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Doctors(int doctorId, int userId, String fullName, String phone, String address, Date dateOfBirth, String gender, String specialty, String licenseNumber, Date createdAt, String status, String avatar) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.specialty = specialty;
        this.licenseNumber = licenseNumber;
        this.createdAt = createdAt;
        this.status = status;
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "Doctors{" + "doctorId=" + doctorId + ", userId=" + userId + ", fullName=" + fullName + ", phone=" + phone + ", address=" + address + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", specialty=" + specialty + ", licenseNumber=" + licenseNumber + ", createdAt=" + createdAt + ", status=" + status + ", avatar=" + avatar + '}';
    }
    
    

}
