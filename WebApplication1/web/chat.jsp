<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chat Y Khoa AI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 700px;
            margin: 40px auto 0 auto;
            padding-bottom: 120px; /* Để nội dung không bị che bởi form */
        }
        .chat-container {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 32px 28px 32px 28px;
            min-height: 220px;
            max-height: 60vh;
            overflow-y: auto;
            margin: 0 auto;
            margin-top: 32px;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            transition: box-shadow 0.3s;
        }
        .message {
            margin-bottom: 18px;
            padding: 16px 22px;
            border-radius: 12px;
            font-size: 1.1em;
            line-height: 1.7;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            animation: fadeIn 0.7s;
            max-width: 80%;
            word-break: break-word;
        }
        .user-message {
            background-color: #e3f2fd;
            color: #222;
            align-self: flex-end;
            text-align: right;
        }
        .ai-message {
            background-color: #f8fafd;
            color: #222;
            align-self: flex-start;
            text-align: left;
        }
        #chatForm {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100vw;
            background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
            padding: 16px 0 12px 0;
            box-shadow: 0 -2px 16px rgba(0,0,0,0.06);
            z-index: 100;
            justify-content: center;
            display: flex;
        }
        #userInput {
            max-width: 600px;
            margin: 0 auto;
        }
        .chat-form-inner {
            max-width: 700px;
            width: 100%;
            margin: 0 auto;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        /* Responsive cho mobile */
        @media (max-width: 768px) {
            .container {
                max-width: 100vw;
                padding: 0 2vw 120px 2vw;
            }
            .chat-container {
                padding: 18px 4vw;
                max-height: 50vh;
            }
            #userInput {
                max-width: 90vw;
            }
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center mb-4">Chat Y Khoa AI</h2>
        <div class="chat-container" id="chatContainer">
            <!-- Messages will be displayed here -->
        </div>
    </div>
    <form id="chatForm" class="d-flex justify-content-center">
       <div class="chat-form-inner d-flex w-100 justify-content-center">
           <input type="text" id="userInput" class="form-control me-2" 
                  placeholder="Nhập câu hỏi về y khoa của bạn...">
           <button type="submit" class="btn btn-primary">Gửi</button>
       </div>
   </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#chatForm').on('submit', function(e) {
                e.preventDefault();
                const userMessage = $('#userInput').val();
                if (!userMessage.trim()) return;
                appendMessage(userMessage, 'user');
                $.ajax({
                    url: 'ChatServlet',
                    method: 'POST',
                    data: { message: userMessage },
                    success: function(response) {
                        appendMessage(response, 'ai');
                    },
                    error: function() {
                        appendMessage('Xin lỗi, đã có lỗi xảy ra.', 'ai');
                    }
                });
                $('#userInput').val('');
            });
            function appendMessage(message, sender) {
                const messageDiv = $('<div>')
                    .addClass('message')
                    .addClass(sender + '-message')
                    .html(message);
                $('#chatContainer').append(messageDiv);
                $('#chatContainer').scrollTop($('#chatContainer')[0].scrollHeight);
            }
        });
    </script>
</body>
</html>