package Chat;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.sql.*;
import java.sql.Timestamp;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import org.json.JSONObject;
import util.DBUtil;

@ServerEndpoint("/chat")
public class ChatEndPoint {
    private static final Map<Session, Integer> userSessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("Client connected: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JSONObject json = new JSONObject(message);

            // Trường hợp khởi tạo kết nối
            if (json.has("type") && "init".equals(json.getString("type"))) {
                int userId = json.getInt("user_id");
                userSessions.put(session, userId);
                System.out.println("Session mapped: " + session.getId() + " -> " + userId);
                return;
            }

            // Xử lý tin nhắn chat
            int userId = json.getInt("user_id");
            int receiverId = json.getInt("receiver_id");
            String content = json.getString("message_content");
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());

            JSONObject responseJson = new JSONObject();
            responseJson.put("senderId", userId);
            responseJson.put("receiverId", receiverId);
            responseJson.put("content", content);
            responseJson.put("timestamp", timestamp.toString());

            for (Map.Entry<Session, Integer> entry : userSessions.entrySet()) {
                if (entry.getValue() == receiverId || entry.getValue() == userId) {
                    entry.getKey().getBasicRemote().sendText(responseJson.toString());
                }
            }

            saveToDB(userId, receiverId, content, timestamp);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void saveToDB(int userId, int receiverId, String content, Timestamp timestamp) throws Exception {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "INSERT INTO ChatMessages (user_id, receiver_id, message_content, timestamp) VALUES (?, ?, ?, ?)")) {
            ps.setInt(1, userId);
            ps.setInt(2, receiverId);
            ps.setString(3, content);
            ps.setTimestamp(4, timestamp);
            ps.executeUpdate();
        }
    }

    @OnClose
    public void onClose(Session session) {
        userSessions.remove(session);
    }
}
