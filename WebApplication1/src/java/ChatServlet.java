/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */



import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author tranhongphuoc
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        String userMessage = request.getParameter("message");
        
        try {
            // Gọi AI Service để lấy phản hồi
            String aiResponse = GeminiAIService.getAIResponse(userMessage);
            aiResponse = GeminiAIService.formatAIResponse(aiResponse);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(aiResponse);
        } catch (Exception e) {
            response.getWriter().write("Xin lỗi, đã có lỗi xảy ra khi xử lý câu hỏi của bạn. Vui lòng thử lại sau.");
            e.printStackTrace();
        }
    }
} 