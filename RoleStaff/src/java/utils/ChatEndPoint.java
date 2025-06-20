package utils;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import jakarta.websocket.server.ServerEndpointConfig;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Enumeration; // Thêm import này cho GetHttpSessionConfigurator nếu bạn dùng nó trong ChatEndPoint (không trực tiếp)

// Chỉ định đường dẫn của WebSocket endpoint và sử dụng GetHttpSessionConfigurator để lấy HttpSession
@ServerEndpoint(value = "/chat", configurator = GetHttpSessionConfigurator.class)
public class ChatEndPoint {

    private static final Logger LOGGER = Logger.getLogger(ChatEndPoint.class.getName());

    // --- Cấu hình Database ---
    // Đảm bảo các giá trị này phù hợp với database SQL Server của bạn!
    // VÍ DỤ: "jdbc:sqlserver://localhost:1433;databaseName=YourDBName;encrypt=false;trustServerCertificate=false;loginTimeout=30;"
    public static final String DB_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static final String DB_URL = "jdbc:sqlserver://DESKTOP-F84C0VL;databaseName=Demo;encrypt=false;trustServerCertificate=false;loginTimeout=30;"; // CẬP NHẬT DÒNG NÀY
    public static final String DB_USER = "sa"; // CẬP NHẬT DÒNG NÀY
    public static final String DB_PASSWORD = "123"; // CẬP NHẬT DÒNG NÀY

    // --- Quản lý Sessions ---
    // activeSessions: Lưu trữ tất cả các session WebSocket đang hoạt động
    private static Set<Session> activeSessions = Collections.synchronizedSet(new HashSet<>());

    // userSessionData: Lưu trữ thông tin userId, username, role cho mỗi session WebSocket.
    // Key: Session, Value: Map<String, Object> (userId, username, role)
    private static Map<Session, Map<String, Object>> userSessionData = Collections.synchronizedMap(new HashMap<>());

    // doctorSessions: Lưu trữ session của các bác sĩ đang online
    // Key: DoctorId, Value: Session
    private static Map<Integer, Session> doctorSessions = Collections.synchronizedMap(new HashMap<>());

    // patientSessions: Lưu trữ session của các bệnh nhân đang online
    // Key: PatientId, Value: Session
    private static Map<Integer, Session> patientSessions = Collections.synchronizedMap(new HashMap<>());

    // --- Phương thức kết nối Database ---
    private Connection getConnection() throws SQLException {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "SQL Server JDBC Driver không tìm thấy.", e);
            throw new SQLException("SQL Server JDBC Driver không tìm thấy.", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // --- ONOPEN: Xử lý khi kết nối WebSocket được mở ---
    @OnOpen
    public void onOpen(Session session) throws IOException {
        activeSessions.add(session);
        // Lấy thông tin người dùng từ HttpSession (được truyền qua GetHttpSessionConfigurator)
        Map<String, Object> httpSessionAttributes = (Map<String, Object>) session.getUserProperties().get("httpSessionAttributes");

        if (httpSessionAttributes != null) {
            Integer userId = (Integer) httpSessionAttributes.get("userId");
            String username = (String) httpSessionAttributes.get("username");
            String role = (String) httpSessionAttributes.get("role");

            if (userId != null && username != null && role != null) {
                Map<String, Object> userData = new HashMap<>();
                userData.put("userId", userId);
                userData.put("username", username);
                userData.put("role", role);
                userSessionData.put(session, userData);

                LOGGER.info("Người dùng " + username + " (" + role + ") đã kết nối. Session ID: " + session.getId());

                // Thêm session vào danh sách theo vai trò để quản lý chat riêng tư
                if ("doctor".equals(role)) {
                    doctorSessions.put(userId, session);
                    // Thông báo cho TẤT CẢ bệnh nhân đang online rằng có bác sĩ mới online
                    broadcastSystemMessage("system|0|Server|System|null|Bác sĩ " + username + " vừa online.");
                    // Tùy chọn: gửi danh sách bệnh nhân online cho bác sĩ vừa kết nối (nếu có sidebar bệnh nhân)
                    // sendPatientListToDoctor(session); // Bạn có thể tự viết hàm này tương tự sendDoctorListToPatient
                } else if ("patient".equals(role)) {
                    patientSessions.put(userId, session);
                    // Gửi danh sách bác sĩ đang online cho bệnh nhân vừa kết nối
                    sendDoctorListToPatient(session);
                }

                // Gửi chào mừng riêng tư cho người dùng vừa kết nối
                sendPrivateSystemMessage(session, "Chào " + username + " (" + role + ")! Bạn đã tham gia chat.");

            } else {
                LOGGER.warning("Dữ liệu người dùng không đầy đủ cho session: " + session.getId());
                sendPrivateSystemMessage(session, "Lỗi: Thông tin người dùng không đầy đủ.");
                session.close();
            }
        } else {
            LOGGER.warning("Không tìm thấy thuộc tính HTTP Session cho session: " + session.getId());
            sendPrivateSystemMessage(session, "Lỗi: Không tìm thấy thông tin đăng nhập. Vui lòng đăng nhập lại.");
            session.close();
        }
    }


    // --- ONMESSAGE: Xử lý khi nhận tin nhắn từ client ---
    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        Map<String, Object> userData = userSessionData.get(session);
        if (userData == null) {
            sendPrivateSystemMessage(session, "Lỗi: Không tìm thấy thông tin người dùng. Vui lòng kết nối lại.");
            return;
        }

        Integer senderId = (Integer) userData.get("userId");
        String senderUsername = (String) userData.get("username");
        String senderRole = (String) userData.get("role");

        // Xử lý các tin nhắn yêu cầu đặc biệt từ frontend (ví dụ: yêu cầu lịch sử chat riêng tư)
        if (message.startsWith("HISTORY_REQUEST|")) {
            try {
                Integer requestedChatPartnerId = Integer.parseInt(message.split("\\|", 2)[1]);
                sendChatHistory(session, requestedChatPartnerId);
                LOGGER.info("Lịch sử được yêu cầu cho đối tác chat ID: " + requestedChatPartnerId + " bởi " + senderUsername);
            } catch (NumberFormatException e) {
                sendPrivateSystemMessage(session, "Lỗi: ID đối tác chat không hợp lệ cho yêu cầu lịch sử.");
                LOGGER.log(Level.WARNING, "ID đối tác chat không hợp lệ cho yêu cầu lịch sử: " + message, e);
            }
            return; // Dừng xử lý tiếp vì đây là yêu cầu đặc biệt, không phải tin nhắn chat
        }

        // Xử lý tin nhắn chat thông thường
        // Tin nhắn từ client theo format: [RECEIVER_ID]|[CONTENT]
        String[] parts = message.split("\\|", 2);
        if (parts.length < 2) {
            sendPrivateSystemMessage(session, "Lỗi: Định dạng tin nhắn không hợp lệ. Vui lòng thử lại theo format [RECEIVER_ID]|[CONTENT].");
            LOGGER.log(Level.WARNING, "Định dạng tin nhắn không hợp lệ nhận được từ " + senderUsername + ": " + message);
            return;
        }

        Integer receiverId = null;
        try {
            // Parse receiverId. Nếu là "0", coi như chat chung (receiverId = null)
            int parsedReceiverId = Integer.parseInt(parts[0]);
            if (parsedReceiverId != 0) {
                receiverId = parsedReceiverId;
            }
        } catch (NumberFormatException e) {
            sendPrivateSystemMessage(session, "Lỗi: ID người nhận không hợp lệ.");
            LOGGER.log(Level.WARNING, "ID người nhận không hợp lệ nhận được từ " + senderUsername + ": " + parts[0], e);
            return;
        }
        String content = parts[1];

        // --- Lưu tin nhắn vào Database ---
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            // Cập nhật câu lệnh SQL để lưu cả receiver_id
            String sql = "INSERT INTO ChatMessages (user_id, sender_name, message_content, receiver_id) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, senderId);
            pstmt.setString(2, senderUsername);
            pstmt.setString(3, content);
            // Lưu receiverId. Nếu receiverId là null, PreparedStatement.setObject sẽ lưu NULL vào cột INT NULL
            pstmt.setObject(4, receiverId);
            pstmt.executeUpdate();
            LOGGER.info("Tin nhắn đã lưu vào DB từ " + senderUsername + " đến " + (receiverId != null ? receiverId : "tất cả (chat chung)") + ": " + content);

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu tin nhắn vào database: " + e.getMessage(), e);
            sendPrivateSystemMessage(session, "Lỗi: Có lỗi xảy ra khi lưu tin nhắn.");
            return;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Lỗi khi đóng tài nguyên DB: " + e.getMessage(), e);
            }
        }
        // --- Kết thúc lưu tin nhắn vào Database ---

        // Xây dựng chuỗi tin nhắn để gửi đến các client
        // Format: [TYPE]|[SENDER_ID]|[SENDER_NAME]|[SENDER_ROLE]|[RECEIVER_ID]|[CONTENT]
        String chatMessagePayload = "chat|" + senderId + "|" + senderUsername + "|" + senderRole + "|" + (receiverId != null ? receiverId : "null") + "|" + content;

        // Logic gửi tin nhắn đích danh hoặc chat chung
        if (receiverId != null) { // Đây là tin nhắn riêng tư (có receiverId cụ thể)
            Session receiverSession = null;

            // Xác định session của người nhận dựa trên vai trò của người gửi
            if ("doctor".equals(senderRole)) {
                receiverSession = patientSessions.get(receiverId); // Bác sĩ gửi cho bệnh nhân
                LOGGER.info("Đang cố gắng gửi từ Bác sĩ " + senderId + " đến Bệnh nhân " + receiverId);
            } else if ("patient".equals(senderRole)) {
                receiverSession = doctorSessions.get(receiverId); // Bệnh nhân gửi cho bác sĩ
                LOGGER.info("Đang cố gắng gửi từ Bệnh nhân " + senderId + " đến Bác sĩ " + receiverId);
            }

            if (receiverSession != null && receiverSession.isOpen()) {
                receiverSession.getBasicRemote().sendText(chatMessagePayload);
                LOGGER.info("Đã gửi tin nhắn riêng tư thành công đến " + receiverId);
            } else {
                // Người nhận không online hoặc session không hợp lệ
                sendPrivateSystemMessage(session, "Người dùng bạn muốn chat không online hoặc không tồn tại.");
                LOGGER.warning("Người nhận " + receiverId + " không online hoặc session không hợp lệ.");
            }
            // Luôn gửi lại tin nhắn cho chính người gửi để họ thấy tin của mình đã được xử lý bởi server
            session.getBasicRemote().sendText(chatMessagePayload);
            LOGGER.info("Đã gửi tin nhắn riêng tư trở lại người gửi " + senderId);

        } else { // receiverId là null (tức là client gửi "0|Content" hoặc không gửi ID người nhận)
                 // Coi là tin nhắn chat chung (public chat)
            // Gửi tin nhắn đến tất cả các session đang hoạt động
            synchronized (activeSessions) {
                for (Session s : activeSessions) {
                    if (s.isOpen()) {
                        s.getBasicRemote().sendText(chatMessagePayload);
                    }
                }
            }
            LOGGER.info("Đã phát tán tin nhắn công khai từ " + senderUsername + ": " + content);
        }
    }

    // --- ONCLOSE: Xử lý khi kết nối WebSocket bị đóng ---
    @OnClose
    public void onClose(Session session) throws IOException {
        activeSessions.remove(session);
        Map<String, Object> userData = userSessionData.remove(session); // Xóa khỏi userSessionData

        if (userData != null) {
            Integer userId = (Integer) userData.get("userId");
            String username = (String) userData.get("username");
            String role = (String) userData.get("role");

            // Xóa session khỏi danh sách theo vai trò
            if ("doctor".equals(role)) {
                doctorSessions.remove(userId);
                // Gửi thông báo tới TẤT CẢ bệnh nhân rằng có bác sĩ vừa offline
                broadcastSystemMessage("system|0|Server|System|null|Bác sĩ " + username + " vừa offline.");
                LOGGER.info("Bác sĩ " + username + " đã ngắt kết nối.");
            } else if ("patient".equals(role)) {
                patientSessions.remove(userId);
                LOGGER.info("Bệnh nhân " + username + " đã ngắt kết nối.");
            }
            LOGGER.info("Người dùng " + username + " (" + role + ") đã ngắt kết nối. Session ID: " + session.getId());
        } else {
            LOGGER.warning("Session bị ngắt kết nối không có dữ liệu người dùng: " + session.getId());
        }
    }

    // --- ONERROR: Xử lý khi có lỗi WebSocket ---
    @OnError
    public void onError(Session session, Throwable throwable) throws IOException {
        LOGGER.log(Level.SEVERE, "Lỗi WebSocket cho session " + session.getId(), throwable);
        Map<String, Object> userData = userSessionData.get(session);
        String username = (userData != null) ? (String) userData.get("username") : "Không rõ";
        sendPrivateSystemMessage(session, "Lỗi kết nối WebSocket: " + throwable.getMessage());
        try {
            session.close();
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Lỗi khi đóng session sau lỗi: " + e.getMessage(), e);
        }
    }

    // --- Phương thức hỗ trợ: Gửi tin nhắn hệ thống riêng tư ---
    private void sendPrivateSystemMessage(Session session, String message) throws IOException {
        // Format: type|sender_id|sender_name|sender_role|receiver_id|content
        String payload = "system|0|Server|System|null|" + message;
        if (session != null && session.isOpen()) {
            session.getBasicRemote().sendText(payload);
            LOGGER.info("Đã gửi tin nhắn hệ thống riêng tư đến session " + session.getId() + ": " + message);
        }
    }

    // --- Phương thức hỗ trợ: Gửi tin nhắn hệ thống công khai (broadcast) ---
    private void broadcastSystemMessage(String message) throws IOException {
        synchronized (activeSessions) {
            for (Session session : activeSessions) {
                if (session.isOpen()) {
                    session.getBasicRemote().sendText(message);
                }
            }
        }
        LOGGER.info("Đã phát tán tin nhắn hệ thống: " + message);
    }

    // --- Phương thức hỗ trợ: Gửi danh sách bác sĩ online cho bệnh nhân ---
    private void sendDoctorListToPatient(Session patientSession) throws IOException {
        // Format: doctorlist|[ID]:[Tên]:[Vai trò];[ID]:[Tên]:[Vai trò];...
        StringBuilder doctors = new StringBuilder("doctorlist|");
        synchronized (doctorSessions) { // Đồng bộ hóa khi duyệt doctorSessions
            if (doctorSessions.isEmpty()) {
                // sendPrivateSystemMessage(patientSession, "Chưa có bác sĩ nào online."); // Không cần gửi message này nếu không có bác sĩ nào
                // Thay vào đó, gửi một doctorlist rỗng để frontend biết
                patientSession.getBasicRemote().sendText("doctorlist|"); // Gửi chuỗi rỗng
                return;
            }
            for (Map.Entry<Integer, Session> entry : doctorSessions.entrySet()) {
                Integer doctorId = entry.getKey();
                Session doctorSession = entry.getValue();

                // Lấy thông tin username và role của bác sĩ từ userSessionData
                Map<String, Object> doctorData = userSessionData.get(doctorSession);

                if (doctorData != null) {
                    doctors.append(doctorId).append(":")
                           .append(doctorData.get("username")).append(":")
                           .append(doctorData.get("role")).append(";");
                }
            }
        }
        // Loại bỏ dấu chấm phẩy cuối cùng nếu có
        if (doctors.length() > "doctorlist|".length()) {
            doctors.setLength(doctors.length() - 1);
        }

        if (patientSession != null && patientSession.isOpen()) {
            patientSession.getBasicRemote().sendText(doctors.toString());
            LOGGER.info("Đã gửi danh sách bác sĩ cho session bệnh nhân " + patientSession.getId() + ": " + doctors.toString());
        }
    }


    // --- Phương thức hỗ trợ: Gửi lịch sử chat ---
    public void sendChatHistory(Session session, Integer chatPartnerId) throws IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Object> currentUserData = userSessionData.get(session);

        if (currentUserData == null) {
            sendPrivateSystemMessage(session, "Lỗi: Không thể tải lịch sử chat (thông tin người dùng không rõ).");
            return;
        }

        Integer currentUserId = (Integer) currentUserData.get("userId");

        try {
            conn = getConnection();
            String sql;
            if (chatPartnerId != null && chatPartnerId != 0) {
                // Lịch sử chat riêng tư giữa currentUserId và chatPartnerId
                // Đảm bảo tin nhắn được gửi BỞI currentUserId TỚI chatPartnerId,
                // HOẶC được gửi BỞI chatPartnerId TỚI currentUserId.
                sql = "SELECT TOP 50 user_id, sender_name, message_content, receiver_id, timestamp " +
                      "FROM ChatMessages " +
                      "WHERE (user_id = ? AND receiver_id = ?) OR (user_id = ? AND receiver_id = ?) " +
                      "ORDER BY timestamp ASC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, currentUserId);
                pstmt.setInt(2, chatPartnerId);
                pstmt.setInt(3, chatPartnerId);
                pstmt.setInt(4, currentUserId);
            } else {
                // Lịch sử chat chung (nếu receiver_id là NULL hoặc 0)
                sql = "SELECT TOP 50 user_id, sender_name, message_content, receiver_id, timestamp " +
                      "FROM ChatMessages " +
                      "WHERE receiver_id IS NULL OR receiver_id = 0 " +
                      "ORDER BY timestamp ASC";
                pstmt = conn.prepareStatement(sql);
            }

            rs = pstmt.executeQuery();

            sendPrivateSystemMessage(session, "--- Lịch sử chat (50 tin gần nhất) ---");

            while (rs.next()) {
                Integer msgSenderId = rs.getInt("user_id");
                String senderName = rs.getString("sender_name");
                String content = rs.getString("message_content");
                // Kiểm tra xem receiver_id có NULL không trước khi lấy giá trị
                Integer msgReceiverId = rs.getObject("receiver_id") != null ? rs.getInt("receiver_id") : null;
                // Trong lịch sử, chúng ta không có vai trò của người gửi trong bảng ChatMessages,
                // bạn có thể lấy từ bảng Users nếu cần bằng cách JOIN, hoặc để mặc định là "unknown"
                String senderRole = "unknown"; // Cần JOIN với bảng Users để lấy đúng role nếu muốn hiển thị.

                // Format: type|sender_id|sender_name|sender_role|receiver_id|content
                String historyMessage = "history|" + msgSenderId + "|" + senderName + "|" + senderRole + "|" + (msgReceiverId != null ? msgReceiverId : "null") + "|" + content;
                session.getBasicRemote().sendText(historyMessage);
            }

            sendPrivateSystemMessage(session, "--- Hết lịch sử ---");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tải lịch sử chat cho người dùng " + currentUserId + " với đối tác " + chatPartnerId + ": " + e.getMessage(), e);
            sendPrivateSystemMessage(session, "Lỗi: Không thể tải lịch sử chat.");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Lỗi khi đóng tài nguyên DB: " + e.getMessage(), e);
            }
        }
    }
}