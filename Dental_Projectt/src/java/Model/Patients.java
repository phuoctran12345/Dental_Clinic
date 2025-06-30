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
public class Patients {

    private int patientId;    // patient_id (auto-increment)
    private int userId;       // id liên kết User (không null)
    private String fullName;   // full_name (mã hóa AES-256 ở tầng service)
    private String phone;      // phone (mã hóa AES-256)
    private Date dateOfBirth;  // date_of_birth (mã hóa AES-256)
    private String gender;     // gender ('male', 'female', 'other')
    private Date createdAt;    // created_at
    private String avatar;

    public Patients() {
    }    

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
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

    public Patients(int patientId, int userId, String fullName, String phone, Date dateOfBirth, String gender, Date createdAt, String avatar) {
        this.patientId = patientId;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.createdAt = createdAt;
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "Patients{" + "patientId=" + patientId + ", userId=" + userId + ", fullName=" + fullName + ", phone=" + phone + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", createdAt=" + createdAt + ", avatar=" + avatar + '}';
    }
}
