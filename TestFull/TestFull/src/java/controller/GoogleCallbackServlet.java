package controller;

import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Arrays;

@WebServlet("/google-callback")
public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = "Phuoc dep zai";
    private static final String CLIENT_SECRET = "Phuoc dep zai";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        if (code != null) {
            try {
                
                TokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    new JacksonFactory(),
                    CLIENT_ID,
                    CLIENT_SECRET,
                    code,
                    "http://localhost:8080/role_staff/google-callback")
                    .execute();

                // Lấy thông tin người dùng
                GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(
                    new NetHttpTransport(),
                    new JacksonFactory())
                    .setAudience(Arrays.asList(CLIENT_ID))
                    .build();

                GoogleIdToken idToken = verifier.verify(tokenResponse.getTokenType());
                if (idToken != null) {
                    Payload payload = idToken.getPayload();
                    String email = payload.getEmail();
                    String name = (String) payload.get("name");
                    
                    // TODO: Kiểm tra email trong database
                    // Nếu có -> Đăng nhập
                    // Nếu chưa có -> Chuyển đến trang đăng ký
                    
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", name);
                    
                    response.sendRedirect("home.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("login.jsp?error=" + java.net.URLEncoder.encode("google_auth_failed", "UTF-8"));
            }
        }
    }
} 