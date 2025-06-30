/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author ASUS
 */
public class Doctors {
    private long doctorId;
    private long userId;

    private String fullName;
    private String phone;
    private String address;
    private Date dateOfBirth;

    private String gender;
    private String specialty;
    private String licenseNumber;
    private String status;
    private Date createdAt;
    private String avatar;

    public Doctors() {
    }

    public Doctors(long doctorId, long userId, String fullName, String phone, String address, Date dateOfBirth, String gender, String specialty, String licenseNumber, String status, Date createdAt, String avatar) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.specialty = specialty;
        this.licenseNumber = licenseNumber;
        this.status = status;
        this.createdAt = createdAt;
        this.avatar = avatar;
    }

    public long getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(long doctorId) {
        this.doctorId = doctorId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    @Override
    public String toString() {
        return "Doctors{" + "doctorId=" + doctorId + ", userId=" + userId + ", fullName=" + fullName + ", phone=" + phone + ", address=" + address + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", specialty=" + specialty + ", licenseNumber=" + licenseNumber + ", status=" + status + ", createdAt=" + createdAt + ", avatar=" + avatar + '}';
    }
    
}
