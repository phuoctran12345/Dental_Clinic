package utils;

import com.google.cloud.vision.v1.*;
import com.google.protobuf.ByteString;
import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.ServiceAccountCredentials;
import java.io.InputStream;
import java.util.Base64;
import java.util.Collections;
import java.util.List;

public class GoogleVisionFaceService {
    /** Phát hiện khuôn mặt từ ảnh base64 */
    public static FaceAnnotation detectFace(String imageBase64) {
        try {
            InputStream credentialsStream = GoogleVisionFaceService.class.getClassLoader().getResourceAsStream("dental-clinic-face-service.json");
            ImageAnnotatorSettings settings = ImageAnnotatorSettings.newBuilder()
                .setCredentialsProvider(FixedCredentialsProvider.create(ServiceAccountCredentials.fromStream(credentialsStream)))
                .build();
            try (ImageAnnotatorClient vision = ImageAnnotatorClient.create(settings)) {
                byte[] imageBytes = Base64.getDecoder().decode(imageBase64);
                ByteString imgBytes = ByteString.copyFrom(imageBytes);
                Image img = Image.newBuilder().setContent(imgBytes).build();
                Feature feat = Feature.newBuilder().setType(Feature.Type.FACE_DETECTION).build();
                AnnotateImageRequest request = AnnotateImageRequest.newBuilder().addFeatures(feat).setImage(img).build();
                List<AnnotateImageRequest> requests = Collections.singletonList(request);
                List<AnnotateImageResponse> responses = vision.batchAnnotateImages(requests).getResponsesList();
                for (AnnotateImageResponse res : responses) {
                    if (!res.hasError() && !res.getFaceAnnotationsList().isEmpty()) {
                        return res.getFaceAnnotationsList().get(0);
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    /** Ảnh có khuôn mặt hợp lệ không */
    public static boolean isValidFaceImage(String imageBase64) {
        return detectFace(imageBase64) != null;
    }
    /** Đánh giá chất lượng ảnh khuôn mặt */
    public static String evaluateFaceQuality(String imageBase64) {
        FaceAnnotation face = detectFace(imageBase64);
        if (face == null) return "Không phát hiện khuôn mặt";
        if (face.getDetectionConfidence() < 0.7) return "Ảnh mờ hoặc thiếu sáng";
        return "Tốt";
    }
    /** Trích xuất đặc trưng khuôn mặt (encoding) */
    public static String extractFaceFeatures(FaceAnnotation face) {
        return new com.google.gson.Gson().toJson(face);
    }
    /** So sánh 2 encoding khuôn mặt */
    public static double compareFaces(String encoding1, String encoding2) {
        return encoding1.equals(encoding2) ? 1.0 : 0.0;
    }
}