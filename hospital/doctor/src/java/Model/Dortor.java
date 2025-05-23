
package Model;

import java.util.Date;

public class Dortor {
private int doctorId;
private int userId;
private String fullName;
private String phone;
private String address;
private Date dateOfBirth; 
private String gender;
private String specialty;
private String licenseNumber;
private Date createdAt; 

    public Dortor() {
    }

    public Dortor(int doctorId, int userId, String fullName, String phone, String address, Date dateOfBirth, String gender, String specialty, String licenseNumber, Date createdAt) {
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

    @Override
    public String toString() {
        return "Dortor{" + "doctorId=" + doctorId + ", userId=" + userId + ", fullName=" + fullName + ", phone=" + phone + ", address=" + address + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", specialty=" + specialty + ", licenseNumber=" + licenseNumber + ", createdAt=" + createdAt + '}';
    }

    
    
}
