<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    String email = (String) session.getAttribute("email");
    String role = (String) session.getAttribute("role");

    if (userId == null || email == null || role == null) {
        System.out.println("Session invalid: userId=" + userId + ", email=" + email + ", role=" + role);
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Messenger Style Chat</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            display: flex;
            height: 100vh;
            background-color: #f0f2f5;
        }

        .sidebar {
            width: 300px;
            background: #ffffff;
            border-right: 1px solid #ddd;
            display: flex;
            flex-direction: column;
            padding: 15px 10px;
            overflow-y: auto;
            box-shadow: 2px 0 5px rgba(0,0,0,0.05);
        }

        .sidebar h3 {
            font-size: 18px;
            margin: 10px 0;
            color: #1c1e21;
            padding: 5px 10px;
        }

        .user-entry {
            padding: 10px;
            border-radius: 18px;
            cursor: pointer;
            display: flex;
            align-items: center;
            font-size: 15px;
            gap: 12px;
            transition: all 0.2s ease;
            margin-bottom: 6px;
        }

        .user-entry:hover {
            background-color: #e4e6eb;
        }

        .user-entry.active {
            background-color: #d0e6ff;
            font-weight: bold;
            border-left: 4px solid #1877f2;
        }

        .chat-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: #ebedf0;
        }

        #chatBox {
            flex: 1;
            padding: 20px 30px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            background: #f0f2f5;
        }

        .message {
            max-width: 60%;
            padding: 12px 16px;
            border-radius: 20px;
            line-height: 1.5;
            font-size: 15px;
            word-wrap: break-word;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1);
            margin: 6px 0;
            position: relative;
            animation: fadeIn 0.2s ease-in-out;
        }

        .from-me {
            align-self: flex-end;
            background-color: #0084ff;
            color: white;
            border-bottom-right-radius: 5px;
        }

        .from-them {
            align-self: flex-start;
            background-color: #e4e6eb;
            color: #050505;
            border-bottom-left-radius: 5px;
        }

        .timestamp-container {
            background-color: #f0f2f5;
            display: flex;
            justify-content: flex-end;
            margin: 2px 0 8px 0;
        }

        .timestamp-container.from-them {
            justify-content: flex-start;
        }

        .timestamp {
            font-size: 11px;
            color: #000000;
            text-align: center;
        }

        .chat-input-area {
            display: flex;
            padding: 10px 20px;
            background: #ffffff;
            border-top: 1px solid #ccc;
            align-items: center;
        }

        #messageInput {
            flex: 1;
            padding: 10px 16px;
            border-radius: 20px;
            border: 1px solid #ccc;
            font-size: 15px;
            outline: none;
            background-color: #f0f2f5;
        }

        #sendBtn {
            margin-left: 10px;
            padding: 8px 18px;
            border-radius: 20px;
            border: none;
            background-color: #0084ff;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        #sendBtn:hover {
            background-color: #006fd6;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="sidebar">
    <% if ("PATIENT".equals(role)) { %>
        <h3>Bác sĩ khả dụng</h3>
        <div id="doctorList">Đang tải...</div>
    <% } else if ("DOCTOR".equals(role)) { %>
        <h3>Bác sĩ khả dụng</h3>
        <div id="doctorList">Đang tải...</div>
        <h3 style="margin-top: 20px;">Bệnh nhân khả dụng</h3>
        <div id="patientList">Đang tải...</div>
    <% } %>
</div>

<div class="chat-container">
    <div id="chatBox"></div>
    <div class="chat-input-area">
        <input type="text" id="messageInput" placeholder="Nhập tin nhắn..." />
        <button id="sendBtn">Gửi</button>
    </div>
</div>

<script>
    const currentUserRole = "<%= role %>";
    const userId = <%= userId %>;
    const email = "<%= email %>";
    let currentReceiverId = null;

    const socket = new WebSocket("ws://" + window.location.host + "<%= request.getContextPath() %>/chat");

    socket.onopen = () => {
        console.log("WebSocket connected");
        socket.send(JSON.stringify({ type: "init", user_id: userId }));
    };

    socket.onerror = (error) => {
        console.error("WebSocket error:", error);
    };

    socket.onclose = () => {
        console.log("WebSocket closed");
    };

    socket.onmessage = (event) => {
        try {
            const msg = JSON.parse(event.data);
            if ((msg.senderId === userId && msg.receiverId === currentReceiverId) ||
                (msg.senderId === currentReceiverId && msg.receiverId === userId)) {
                renderMessage(msg);
            }
        } catch (e) {
            console.error("Invalid WebSocket message:", event.data);
        }
    };

    document.getElementById("sendBtn").onclick = () => {
        const input = document.getElementById("messageInput");
        const content = input.value.trim();
        if (!content || currentReceiverId === null) return;

        const msg = {
            user_id: userId,
            receiver_id: currentReceiverId,
            message_content: content
        };
        socket.send(JSON.stringify(msg));
        input.value = "";
    };

    function renderMessage(msg) {
        const chatBox = document.getElementById("chatBox");
        const msgDiv = document.createElement("div");
        msgDiv.className = "message " + (msg.senderId === userId ? "from-me" : "from-them");

        const timeContainerDiv = document.createElement("div");
        timeContainerDiv.className = "timestamp-container " + (msg.senderId === userId ? "from-me" : "from-them");

        const timeDiv = document.createElement("div");
        timeDiv.className = "timestamp";
        const date = new Date(msg.timestamp || Date.now());
        timeDiv.textContent = date.toLocaleDateString() + " " + date.toLocaleTimeString();

        timeContainerDiv.appendChild(timeDiv);

        msgDiv.innerHTML = "<b>" + (msg.senderId === userId ? "Bạn" : "Họ") + ":</b> " + msg.content;

        chatBox.appendChild(msgDiv);
        chatBox.appendChild(timeContainerDiv);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function loadUserList() {
        fetch("ListUsersServlet")
            .then(res => {
                if (!res.ok) {
                    throw new Error(`HTTP error! Status: ${res.status}`);
                }
                return res.text();
            })
            .then(text => {
                try {
                    return JSON.parse(text);
                } catch (e) {
                    console.error("Invalid JSON response:", text);
                    throw e;
                }
            })
            .then(users => {
                const doctorList = document.getElementById("doctorList");
                const patientList = document.getElementById("patientList");
                doctorList.innerHTML = "";
                if (patientList) patientList.innerHTML = "";

                users.forEach(user => {
                    const div = document.createElement("div");
                    const nameToShow = user.full_name || user.email;
                    div.textContent = nameToShow + " (" + user.role + ")";
                    div.className = "user-entry";
                    div.dataset.userid = user.user_id;

                    div.onclick = () => {
                        currentReceiverId = user.user_id;
                        document.querySelectorAll(".user-entry").forEach(e => e.classList.remove("active"));
                        div.classList.add("active");
                        loadChatHistory(user.user_id);
                    };

                    if (user.role === "DOCTOR") {
                        doctorList.appendChild(div);
                    } else if (user.role === "PATIENT" && patientList) {
                        patientList.appendChild(div);
                    }
                });
            })
            .catch(error => {
                console.error("Error loading user list:", error);
                document.getElementById("doctorList").innerHTML = "Lỗi tải danh sách người dùng";
                if (patientList) patientList.innerHTML = "Lỗi tải danh sách người dùng";
            });
    }

    function loadChatHistory(receiverId) {
        fetch("ChatHistoryServlet?receiverId=" + receiverId)
            .then(res => {
                if (!res.ok) {
                    throw new Error(`HTTP error! Status: ${res.status}`);
                }
                return res.text();
            })
            .then(text => {
                try {
                    return JSON.parse(text);
                } catch (e) {
                    console.error("Invalid JSON response:", text);
                    throw e;
                }
            })
            .then(messages => {
                const chatBox = document.getElementById("chatBox");
                chatBox.innerHTML = "";
                messages.forEach(msg => renderMessage(msg));
            })
            .catch(error => {
                console.error("Error loading chat history:", error);
                document.getElementById("chatBox").innerHTML = "Lỗi tải lịch sử trò chuyện";
            });
    }

    loadUserList();
</script>

</body>
</html>