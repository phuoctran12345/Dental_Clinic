package Controller;

import Model.DoctorDB;
import Model.Doctors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;

@WebServlet("/uploadAvatar")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class UploadAvatarServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/avatars";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đường dẫn lưu file
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        // Tạo thư mục nếu chưa tồn tại
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            // Lấy file từ request
            Part filePart = request.getPart("avatar");
            String fileName = getFileName(filePart);
            
            // Kiểm tra file có hợp lệ
            if (fileName != null && !fileName.isEmpty()) {
                // Chỉ cho phép các định dạng ảnh
                String contentType = filePart.getContentType();
                if (contentType.startsWith("image/")) {
                    // Lưu file
                    String filePath = uploadPath + File.separator + fileName;
                    filePart.write(filePath);
                    
                    // Lưu đường dẫn vào database hoặc session (tùy yêu cầu)
                    String relativePath = UPLOAD_DIR + "/" + fileName;
                    request.getSession().setAttribute("avatarPath", relativePath);
                    
                    // Phản hồi thành công
                    response.setContentType("text/plain");
                    response.getWriter().write("Upload successful! File saved at: " + relativePath);
                } else {
                    response.setContentType("text/plain");
                    response.getWriter().write("Error: Only image files are allowed!");
                }
            } else {
                response.setContentType("text/plain");
                response.getWriter().write("Error: No file selected!");
            }
        } catch (Exception e) {
            response.setContentType("text/plain");
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    // Lấy tên file từ Part
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}