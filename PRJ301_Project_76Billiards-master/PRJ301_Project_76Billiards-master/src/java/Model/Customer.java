/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Timestamp;

/**
 *
 * @author HP
 */
public class Customer {

    private int Customer_ID;
    private String Name;
    private String Email;
    private String PhoneNumber;
    private String Password;
    private int Role_ID;
    private Timestamp Created_At;
    private boolean Status;

    public Customer() {
    }

    public Customer(int Customer_ID, String Name, String Email, String PhoneNumber, String Password, int Role_ID, Timestamp Created_At, boolean Status) {
        this.Customer_ID = Customer_ID;
        this.Name = Name;
        this.Email = Email;
        this.PhoneNumber = PhoneNumber;
        this.Password = Password;
        this.Role_ID = Role_ID;
        this.Created_At = Created_At;
        this.Status = Status;
    }

    public int getCustomer_ID() {
        return Customer_ID;
    }

    public void setCustomer_ID(int Customer_ID) {
        this.Customer_ID = Customer_ID;
    }

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getPhoneNumber() {
        return PhoneNumber;
    }

    public void setPhoneNumber(String PhoneNumber) {
        this.PhoneNumber = PhoneNumber;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public int getRole_ID() {
        return Role_ID;
    }

    public void setRole_ID(int Role_ID) {
        this.Role_ID = Role_ID;
    }

    public Timestamp getCreated_At() {
        return Created_At;
    }

    public void setCreated_At(Timestamp Created_At) {
        this.Created_At = Created_At;
    }

    public boolean isStatus() {
        return Status;
    }

    public void setStatus(boolean Status) {
        this.Status = Status;
    }

    @Override
    public String toString() {
        return "Customer{" + "Customer_ID=" + Customer_ID + ", Name=" + Name + ", Email=" + Email + ", PhoneNumber=" + PhoneNumber + ", Password=" + Password + ", Role_ID=" + Role_ID + ", Created_At=" + Created_At + ", Status=" + Status + '}';
    }
}
