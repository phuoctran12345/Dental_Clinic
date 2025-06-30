/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.GeminiAiService;
/**
 *
 * @author tranhongphuoc
 */

@WebServlet("/ChatAiServlet")
public class ChatAiServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        String userMessage = request.getParameter("message");
        
        System.out.println("User message received: " + userMessage);
        
        try {
            System.out.println("Calling AI Service...");
            // Gọi AI Service để lấy phản hồi
            String aiResponse = GeminiAiService.getAIResponse(userMessage);
            System.out.println("AI Response received: " + aiResponse);
            aiResponse = GeminiAiService.formatAIResponse(aiResponse);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(aiResponse);
        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("Xin lỗi, đã có lỗi xảy ra khi xử lý câu hỏi của bạn. Vui lòng thử lại sau.");
        }
    }
} 