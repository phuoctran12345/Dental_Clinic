package model;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class Doctors {
    private long doctor_id;
    private long user_id;
    private String full_name;
    private String phone;
    private String address;
    private Date date_of_birth;
    private String gender;
    private String specialty;
    private String license_number;
    private Date created_at;
    private String status;
    private String avatar;
    private String userEmail;     // Email từ user table
    private List<DoctorSchedule> schedules;
    private List<String> workDates;

    public Doctors(long doctor_id, String full_name, String phone, String address, Date date_of_birth, String gender, String specialty, String license_number, Date created_at) {
        this.doctor_id = doctor_id;
        this.full_name = full_name;
        this.phone = phone;
        this.address = address;
        this.date_of_birth = date_of_birth;
        this.gender = gender;
        this.specialty = specialty;
        this.license_number = license_number;
        this.created_at = created_at;
        this.schedules = new ArrayList<>();
        this.workDates = new ArrayList<>();
    }

    public Doctors(long doctor_id, long user_id, String full_name, String phone, String address, Date date_of_birth, String gender, String specialty, String license_number, Date created_at, String status, String avatar) {
        this.doctor_id = doctor_id;
        this.user_id = user_id;
        this.full_name = full_name;
        this.phone = phone;
        this.address = address;
        this.date_of_birth = date_of_birth;
        this.gender = gender;
        this.specialty = specialty;
        this.license_number = license_number;
        this.created_at = created_at;
        this.status = status;
        this.avatar = avatar;
        this.schedules = new ArrayList<>();
        this.workDates = new ArrayList<>();
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

  
    

    public Doctors() {
        this.schedules = new ArrayList<>();
        this.workDates = new ArrayList<>();
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public long getDoctor_id() {
        return doctor_id;
    }

    public void setDoctor_id(long doctor_id) {
        this.doctor_id = doctor_id;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
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

    public Date getDate_of_birth() {
        return date_of_birth;
    }

    public void setDate_of_birth(Date date_of_birth) {
        this.date_of_birth = date_of_birth;
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

    public String getLicense_number() {
        return license_number;
    }

    public void setLicense_number(String license_number) {
        this.license_number = license_number;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<DoctorSchedule> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<DoctorSchedule> schedules) {
        this.schedules = schedules;
    }

    public List<String> getWorkDates() {
        return workDates;
    }

    public void setWorkDates(List<String> workDates) {
        this.workDates = workDates;
    }

    // Alias methods for JSP compatibility
    public String getFullName() {
        return full_name;
    }

    public long getDoctorId() {
        return doctor_id;
    }

    // Thêm thuộc tính imageUrl cho JSP compatibility
    public String getImageUrl() {
        if (this.avatar != null && !this.avatar.isEmpty()) {
            return this.avatar;
        } else {
            return "/images/default-doctor.png"; // Đường dẫn ảnh mặc định
        }
    }

    @Override
    public String toString() {
        return "Doctor{" +
                "doctor_id=" + doctor_id +
                ", user_id=" + user_id +
                ", full_name='" + full_name + '\'' +
                ", phone='" + phone + '\'' +
                ", specialty='" + specialty + '\'' +
                ", status='" + status + '\'' +
                ", schedules=" + schedules +
                ", workDates=" + workDates +
                '}';
    }
}