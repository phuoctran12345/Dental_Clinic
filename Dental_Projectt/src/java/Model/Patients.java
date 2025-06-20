package model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

import java.util.Date;

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
 
    
    public Patients() {
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

    public Patients(int patientId, int id, String fullName, String phone, Date dateOfBirth, String gender, Date createdAt) {
        this.patientId = patientId;
        this.id = id;
        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Patients{" + "patientId=" + patientId + ", id=" + id + ", fullName=" + fullName + ", phone=" + phone + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", createdAt=" + createdAt + '}';
    }
}
