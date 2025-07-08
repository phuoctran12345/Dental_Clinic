<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, model.BlogPost" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<BlogPost> posts = (List<BlogPost>) request.getAttribute("posts");
    String role = (String) session.getAttribute("role"); // STAFF hoặc PATIENT, MANAGER, null...
    boolean isStaff = "STAFF".equals(role);

    BlogPost featuredPost = null;
    List<BlogPost> otherPosts = new ArrayList<>();
    if (posts != null && !posts.isEmpty()) {
        featuredPost = posts.get(0); // Lấy bài đầu tiên làm bài nổi bật
        if (posts.size() > 1) {
            otherPosts = posts.subList(1, posts.size()); // Các bài còn lại
        }
    }
%>
<%
    String homeUrl = request.getContextPath() + "/LandingPageServlet"; // mặc định

    if ("patient".equals(role)) {
        homeUrl = request.getContextPath() + "/UserHompageServlet";
    } else if ("doctor".equals(role)) {
        homeUrl = request.getContextPath() + "/DoctorHomePageServlet";
    } else if ("STAFF".equals(role)) {
        homeUrl = request.getContextPath() + "/jsp/staff/staff_tongquan.jsp";
    }
%>



<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tin tức Nha khoa - Happy Smile</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Roboto+Condensed:wght@400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            :root {
                --primary-color: #287bff; /* Màu xanh dương chính, tươi sáng nhưng chuyên nghiệp */
                --secondary-color: #0056b3; /* Một sắc thái xanh đậm hơn cho hover */
                --dark-text: #333;
                --gray-text: #666;
                --light-gray-text: #999;
                --border-color: #e0e0e0; /* Border nhẹ hơn */
                --bg-light: #f8f9fa; /* Nền trắng sáng hơn */
                --card-bg: #fff;
                --shadow-light: rgba(0, 0, 0, 0.08); /* Đổ bóng rõ hơn một chút */
                --shadow-hover: rgba(0, 0, 0, 0.15); /* Đổ bóng khi hover rõ hơn */
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

            body {
                font-family: 'Roboto', sans-serif;
                background-color: var(--bg-light);
                margin: 0;
                padding: 0;
                color: var(--dark-text);
                line-height: 1.5;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            /* --- Header --- */
            .header {
                background-color: var(--card-bg);
                border-bottom: 4px solid var(--primary-color); /* Đường kẻ xanh dương đặc trưng */
                padding: 20px 0;
                text-align: center;
                box-shadow: 0 2px 8px var(--shadow-light);
                margin-bottom: 30px;
            }

            .header h1 {
                margin: 0;
                font-family: 'Roboto Condensed', sans-serif;
                font-size: 2.8rem;
                font-weight: 700;
                color: var(--dark-text);
                letter-spacing: -0.5px;
                text-transform: uppercase;
                display: inline-block;
            }

            .header h1 .fas.fa-tooth {
                color: var(--primary-color); /* Icon răng màu xanh dương */
                margin-right: 12px;
                font-size: 2.5rem;
                vertical-align: middle;
            }
            .header p {
                margin: 5px 0 0;
                font-size: 1.1rem;
                color: var(--gray-text);
                font-weight: 300;
            }

            /* --- Section Titles --- */
            .section-title {
                font-family: 'Roboto Condensed', sans-serif;
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--primary-color); /* Tiêu đề mục màu xanh dương */
                text-transform: uppercase;
                margin-top: 30px;
                margin-bottom: 20px;
                border-bottom: 2px solid var(--primary-color);
                padding-bottom: 10px;
                display: inline-block;
            }

            /* --- Form Đăng Bài (STAFF) --- */
            .post-form {
                background-color: var(--card-bg);
                padding: 25px;
                border-radius: 8px; /* Bo góc mềm mại hơn */
                box-shadow: 0 4px 12px var(--shadow-light);
                margin-bottom: 40px;
                border: 1px solid var(--border-color);
            }

            .post-form h3 {
                font-family: 'Roboto Condensed', sans-serif;
                color: var(--dark-text);
                text-align: center;
                margin-top: 0;
                margin-bottom: 25px;
                font-size: 1.6rem;
                font-weight: 700;
                text-transform: uppercase;
                padding-bottom: 10px;
                border-bottom: 1px dashed var(--border-color);
            }

            .post-form label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: var(--dark-text);
                font-size: 0.95rem;
            }

            .post-form input[type="text"],
            .post-form textarea,
            .post-form input[type="file"] {
                width: calc(100% - 20px);
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid var(--border-color);
                border-radius: 5px; /* Bo góc nhẹ nhàng */
                font-size: 1rem;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .post-form input[type="text"]:focus,
            .post-form textarea:focus {
                border-color: var(--primary-color);
                outline: none;
                box-shadow: 0 0 0 3px rgba(40, 123, 255, 0.2); /* Đổ bóng xanh khi focus */
            }

            /* Căn giữa ảnh xem trước khi đăng bài */
            .post-form #newPreview {
                display: none; /* Mặc định ẩn */
                width: 200px;
                margin: 10px auto 20px auto; /* Căn giữa ảnh mới */
                border-radius: 6px;
                border: 1px solid var(--border-color);
                box-shadow: 0 2px 8px var(--shadow-light);
            }

            .post-form button {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                width: 100%;
                padding: 12px 20px;
                background-color: var(--primary-color); /* Nút màu xanh dương */
                color: var(--card-bg);
                border: none;
                border-radius: 5px;
                font-size: 1.1rem;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
                margin-top: 15px;
            }

            .post-form button:hover {
                background-color: var(--secondary-color); /* Xanh đậm hơn khi hover */
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(40, 123, 255, 0.3);
            }

            /* --- Featured Post (Bài viết nổi bật) --- */
            .featured-post {
                display: flex;
                background-color: var(--card-bg);
                border-radius: 8px;
                box-shadow: 0 4px 12px var(--shadow-light);
                margin-bottom: 30px;
                overflow: hidden;
                border: 1px solid var(--border-color);
                transition: box-shadow 0.3s ease, transform 0.3s ease;
            }
            .featured-post:hover {
                box-shadow: 0 8px 20px var(--shadow-hover);
                transform: translateY(-3px);
            }

            .featured-post-img {
                flex-shrink: 0;
                width: 40%;
                height: 300px;
                overflow: hidden;
            }
            .featured-post-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
                transition: transform 0.3s ease;
            }
            .featured-post:hover .featured-post-img img {
                transform: scale(1.05);
            }

            .featured-post-content {
                flex-grow: 1;
                padding: 25px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .featured-post-content h2 {
                font-family: 'Roboto Condensed', sans-serif;
                font-size: 2.2rem;
                font-weight: 700;
                color: var(--dark-text);
                margin: 0 0 15px 0;
                line-height: 1.2;
            }
            .featured-post-content h2 a {
                text-decoration: none;
                color: inherit;
                transition: color 0.3s ease;
            }
            .featured-post-content h2 a:hover {
                color: var(--primary-color); /* Hover màu xanh dương */
            }

            .featured-post-content p {
                font-size: 1.05rem;
                color: var(--gray-text);
                margin-bottom: 20px;
                line-height: 1.6;
                flex-grow: 1;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 5;
                -webkit-box-orient: vertical;
            }

            .featured-post-meta {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 0.9rem;
                color: var(--light-gray-text);
                padding-top: 15px;
                border-top: 1px dashed var(--border-color);
            }
            .featured-post-meta .actions {
                border-top: none;
                padding-top: 0;
                margin-top: 0;
            }

            /* --- Other Posts Grid (Các bài viết khác) --- */
            .other-posts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 25px;
                padding-bottom: 50px;
            }

            .blog-card {
                background-color: var(--card-bg);
                border-radius: 8px; /* Bo góc mềm mại hơn */
                box-shadow: 0 2px 8px var(--shadow-light);
                overflow: hidden;
                border: 1px solid var(--border-color);
                transition: box-shadow 0.3s ease, transform 0.3s ease;
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .blog-card:hover {
                box-shadow: 0 4px 15px var(--shadow-hover);
                transform: translateY(-3px);
            }

            .blog-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
                display: block;
                border-bottom: 1px solid var(--border-color);
            }

            .blog-content {
                padding: 15px;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
            }

            .blog-card h3 {
                font-family: 'Roboto Condensed', sans-serif;
                font-size: 1.3rem;
                font-weight: 700;
                color: var(--dark-text);
                margin: 0 0 10px 0;
                line-height: 1.3;
            }
            .blog-card h3 a {
                text-decoration: none;
                color: inherit;
                transition: color 0.3s ease;
            }
            .blog-card h3 a:hover {
                color: var(--primary-color); /* Hover màu xanh dương */
            }

            .blog-card p {
                font-size: 0.9rem;
                color: var(--gray-text);
                line-height: 1.5;
                margin-bottom: 15px;
                flex-grow: 1;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 1;
                -webkit-box-orient: vertical;
            }

            .blog-card small {
                font-size: 0.8rem;
                color: var(--light-gray-text);
                display: flex;
                align-items: center;
                gap: 5px;
                margin-top: auto;
                padding-top: 10px;
                border-top: 1px dashed var(--border-color);
            }

            /* --- Actions (Sửa/Xóa) --- */
            .actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 15px;
                padding-top: 10px;
                border-top: 1px solid var(--border-color);
                align-items: center; /* Đảm bảo các mục con được căn giữa theo chiều dọc */
            }

            .actions a, .actions button {
                background: none;
                border: 1px solid var(--border-color);
                /* Thêm height hoặc min-height để đảm bảo các nút có cùng kích thước */
                min-height: 34px; /* Hoặc một giá trị phù hợp với padding và font-size */
                box-sizing: border-box; /* Đảm bảo padding/border tính vào kích thước */

                color: var(--gray-text);
                cursor: pointer;
                font-size: 0.85rem;
                padding: 5px 10px;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                justify-content: center; /* Căn giữa nội dung trong nút */
                gap: 5px;
            }
            .actions a {
                color: var(--primary-color); /* Nút sửa màu xanh dương */
                border-color: var(--primary-color);
            }
            .actions a:hover {
                background-color: var(--primary-color);
                color: var(--card-bg);
            }
            .actions button[type="submit"] {
                color: #dc3545; /* Vẫn giữ màu đỏ cho xóa để dễ nhận biết */
                border-color: #dc3545;
            }
            .actions button[type="submit"]:hover {
                background-color: #dc3545;
                color: var(--card-bg);
            }

            /* --- No Posts Message --- */
            .no-posts-message {
                grid-column: 1 / -1;
                text-align: center;
                color: var(--gray-text);
                font-size: 1.1rem;
                padding: 50px 0;
                background-color: var(--card-bg);
                border-radius: 8px;
                box-shadow: 0 4px 12px var(--shadow-light);
            }
            .no-posts-message i {
                font-size: 1.8rem;
                color: var(--primary-color); /* Icon màu xanh dương */
                margin-bottom: 10px;
                display: block;
            }
            .no-posts-message a {
                color: var(--primary-color); /* Link màu xanh dương */
                text-decoration: underline;
                transition: color 0.3s ease;
            }
            .no-posts-message a:hover {
                color: var(--secondary-color);
            }

            /* --- Responsive Adjustments --- */
            @media (max-width: 992px) {
                .header h1 {
                    font-size: 2.2rem;
                }
                .header h1 .fas.fa-tooth {
                    font-size: 2rem;
                }
                .featured-post {
                    flex-direction: column;
                }
                .featured-post-img {
                    width: 100%;
                    height: 250px;
                }
                .featured-post-content h2 {
                    font-size: 1.8rem;
                }
                .other-posts-grid {
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                }
            }

            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }
                .header {
                    padding: 15px 0;
                }
                .header h1 {
                    font-size: 1.8rem;
                }
                .header h1 .fas.fa-tooth {
                    font-size: 1.6rem;
                }
                .section-title {
                    font-size: 1.5rem;
                }
                .post-form {
                    padding: 20px;
                    margin-bottom: 30px;
                }
                .featured-post-img {
                    height: 220px;
                }
                .featured-post-content {
                    padding: 20px;
                }
                .featured-post-content h2 {
                    font-size: 1.5rem;
                }
                .featured-post-content p {
                    font-size: 0.95rem;
                }
                .other-posts-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
                .blog-card img {
                    height: 160px;
                }
                .blog-card h3 {
                    font-size: 1.1rem;
                }
                .blog-card p {
                    font-size: 0.85rem;
                    -webkit-line-clamp: 5;
                }
                .actions {
                    flex-direction: column; /* Xếp chồng các nút trên mobile */
                    align-items: stretch; /* Đảm bảo các nút kéo dài toàn bộ chiều rộng */
                    gap: 8px;
                }
            }

            @media (max-width: 480px) {
                .header h1 {
                    font-size: 1.5rem;
                    letter-spacing: 0;
                }
                .header h1 .fas.fa-tooth {
                    font-size: 1.3rem;
                    margin-right: 8px;
                }
                .header p {
                    font-size: 0.9rem;
                }
                .post-form button {
                    font-size: 1rem;
                }
                .featured-post-img {
                    height: 180px;
                }
                .featured-post-content h2 {
                    font-size: 1.3rem;
                }
                .featured-post-content p {
                    font-size: 0.9rem;
                    -webkit-line-clamp: 6;
                }
            }
        </style>
    </head>
    <body>
        <div class="logo-home">
                                 <a href="<%= homeUrl %>" style="display: flex; align-items: center; gap: 10px; text-decoration: none;">
    <img src="<%= request.getContextPath()%>/img/logo.png" alt="Logo" style="height: 50px;">
    <span style="font-size: 1.6rem; font-weight: bold; color: #287bff;">Trang Chủ</span>
</a>
        </div>

        <div class="header">
            <div class="container">
                <h1><i class="fas fa-tooth"></i> Tin tức Nha khoa</h1>
                <p>Cập nhật thông tin nhanh và chính xác nhất về sức khỏe răng miệng.</p>
            </div>
        </div>

        <div class="container">
            <%-- STAFF: Hiển thị form đăng bài --%>
            <% if (isStaff) { %>
            <div class="post-form">
                <h3>Đăng bài viết mới</h3>
                <form action="blog" method="post" enctype="multipart/form-data">
                    <label for="title">Tiêu đề bài viết:</label>
                    <input type="text" id="title" name="title" placeholder="Tiêu đề chính của tin tức..." required>

                    <label for="content">Nội dung:</label>
                    <textarea id="content" name="content" placeholder="Điền nội dung chi tiết bài viết tại đây..." rows="10" required></textarea>

                    <label for="image">Ảnh minh họa:</label>
                    <input type="file" name="image" accept="image/*" onchange="previewImage(event)"><br>
                    <img id="newPreview" src="#" alt="Ảnh mới"><br> <%-- Loại bỏ <br> thừa --%>
                    <button type="submit"><i class="fas fa-paper-plane"></i> Đăng bài</button>
                </form>
            </div>
            <% } %>

            <%-- Featured Post Section --%>
            <% if (featuredPost != null) {%>
            <h2 class="section-title">Bài Viết Mới Nhất</h2>
            <div class="featured-post">
                <div class="featured-post-img">
                    <img src="<%= request.getContextPath() + "/" + featuredPost.imageUrl%>" alt="<%= featuredPost.title%>" onerror="this.onerror=null;this.src='<%= request.getContextPath()%>/img/default-dental-placeholder.jpg';">
                </div>
                <div class="featured-post-content">
                    <h2>
                        <a href="blog?action=detail&blog_id=<%= featuredPost.blogId%>" style="text-decoration: none; color: #0056b3;">
                            <%= featuredPost.title%>
                        </a>
                    </h2>
                    <p><%= featuredPost.content.length() > 400 ? featuredPost.content.substring(0, 400) + "..." : featuredPost.content%></p>
                    <div class="featured-post-meta">
                        <small><i class="far fa-clock"></i> <%= new SimpleDateFormat("HH:mm dd/MM/yyyy").format(featuredPost.getCreatedAt())%></small>
                        <% if (isStaff) {%>
                        <div class="actions">
                            <a href="blog?action=edit&blog_id=<%= featuredPost.blogId%>"><i class="fas fa-edit"></i> Sửa</a>
                            <form action="blog" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="blog_id" value="<%= featuredPost.blogId%>">
                                <button type="submit"><i class="fas fa-trash-alt"></i> Xóa</button>
                            </form>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>

            <%-- Other Posts Section --%>
            <% if (otherPosts != null && !otherPosts.isEmpty()) { %>
            <h2 class="section-title">Tiêu Điểm</h2>
            <div class="other-posts-grid">
                <% for (BlogPost p : otherPosts) {%>
                <div class="blog-card">
                    <% if (p.imageUrl != null && !p.imageUrl.isEmpty()) {%>
                    <img src="<%= request.getContextPath() + "/" + p.imageUrl%>" alt="<%= p.title%>" onerror="this.onerror=null;this.src='<%= request.getContextPath()%>/img/default-dental-placeholder.jpg';">
                    <% }%>
                    <div class="blog-content">
                        <h3>
                            <a href="blog?action=detail&blog_id=<%= p.blogId%>" style="text-decoration: none; color: #0056b3;">
                                <%= p.title%>
                            </a>
                        </h3>
                        <p><%= p.content.length() > 180 ? p.content.substring(0, 180) + "..." : p.content%></p>
                        <small><i class="far fa-clock"></i> <%= new SimpleDateFormat("HH:mm dd/MM/yyyy").format(p.getCreatedAt())%></small>

                        <% if (isStaff) {%>
                        <div class="actions">
                            <a href="blog?action=edit&blog_id=<%= p.blogId%>"><i class="fas fa-edit"></i> Sửa</a>
                            <form action="blog" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="blog_id" value="<%= p.blogId%>">
                                <button type="submit"><i class="fas fa-trash-alt"></i> Xóa</button>
                            </form>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% }%>
            </div>
            <% } else if (featuredPost == null) { %>
            <div class="no-posts-message">
                <i class="fas fa-newspaper"></i>
                <p>Hiện chưa có bài viết nào được đăng.</p>
                <% if (isStaff) { %>
                <p>Hãy là người đầu tiên đăng tin! <a href="#top-of-form">Đăng bài ngay</a></p>
                <% } %>
            </div>
            <% }%>
        </div>

    </body>
</html>

<script>
    function previewImage(event) {
        const file = event.target.files?.[0];
        const preview = document.getElementById("newPreview");
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = "block";
            };
            reader.readAsDataURL(file);
        } else {
            preview.style.display = "none";
            preview.src = "#"; // Reset src when no file
        }
    }
</script>