package model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.sql.Date;


/**
 *
 * @author Home
 */
public class Patients {

    private int patientId;    // patient_id (auto-increment)
    private int id;       // id liên kết User (không null)
    private String fullName;   // full_name (mã hóa AES-256 ở tầng service)
    private String phone;      // phone (mã hóa AES-256)
    private Date dateOfBirth;  // date_of_birth (mã hóa AES-256)
    private String gender;     // gender ('male', 'female', 'other')
    private Date createdAt;    // created_at
    private String avatar;
    private String email;      // email của người thân
    private String relationship; // mối quan hệ với người đặt lịch
    private int bookedByUserId; // ID của user đặt lịch
    
    public Patients() {
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRelationship() {
        return relationship;
    }

    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }

    public int getBookedByUserId() {
        return bookedByUserId;
    }

    public void setBookedByUserId(int bookedByUserId) {
        this.bookedByUserId = bookedByUserId;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    
  

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public Patients(int patientId, int id, String fullName, String phone, Date dateOfBirth, String gender, Date createdAt, String email, String relationship, int bookedByUserId) {
        this.patientId = patientId;
        this.id = id;
        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.createdAt = createdAt;
        this.email = email;
        this.relationship = relationship;
        this.bookedByUserId = bookedByUserId;
    }

    public Patients(int patientId, int id, String fullName, String phone, Date dateOfBirth, String gender, Date createdAt) {
        this(patientId, id, fullName, phone, dateOfBirth, gender, createdAt, null, null, 0);
    }

    @Override
    public String toString() {
        return "Patients{" + "patientId=" + patientId + ", id=" + id + ", fullName=" + fullName + ", phone=" + phone + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", createdAt=" + createdAt + ", email=" + email + ", relationship=" + relationship + ", bookedByUserId=" + bookedByUserId + '}';
    }
}
