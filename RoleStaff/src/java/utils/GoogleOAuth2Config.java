//package utils;
//
//import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
//import com.google.api.client.extensions.servlet.auth.oauth2.AbstractAuthorizationCodeServlet;
//import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
//import com.google.api.client.http.GenericUrl;
//import com.google.api.client.http.javanet.NetHttpTransport;
//import com.google.api.client.json.jackson2.JacksonFactory;
//import com.google.api.client.util.store.FileDataStoreFactory;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.Arrays;
//import java.util.List;
//import jakarta.servlet.ServletException;            //đọc chỗ ni thấy javax thì kệ nghe; tính năng á ; đổi jakarta là thấy mùi liền 
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServletRequest;
//
//@WebServlet("/google-login")
//public abstract class GoogleOAuth2Config extends AbstractAuthorizationCodeServlet {
//    // Đọc từ biến môi trường để bảo mật hơn
//    private static final String CLIENT_ID = System.getenv().getOrDefault("GOOGLE_CLIENT_ID", "Phuoc dep zai");
//    private static final String CLIENT_SECRET = System.getenv().getOrDefault("GOOGLE_CLIENT_SECRET", "Phuoc dep zai");
//    private static final List<String> SCOPES = Arrays.asList(
//        "https://www.googleapis.com/auth/userinfo.email",
//        "https://www.googleapis.com/auth/userinfo.profile",
//        "https://www.googleapis.com/auth/calendar" // Nếu dùng Google Calendar API
//    );
//
//    @Override
//    protected String getRedirectUri(HttpServletRequest req) throws ServletException, IOException {
//        // Lấy URL động, tránh hardcode
//        GenericUrl url = new GenericUrl(req.getRequestURL().toString());
//        url.setRawPath("/google-callback"); // Đảm bảo servlet mapping đúng
//        return url.build();
//    }
//
//    @Override
//    protected AuthorizationCodeFlow initializeFlow() throws IOException {
//        return new GoogleAuthorizationCodeFlow.Builder(
//            new NetHttpTransport(),
//            new JacksonFactory(),
//            CLIENT_ID,
//            CLIENT_SECRET,
//            SCOPES)
//            .setDataStoreFactory(new FileDataStoreFactory(new File("tokens")))
//            .setAccessType("offline")
//            .build();
//    }
//
//    @Override
//    protected String getUserId(HttpServletRequest req) throws ServletException, IOException {
//        return req.getSession().getId();
//    }
//    // Không override doGet ở đây, hãy để callback xử lý ở servlet riêng (GoogleCallbackServlet)
//}