/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author tranhongphuoc
 */
public class Staff {
    private long staff_id;
    private long id;
    private String full_name;
    private String phone;
    private String address;
    private Date date_of_birth;
    private String gender;
    private String position;
    

    public Staff() {
    }

    public Staff(long staff_id, long id, String full_name, String phone, String address, Date date_of_birth, String gender, String position) {
        this.staff_id = staff_id;
        this.id = id;
        this.full_name = full_name;
        this.phone = phone;
        this.address = address;
        this.date_of_birth = date_of_birth;
        this.gender = gender;
        this.position = position;
    }

    public long getStaff_id() {
        return staff_id;
    }

    public void setStaff_id(long staff_id) {
        this.staff_id = staff_id;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
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

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    @Override
    public String toString() {
        return "Staff{" + "staff_id=" + staff_id + ", id=" + id + ", full_name=" + full_name + ", phone=" + phone + ", address=" + address + ", date_of_birth=" + date_of_birth + ", gender=" + gender + ", position=" + position + '}';
    }

    
    
    
    
    
    
    
}
