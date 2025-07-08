//package controller;
//
//import dao.FaceImageDAO;
//import utils.GoogleVisionFaceService;
//import org.json.JSONObject;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import javax.servlet.ServletException;
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.util.stream.Collectors;
//
//@WebServlet("/FaceRecognitionServlet")
//public class FaceIdLoginServlet extends HttpServlet {
//    private final FaceImageDAO faceImageDAO = new FaceImageDAO();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
//        response.setContentType("application/json;charset=UTF-8");
//        PrintWriter out = response.getWriter();
//        JSONObject result = new JSONObject();
//        try {
//            String body = request.getReader().lines().collect(Collectors.joining());
//            JSONObject json = new JSONObject(body);
//            String action = json.optString("action", "login");
//            String imageBase64 = json.optString("image");
//            if (imageBase64.contains(",")) imageBase64 = imageBase64.split(",")[1];
//            if ("register".equals(action)) {
//                handleFaceRegistration(request, imageBase64, result);
//            } else {
//                handleFaceLogin(imageBase64, request, result);
//            }
//        } catch (Exception e) {
//            result.put("success", false).put("message", "Lỗi: " + e.getMessage());
//        }
//        out.print(result.toString());
//    }
//
//    // Đăng ký khuôn mặt mới
//    private void handleFaceRegistration(HttpServletRequest request, String imageBase64, JSONObject result) {
//        Integer userId = (Integer) request.getSession().getAttribute("userId");
//        if (userId == null) {
//            result.put("success", false).put("message", "Bạn cần đăng nhập trước!");
//            return;
//        }
//        if (!GoogleVisionFaceService.isValidFaceImage(imageBase64)) {
//            String qualityInfo = GoogleVisionFaceService.evaluateFaceQuality(imageBase64);
//            result.put("success", false).put("message", "Không thể đăng ký: " + qualityInfo);
//            return;
//        }
//        var face = GoogleVisionFaceService.detectFace(imageBase64);
//        if (face == null) {
//            result.put("success", false).put("message", "Không thể phân tích khuôn mặt!");
//            return;
//        }
//        String faceEncoding = GoogleVisionFaceService.extractFaceFeatures(face);
//        double confidenceScore = face.getDetectionConfidence();
//        faceImageDAO.deactivateOldFaceImages(userId);
//        boolean saved = faceImageDAO.saveFaceImage(userId, imageBase64, faceEncoding, confidenceScore);
//        result.put("success", saved).put("message", saved ? "Đăng ký khuôn mặt thành công!" : "Lỗi lưu dữ liệu!");
//    }
//
//    // Đăng nhập bằng khuôn mặt
//    private void handleFaceLogin(String imageBase64, HttpServletRequest request, JSONObject result) {
//        if (!GoogleVisionFaceService.isValidFaceImage(imageBase64)) {
//            String qualityInfo = GoogleVisionFaceService.evaluateFaceQuality(imageBase64);
//            result.put("success", false).put("message", "Không thể đăng nhập: " + qualityInfo);
//            return;
//        }
//        var face = GoogleVisionFaceService.detectFace(imageBase64);
//        if (face == null) {
//            result.put("success", false).put("message", "Không thể phân tích khuôn mặt!");
//            return;
//        }
//        String currentFaceEncoding = GoogleVisionFaceService.extractFaceFeatures(face);
//        Integer foundUserId = faceImageDAO.findUserByFace(currentFaceEncoding);
//        if (foundUserId != null) {
//            HttpSession session = request.getSession();
//            session.setAttribute("userId", foundUserId);
//            session.setAttribute("loginMethod", "face_recognition");
//            result.put("success", true).put("message", "Đăng nhập thành công!").put("userId", foundUserId);
//        } else {
//            result.put("success", false).put("message", "Không tìm thấy khuôn mặt khớp trong hệ thống!");
//        }
//    }
//} 