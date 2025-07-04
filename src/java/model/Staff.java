/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 * Model Staff đại diện cho thông tin của nhân viên
 * @author TranHongPhuoc
 */
public class Staff {
    private long staffId;         // ID của nhân viên (IDENTITY)
    private long userId;          // ID của user tương ứng (unique)
    private String fullName;      // Họ tên đầy đủ (NOT NULL)
    private String phone;         // Số điện thoại (NOT NULL)
    private Date dateOfBirth;     // Ngày sinh
    private String gender;        // Giới tính (male/female/other)
    private String address;       // Địa chỉ
    private String position;      // Chức vụ (NOT NULL)
    private Date createdAt;       // Ngày tạo

    // Constructor mặc định
    public Staff() {
    }

    // Constructor đầy đủ tham số
    public Staff(long staffId, long userId, String fullName, String phone, 
                Date dateOfBirth, String gender, String address, String position, Date createdAt) {
        this.staffId = staffId;
        this.userId = userId;
        this.fullName = fullName;
        this.phone = phone;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
        this.position = position;
        this.createdAt = createdAt;
    }
    
    

    // Getters và Setters
    public long getStaffId() {
        return staffId;
    }

    public void setStaffId(long staffId) {
        this.staffId = staffId;
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
        if (gender != null) {
            gender = gender.toLowerCase();
            if (!gender.equals("male") && !gender.equals("female") && !gender.equals("other")) {
                throw new IllegalArgumentException("Gender must be 'male', 'female' or 'other'");
            }
        }
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    // toString method để in thông tin
    @Override
    public String toString() {
        return "Staff{" + 
               "staffId=" + staffId + 
               ", userId=" + userId + 
               ", fullName='" + fullName + '\'' + 
               ", phone='" + phone + '\'' + 
               ", dateOfBirth=" + dateOfBirth + 
               ", gender='" + gender + '\'' + 
               ", address='" + address + '\'' + 
               ", position='" + position + '\'' + 
               ", createdAt=" + createdAt + 
               '}';
    }

    // Phương thức kiểm tra thông tin hợp lệ
    public boolean isValid() {
        // Kiểm tra fullName không được null và không được rỗng
        if (fullName == null || fullName.trim().isEmpty()) {
            return false;
        }
        
        // Kiểm tra phone không được null và phải đúng định dạng
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        // Kiểm tra position không được null và không được rỗng
        if (position == null || position.trim().isEmpty()) {
            return false;
        }
        
        // Kiểm tra gender phải là "male", "female" hoặc "other"
        if (gender != null) {
            String genderLower = gender.toLowerCase();
            if (!genderLower.equals("male") && !genderLower.equals("female") && !genderLower.equals("other")) {
                return false;
            }
        }
        
        return true;
    }

    // Phương thức tính tuổi
    public int getAge() {
        if (dateOfBirth == null) {
            return 0;
        }
        
        Date now = new Date();
        long diffInMillies = Math.abs(now.getTime() - dateOfBirth.getTime());
        long diff = diffInMillies / (1000L * 60 * 60 * 24 * 365);
        return (int) diff;
    }

    // Phương thức format số điện thoại
    public String getFormattedPhone() {
        if (phone == null || phone.length() < 10) {
            return phone;
        }
        // Format tùy theo độ dài số điện thoại
        if (phone.length() == 10) {
            return phone.substring(0, 4) + "." + phone.substring(4, 7) + "." + phone.substring(7);
        } else {
            return phone;
        }
    }
}
