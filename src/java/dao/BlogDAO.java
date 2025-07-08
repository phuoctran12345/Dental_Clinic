/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.BlogPost;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

/**
 *
 * @author Home
 */
public class BlogDAO {

    public static List<BlogPost> getAllPosts() throws SQLException {
        List<BlogPost> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Blog ORDER BY created_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new BlogPost(
                        rs.getInt("blog_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at")
                ));
            }
        }
        return list;
    }

    public static BlogPost getPostById(int blogId) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM Blog WHERE blog_id = ?");
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new BlogPost(
                        rs.getInt("blog_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at")
                );
            }
        }
        return null;
    }

    public static void insertPost(String title, String content, String imageUrl) throws SQLException {
        try (Connection conn = DBContext.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO Blog (title, content, image_url) VALUES (?, ?, ?)");
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, imageUrl);
            ps.executeUpdate();
        }
    }

    public static void updatePost(int blogId, String title, String content, String imageUrl) {
        try (Connection conn = DBContext.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Blog SET title = ?, content = ?, image_url = ? WHERE blog_id = ?"
            );
            ps.setString(1, title);
            ps.setString(2, content);
            ps.setString(3, imageUrl);
            ps.setInt(4, blogId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String deletePost(int blogId) throws SQLException {
        String imageUrl = null;
        try (Connection conn = DBContext.getConnection()) {
            // Get image URL before delete
            PreparedStatement ps = conn.prepareStatement("SELECT image_url FROM Blog WHERE blog_id = ?");
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                imageUrl = rs.getString("image_url");
            }

            // Delete post
            ps = conn.prepareStatement("DELETE FROM Blog WHERE blog_id = ?");
            ps.setInt(1, blogId);
            ps.executeUpdate();
        }
        return imageUrl;
    }

    public List<BlogPost> getLatest(int limit) {
        List<BlogPost> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Blog ORDER BY created_at DESC";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BlogPost b = new BlogPost();
                    b.setBlogId(rs.getInt("blog_id"));
                    b.setTitle(rs.getString("title"));
                    b.setContent(rs.getString("content"));
                    b.setImageUrl(rs.getString("image_url"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<BlogPost> getLatestBlogs(int limit) {
    List<BlogPost> list = new ArrayList<>();
    String sql = "SELECT TOP (?) * FROM Blog ORDER BY created_at DESC";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, limit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            BlogPost post = new BlogPost();
            post.setBlogId(rs.getInt("blog_id"));
            post.setTitle(rs.getString("title"));
            post.setContent(rs.getString("content"));
            post.setCreatedAt(rs.getTimestamp("created_at"));
            post.setImageUrl(rs.getString("image_url"));
            list.add(post);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


}
