/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BlogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import model.BlogPost;

/**
 *
 * @author Home
 */
@MultipartConfig
@WebServlet(name = "blog", urlPatterns = {"/blog"})
public class BlogServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BlogServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BlogServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        String blogIdStr = request.getParameter("blog_id");

        try {
            if ("edit".equals(action) && blogIdStr != null) {
                int blogId = Integer.parseInt(blogIdStr);
                BlogPost post = BlogDAO.getPostById(blogId);
                request.setAttribute("post", post);
                request.getRequestDispatcher("/editblog.jsp").forward(request, response);
                return;
            } else if ("detail".equals(action) && blogIdStr != null) {
    int blogId = Integer.parseInt(blogIdStr);
    BlogPost post = BlogDAO.getPostById(blogId);
    request.setAttribute("post", post);
    request.getRequestDispatcher("/blog_detail.jsp").forward(request, response);
    return;
}


            List<BlogPost> posts = BlogDAO.getAllPosts();
            request.setAttribute("posts", posts);
            request.getRequestDispatcher("/blog.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");

    try {
        if ("delete".equals(action)) {
            int blogId = Integer.parseInt(request.getParameter("blog_id"));
            String imageUrl = BlogDAO.deletePost(blogId); // Trả về ảnh để xóa file
            if (imageUrl != null) {
                File file = new File(getServletContext().getRealPath("/") + imageUrl);
                if (file.exists()) file.delete();
            }

        } else if ("edit".equals(action)) {
            int blogId = Integer.parseInt(request.getParameter("blog_id"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String oldImage = request.getParameter("old_image");
            String imageUrl = oldImage;

            Part imagePart = request.getPart("image");

            if (imagePart != null && imagePart.getSize() > 0) {
                // Lưu ảnh mới
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                imagePart.write(uploadPath + File.separator + fileName);
                imageUrl = "uploads/" + fileName;

                // Xóa ảnh cũ nếu có
                if (oldImage != null && !oldImage.equals(imageUrl)) {
                    File oldFile = new File(getServletContext().getRealPath("/") + oldImage);
                    if (oldFile.exists()) oldFile.delete();
                }
            }

            BlogDAO.updatePost(blogId, title, content, imageUrl);

        } else {
            // Thêm bài viết mới
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            Part imagePart = request.getPart("image");

            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            imagePart.write(uploadPath + File.separator + fileName);
            String imageUrl = "uploads/" + fileName;

            BlogDAO.insertPost(title, content, imageUrl);
        }

        response.sendRedirect("blog");

    } catch (Exception e) {
        throw new ServletException(e);
    }
}


    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
