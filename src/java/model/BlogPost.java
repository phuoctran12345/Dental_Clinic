/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Home
 */
import java.sql.Timestamp;

public class BlogPost {
    public int blogId;
    public String title;
    public String content;
    public String imageUrl;
    public Timestamp createdAt;

    public BlogPost() {
    }

    public int getBlogId() {
        return blogId;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public BlogPost(int blogId, String title, String content, String imageUrl, Timestamp createdAt) {
        this.blogId = blogId;
        this.title = title;
        this.content = content;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "BlogPost{" + "blogId=" + blogId + ", title=" + title + ", content=" + content + ", imageUrl=" + imageUrl + ", createdAt=" + createdAt + '}';
    }
    
    
}
