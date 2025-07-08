package model;

import java.util.Date;

public class Manager {
    private int managerId;
    private int userId;
    private String fullName;
    private String phone;
    private String address;
    private Date dateOfBirth;
    private String gender;
    private String position;
    private Date createdAt;

    public Manager() {
    }

    public Manager(int managerId, int userId, String fullName, String phone, String address, Date dateOfBirth, String gender, String position, Date createdAt) {
        this.managerId = managerId;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.position = position;
        this.createdAt = createdAt;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
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

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Manager{" + "managerId=" + managerId + ", userId=" + userId + ", fullName=" + fullName + ", phone=" + phone + ", address=" + address + ", dateOfBirth=" + dateOfBirth + ", gender=" + gender + ", position=" + position + ", createdAt=" + createdAt + '}';
    }
} 