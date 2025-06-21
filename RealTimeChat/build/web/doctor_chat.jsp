<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%@page import="model.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    String role = "doctor";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chat với bệnh nhân</title>
    <style>
        body { font-family: Arial; margin: 0; padding: 0; }
        #container { display: flex; height: 100vh; }
        #sidebar { width: 250px; background: #f0f0f0; padding: 10px; border-right: 1px solid #ccc; overflow-y: auto; }
        #chatArea { flex: 1; display: flex; flex-direction: column; }
        #messages { flex: 1; padding: 10px; overflow-y: auto; border-bottom: 1px solid #ccc; }
        #inputArea { display: flex; padding: 10px; }
        #inputArea input { flex: 1; padding: 8px; }
        #inputArea button { padding: 8px 12px; margin-left: 5px; }
        .user-item { cursor: pointer; padding: 5px; border-bottom: 1px solid #ddd; }
        .user-item:hover { background: #e0e0e0; }
    </style>


</head>
<body>
<div id="container">
    <div id="sidebar">
            <h2>Chọn người để bắt đầu trò chuyện</h2>
<ul>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    if (userList != null && !userList.isEmpty()) {
        for (User user : userList) {
%>
    <li>
        <strong><%= user.getUsername() %></strong>
        | <a href="chat.jsp?receiverId=<%= user.getUserId() %>&receiverName=<%= user.getUsername() %>">
            Chat với <%= user.getUsername() %>
          </a>
    </li>
<%
        }
    } else {
%>
    <li>Không tìm thấy người dùng để chat.</li>
<%
    }
%>
</ul>
        <div id="userList"></div>
    </div>
    <div id="chatArea">
        <div id="messages"></div>
        <div id="inputArea">
            <input type="text" id="messageInput" placeholder="Nhập tin nhắn..."/>
            <button onclick="sendMessage()">Gửi</button>
        </div>
    </div>
</div>

<script>
    const userId = <%= userId %>;
    const username = "<%= username %>";
    const role = "<%= role %>";

    let selectedReceiverId = null;
    let ws;

    function connectWebSocket() {
        ws = new WebSocket("ws://" + location.host + "/RealTimeChat/chat");

        ws.onmessage = (event) => {
            const msg = event.data;
            if (msg.startsWith("patientlist|")) {
                updateUserList(msg);
            } else {
                displayMessage(msg);
            }
        };
    }

    function updateUserList(data) {
        const container = document.getElementById("userList");
        container.innerHTML = "";

        const list = data.split("|")[1];
        if (!list) return;

        list.split(";").forEach(item => {
            const [id, name] = item.split(":");
            if (parseInt(id) !== userId) {
                const div = document.createElement("div");
                div.className = "user-item";
                div.innerText = name;
                div.onclick = () => {
                    selectedReceiverId = id;
                    document.getElementById("messages").innerHTML = "";
                    ws.send("HISTORY_REQUEST|" + id);
                };
                container.appendChild(div);
            }
        });
    }

    function displayMessage(raw) {
        const [type, userId, senderName, senderRole, receiverId, content] = raw.split("|");
        const msgDiv = document.createElement("div");
        msgDiv.innerHTML = `<strong>${senderName}:</strong> ${content}`;
        document.getElementById("messages").appendChild(msgDiv);
    }

    function sendMessage() {
        const input = document.getElementById("messageInput");
        const content = input.value.trim();
        if (content && selectedReceiverId) {
            ws.send(`${selectedReceiverId}|${content}`);
            input.value = "";
        }
    }

    connectWebSocket();
</script>
</body>
</html>
