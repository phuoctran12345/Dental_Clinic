package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

/*
Tóm lại: Nếu email Google chưa có trong database, hãy tự động tạo tài khoản mới rồi đăng nhập luôn. Nếu đã có thì đăng nhập như bình thường.
*/
public class GoogleCallbackServlet extends HttpServlet {

    private static final String CLIENT_ID = "YOUR_CLIENT_ID";
    private static final String CLIENT_SECRET = "YOUR_CLIENT_SECRET";
    private String REDIRECT_URI;

    @Override
    public void init() throws ServletException {
        super.init();
        String contextPath = "/TestFull";
        REDIRECT_URI = "http://localhost:8080" + contextPath + "/LoginGG/LoginGoogleHandler";
        System.out.println("[DEBUG] GoogleCallbackServlet REDIRECT_URI initialized: " + REDIRECT_URI);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        System.out.println("[DEBUG] GoogleCallbackServlet received code: " + code);
        
        if (code != null) {
            try {
                System.out.println("[DEBUG] GoogleCallbackServlet starting token request...");
                GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    new JacksonFactory(),
                    CLIENT_ID,
                    CLIENT_SECRET,
                    code,
                    REDIRECT_URI)
                    .execute();

                String accessToken = tokenResponse.getAccessToken();
                
                // Get user info
                URL url = new URL("https://www.googleapis.com/oauth2/v2/userinfo");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestProperty("Authorization", "Bearer " + accessToken);
                conn.setRequestMethod("GET");

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder result = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        result.append(line);
                    }

                    JSONObject userInfo = new JSONObject(result.toString());
                    String email = userInfo.getString("email");
                    String name = userInfo.getString("name");

                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", name);
                    
                    response.sendRedirect(request.getContextPath() + "/LoginServlet");
                } else {
                    throw new IOException("Failed to get user info");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=google_auth_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=no_auth_code");
        }
    }
} 