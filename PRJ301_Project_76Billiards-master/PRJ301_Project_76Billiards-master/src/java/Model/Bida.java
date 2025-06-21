/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.io.Serializable;

/**
 *
 * @author DELL 7420
 */
public class Bida implements Serializable {

    private int Table_ID;
    private String Category;
    private String Quality;
    private int Price;
    private int Quantity;
    private String image;

    

    public Bida() {
    }

    public Bida(int Table_ID, String Category, String Quality, int Price, int Quantity, String image) {
        this.Table_ID = Table_ID;
        this.Category = Category;
        this.Quality = Quality;
        this.Price = Price;
        this.Quantity = Quantity;
        this.image = image;
    }

    public int getTable_ID() {
        return Table_ID;
    }

    public void setTable_ID(int Table_ID) {
        this.Table_ID = Table_ID;
    }

    public String getCategory() {
        return Category;
    }

    public void setCategory(String Category) {
        this.Category = Category;
    }

    public String getQuality() {
        return Quality;
    }

    public void setQuality(String Quality) {
        this.Quality = Quality;
    }

    public int getPrice() {
        return Price;
    }

    public void setPrice(int Price) {
        this.Price = Price;
    }

    public int getQuantity() {
        return Quantity;
    }

    public void setQuantity(int Quantity) {
        this.Quantity = Quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "Bida{" + "Table_ID=" + Table_ID + ", Category=" + Category + ", Quality=" + Quality + ", Price=" + Price + ", Quantity=" + Quantity + ", image=" + image + '}';
    }

    
    

}
