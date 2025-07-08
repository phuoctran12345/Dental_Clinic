<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.BlogPost" %>

<%
    BlogPost post = (BlogPost) request.getAttribute("post");
    String role = (String) session.getAttribute("role");
    boolean isStaff = "STAFF".equals(role);
%>
<%
    String homeUrl = request.getContextPath() + "/LandingPageServlet";
    if ("patient".equals(role)) {
        homeUrl = request.getContextPath() + "/UserHompageServlet";
    } else if ("doctor".equals(role)) {
        homeUrl = request.getContextPath() + "/DoctorHomePageServlet";
    } else if ("STAFF".equals(role)) {
        homeUrl = request.getContextPath() + "/jsp/staff/staff_tongquan.jsp";
    }
%>


<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= post.getTitle()%> - Chi tiết bài viết</title>
        <style>
            body {
                font-family: "Segoe UI", sans-serif;
                background: #f0f8ff;
                max-width: 800px;
                margin: 0 auto;
                padding: 30px;
            }
            .logo-home {
                position: absolute;
                top: 20px;
                left: 30px;
            }

            .logo-home a {
                display: flex;
                align-items: center;
                text-decoration: none;
                color: var(--dark-text);
                font-weight: 500;
                font-size: 1rem;
            }

            .logo-home img.logo {
                width: 40px;
                height: 40px;
                margin-right: 10px;
            }

            .post-container {
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .post-container img {
                width: 100%;
                max-height: 400px;
                object-fit: cover;
                border-radius: 8px;
            }
            h1 {
                color: #0056b3;
                margin-top: 20px;
            }
            .meta {
                color: #777;
                font-size: 0.9rem;
                margin-bottom: 20px;
            }
            .content {
                font-size: 1rem;
                color: #333;
                line-height: 1.6;
                white-space: pre-line;
            }
            .actions {
                margin-top: 20px;
            }
            .actions a, .actions form {
                display: inline-block;
                margin-right: 15px;
            }
            .actions a {
                color: #0077cc;
                text-decoration: none;
            }
            .actions a:hover {
                color: #d40000;
            }
            .btn-delete {
                background: none;
                border: none;
                color: red;
                cursor: pointer;
            }
        </style>
    </head>
    <body>


        <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 25px;">
            <!-- Logo -->
                       <a href="<%= homeUrl %>" style="display: flex; align-items: center; gap: 10px; text-decoration: none;">
    <img src="<%= request.getContextPath()%>/img/logo.png" alt="Logo" style="height: 50px;">
    <span style="font-size: 1.6rem; font-weight: bold; color: #287bff;">HAPPY SMILE</span>
</a>


          


            <!-- Breadcrumb -->
            <div style="font-size: 1rem;">
                <a href="<%= homeUrl%>" style="color: #0077cc; text-decoration: none;">Trang chủ</a>
                &nbsp;/&nbsp;
                <a href="<%= request.getContextPath()%>/blog" style="color: #0077cc; text-decoration: none;">Blog</a>
            </div>
        </div>

        <div class="post-container">
            <img src="<%= request.getContextPath() + "/" + post.getImageUrl()%>" alt="Ảnh bài viết">
            <h1><%= post.getTitle()%></h1>
            <div class="meta">🕒 <%= post.getCreatedAt().toString().substring(0, 16)%></div>
            <div class="content"><%= post.getContent()%></div>

            <% if (isStaff) {%>
            <div class="actions">
                <a href="blog?action=edit&blog_id=<%= post.getBlogId()%>">✏️ Sửa</a>
                <form action="blog" method="post" style="display:inline;" onsubmit="return confirm('Bạn chắc chắn muốn xóa?')">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="blog_id" value="<%= post.getBlogId()%>">
                    <button type="submit" class="btn-delete">🗑️ Xóa</button>
                </form>
            </div>
            <% }%>

            <div style="margin-top: 30px;">
                <a href="<%= request.getContextPath()%>/blog">← Quay về danh sách bài viết</a>
            </div>
        </div>

    </body>
</html>
