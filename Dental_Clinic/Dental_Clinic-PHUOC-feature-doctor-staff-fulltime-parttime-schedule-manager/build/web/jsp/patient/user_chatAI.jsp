<%@page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chat Y Khoa AI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary: #4E80EE;
                --primary-light: #6D9AFF;
                --primary-dark: #3A5FCD;
                --accent: #FF6B6B;
                --bg: #f8fafc;
                --card-bg: #ffffff;
                --text: #2d3748;
                --text-light: #718096;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: var(--bg);
                min-height: 90vh;
                overflow-x: hidden;
                color: var(--text);
            }

            .app-container {
                display: flex;
                flex-direction: column;
                height: 90vh;
                max-width: 1200px;
                margin: 30px auto;
                position: relative;
                background: var(--card-bg);
                box-shadow: 0 10px 50px rgba(78, 128, 238, 0.15);
                border-radius: 15px;
                overflow: hidden;

            }

            .header {
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                padding: 22px 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                position: sticky;
                top: 0;
                z-index: 100;
                box-shadow: 0 4px 20px rgba(78, 128, 238, 0.3);
            }

            .header-content {
                display: flex;
                align-items: center;
                gap: 15px;
                max-width: 1200px;
                width: 100%;
                justify-content: center;
            }

            .header-icon {
                width: 46px;
                height: 46px;
                background: rgba(255, 255, 255, 0.2);
                backdrop-filter: blur(10px);
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 20px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            .header-title {
                color: white;
                font-size: 24px;
                font-weight: 800;
                margin: 0;
                letter-spacing: -0.5px;
                text-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            .chat-main {
                flex: 1;
                display: flex;
                flex-direction: column;
                padding: 0;
                overflow: hidden;
                position: relative;
            }

            .chat-container {
                background: var(--card-bg);
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
                position: relative;
            }

            .chat-messages {
                flex: 1;
                overflow-y: auto;
                padding: 30px;
                display: flex;
                flex-direction: column;
                gap: 20px;
                scroll-behavior: smooth;
                background: linear-gradient(to bottom, #f9fafc, #ffffff);
            }

            .chat-messages::-webkit-scrollbar {
                width: 8px;
            }

            .chat-messages::-webkit-scrollbar-track {
                background: rgba(78, 128, 238, 0.05);
            }

            .chat-messages::-webkit-scrollbar-thumb {
                background: var(--primary);
                border-radius: 4px;
            }

            .message {
                max-width: 78%;
                padding: 18px 22px;
                border-radius: 18px;
                font-size: 15px;
                line-height: 1.6;
                position: relative;
                animation: messageSlideIn 0.4s cubic-bezier(0.18, 0.89, 0.32, 1.28);
                word-wrap: break-word;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .user-message {
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                color: white;
                align-self: flex-end;
                border-bottom-right-radius: 6px;
                margin-left: auto;
                box-shadow: 0 6px 20px rgba(78, 128, 238, 0.3);
            }

            .user-message:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(78, 128, 238, 0.4);
            }

            .ai-message {
                background: var(--card-bg);
                color: var(--text);
                align-self: flex-start;
                border-bottom-left-radius: 6px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                border: 1px solid rgba(0, 0, 0, 0.03);
            }

            .ai-message:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }

            .message-avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 15px;
                margin-bottom: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            .user-avatar {
                background: var(--primary-dark);
                color: white;
                margin-left: auto;
            }

            .ai-avatar {
                background: linear-gradient(135deg, #48bb78, #38a169);
                color: white;
            }

            .chat-input-container {
                padding: 25px 30px;
                background: var(--card-bg);
                border-top: 1px solid rgba(0, 0, 0, 0.05);
                box-shadow: 0 -5px 20px rgba(0, 0, 0, 0.03);
            }

            .chat-input-wrapper {
                display: flex;
                gap: 15px;
                align-items: flex-end;
                position: relative;
                max-width: 1200px;
                margin: 0 auto;
            }

            .input-group {
                flex: 1;
                position: relative;
            }

            #userInput {
                width: 100%;
                padding: 16px 20px;
                border: 2px solid rgba(78, 128, 238, 0.2);
                border-radius: 16px;
                font-size: 15px;
                line-height: 1.5;
                background: var(--card-bg);
                transition: all 0.3s ease;
                resize: none;
                min-height: 56px;
                max-height: 150px;
                font-family: inherit;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            #userInput:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 4px rgba(78, 128, 238, 0.15);
            }

            #userInput::placeholder {
                color: var(--text-light);
            }

            .send-button {
                width: 56px;
                height: 56px;
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                border: none;
                border-radius: 16px;
                color: white;
                font-size: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 6px 20px rgba(78, 128, 238, 0.3);
            }

            .send-button:hover {
                transform: translateY(-3px) scale(1.05);
                box-shadow: 0 10px 25px rgba(78, 128, 238, 0.4);
            }

            .send-button:active {
                transform: translateY(0) scale(1);
            }

            .welcome-message {
                text-align: center;
                color: var(--text-light);
                font-size: 16px;
                margin: 60px 0;
                animation: fadeIn 0.8s ease;
            }

            .welcome-icon {
                font-size: 56px;
                color: var(--primary);
                margin-bottom: 24px;
                opacity: 0.9;
                filter: drop-shadow(0 4px 12px rgba(78, 128, 238, 0.3));
            }

            .typing-indicator {
                display: flex;
                align-items: center;
                gap: 10px;
                color: var(--primary);
                font-size: 15px;
                margin: 12px 0;
                padding: 14px 20px;
                background: var(--card-bg);
                border-radius: 16px;
                width: fit-content;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                border: 1px solid rgba(0, 0, 0, 0.03);
            }

            .typing-dots {
                display: flex;
                gap: 6px;
            }

            .typing-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: var(--primary);
                animation: typingDots 1.5s infinite;
                opacity: 0.7;
            }

            .typing-dot:nth-child(2) {
                animation-delay: 0.2s;
            }

            .typing-dot:nth-child(3) {
                animation-delay: 0.4s;
            }

            @keyframes messageSlideIn {
                from {
                    opacity: 0;
                    transform: translateY(20px) scale(0.95);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes typingDots {
                0%, 60%, 100% {
                    transform: scale(1);
                    opacity: 0.6;
                }
                30% {
                    transform: scale(1.2);
                    opacity: 1;
                }
            }

            /* Floating particles effect */
            .particles {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                pointer-events: none;
                z-index: 0;
            }

            .particle {
                position: absolute;
                background: rgba(78, 128, 238, 0.15);
                border-radius: 50%;
                animation: float 15s infinite linear;
            }

            @keyframes float {
                0% {
                    transform: translateY(0) rotate(0deg);
                    opacity: 1;
                }
                100% {
                    transform: translateY(-100vh) rotate(360deg);
                    opacity: 0;
                }
            }

            /* Glow effect for important elements */
            .glow-on-hover {
                transition: box-shadow 0.3s ease;
            }

            .glow-on-hover:hover {
                box-shadow: 0 0 15px rgba(78, 128, 238, 0.5);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .app-container {
                    margin: 0;
                    border-radius: 0;
                    box-shadow: none;
                }

                .header {
                    padding: 18px 20px;
                }

                .header-icon {
                    width: 40px;
                    height: 40px;
                    font-size: 18px;
                }

                .header-title {
                    font-size: 20px;
                }

                .chat-messages {
                    padding: 25px 20px;
                }

                .message {
                    max-width: 85%;
                    padding: 16px 20px;
                }

                .chat-input-container {
                    padding: 20px;
                }

                #userInput {
                    padding: 14px 18px;
                }

                .send-button {
                    width: 50px;
                    height: 50px;
                    font-size: 18px;
                }
            }

            @media (max-width: 480px) {
                .header-content {
                    gap: 12px;
                }

                .header-title {
                    font-size: 18px;
                }

                .chat-messages {
                    padding: 20px 16px;
                    gap: 16px;
                }

                .message {
                    max-width: 90%;
                    padding: 14px 18px;
                    font-size: 14px;
                }

                .chat-input-wrapper {
                    gap: 10px;
                }
            }
        </style>
    </head>

    <body>
        <div class="app-container">
            <div class="header">
                <div class="header-content">
                    <div class="header-icon">
                        <i class="fas fa-robot"></i>
                    </div>
                    <h1 class="header-title">Chat AI tư vấn</h1>
                </div>
            </div>

            <div class="chat-main">
                <div class="chat-container">
                    <div class="chat-messages" id="chatContainer">
                        <div class="welcome-message">
                            <div class="welcome-icon">
                                <i class="fas fa-stethoscope"></i>
                            </div>
                            <h3>Chào mừng bạn đến với nha khoa HAPPY SMILE</h3>
                            <p>Tôi có thể giúp bạn trả lời các câu hỏi về y khoa và sức khỏe. Hãy đặt câu hỏi của bạn!</p>
                        </div>
                    </div>

                    <div class="chat-input-container">
                        <form id="chatForm">
                            <div class="chat-input-wrapper">
                                <div class="input-group">
                                    <input type="text" id="userInput" 
                                           placeholder="Nhập câu hỏi về y khoa của bạn..." 
                                           autocomplete="off">
                                </div>
                                <button type="submit" class="send-button">
                                    <i class="fas fa-paper-plane"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                let isTyping = false;

                $('#chatForm').on('submit', function (e) {
                    e.preventDefault();
                    const userMessage = $('#userInput').val().trim();
                    if (!userMessage || isTyping)
                        return;

                    // Remove welcome message if exists
                    $('.welcome-message').fadeOut(300, function () {
                        $(this).remove();
                    });

                    appendMessage(userMessage, 'user');
                    showTypingIndicator();
                    isTyping = true;

                    $.ajax({
                        url: '${pageContext.request.contextPath}/ChatAiServlet',
                        method: 'POST',
                        data: {message: userMessage},
                        success: function (response) {
                            hideTypingIndicator();
                            appendMessage(response, 'ai');
                            isTyping = false;
                        },
                        error: function () {
                            hideTypingIndicator();
                            appendMessage('Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại.', 'ai');
                            isTyping = false;
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
                    scrollToBottom();
                }

                function showTypingIndicator() {
                    const typingDiv = $('<div>')
                            .addClass('typing-indicator')
                            .attr('id', 'typingIndicator')
                            .html(`
                            <i class="fas fa-robot"></i>
                            <span>AI đang trả lời</span>
                            <div class="typing-dots">
                                <div class="typing-dot"></div>
                                <div class="typing-dot"></div>
                                <div class="typing-dot"></div>
                            </div>
                        `);
                    $('#chatContainer').append(typingDiv);
                    scrollToBottom();
                }

                function hideTypingIndicator() {
                    $('#typingIndicator').fadeOut(200, function () {
                        $(this).remove();
                    });
                }

                function scrollToBottom() {
                    const chatContainer = $('#chatContainer')[0];
                    chatContainer.scrollTop = chatContainer.scrollHeight;
                }

                // Auto-resize input
                $('#userInput').on('input', function () {
                    this.style.height = 'auto';
                    this.style.height = Math.min(this.scrollHeight, 120) + 'px';
                });

                // Enter to send, Shift+Enter for new line
                $('#userInput').on('keydown', function (e) {
                    if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        $('#chatForm').submit();
                    }
                });
            });
        </script>
    </body>

</html>