package Model;

import java.util.Date;

public class Doctors {

    private int doctorId;
    private int userId;
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

    public Doctors(int doctorId, int userId, String fullName, String phone,
            String address, Date dateOfBirth, String gender,
            String specialty, String licenseNumber, String status,
            Date createdAt, String avatar) {
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
        return "Doctor{"
                + "doctorId=" + doctorId
                + ", fullName='" + fullName + '\''
                + ", specialty='" + specialty + '\''
                + ", status='" + status + '\''
                + '}';
    }
}
