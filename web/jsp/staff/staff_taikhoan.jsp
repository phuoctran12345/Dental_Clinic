<%@ page import="model.Staff" %>
    <%@ page import="model.User" %>

            <%@ include file="/jsp/staff/staff_header.jsp" %>
                <%@ include file="/jsp/staff/staff_menu.jsp" %>

                    <% Staff staff=(Staff) request.getAttribute("staff"); User user=(User) request.getAttribute("user");
                        // Debug logging System.out.println("===JSP STAFF_TAIKHOAN DEBUG===");
System.out.println(" [JSP] Request URL: " + request.getRequestURL());
System.out.println(" [JSP] Method: " + request.getMethod());
System.out.println(" [JSP] staff from request.getAttribute: " + (staff != null ? staff.toString() : " null"));
                        System.out.println(" [JSP] user fromrequest.getAttribute: " + (user != null ? user.toString() : " null"));
                        System.out.println("===JSP DEBUG END==="); %>
<!DOCTYPE html>
<html>
<head>
    <title>Th�ng tin t�i kho?n Staff</title>
    <link rel=" stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
                        <style>
                            body {
                                font-family: 'Roboto', sans-serif;
                                background: #F9FAFB;
                                margin: 0;
                            }

                            .profile-card {
                                background: #fff;
                                border-radius: 8px;
                                padding: 30px;
                                max-width: 600px;
                                margin: 40px auto;
                                box-shadow: 0 2px 8px #eee;
                            }

                            .profile-avatar {
                                width: 100px;
                                height: 100px;
                                border-radius: 50%;
                                object-fit: cover;
                                border: 2px solid #e0e0e0;
                                background: #f9f9f9;
                            }

                            .profile-row {
                                display: flex;
                                align-items: center;
                                margin-bottom: 18px;
                                padding: 10px;
                                border-bottom: 1px solid #eee;
                            }

                            .profile-label {
                                min-width: 140px;
                                font-weight: 600;
                                color: #333;
                            }

                            .profile-value {
                                flex: 1;
                                color: #666;
                            }

                            .server-error {
                                color: #e74c3c;
                                background: #fde8e8;
                                border-radius: 6px;
                                padding: 10px;
                                margin-bottom: 15px;
                            }

                            .server-success {
                                color: #27ae60;
                                background: #d5f4e6;
                                border-radius: 6px;
                                padding: 10px;
                                margin-bottom: 15px;
                            }
                        </style>
                        </head>

                        <body>
                            <div class="profile-card">
                                <h2 style="text-align:center;">Th�ng Tin Nh�n Vi�n</h2>

                                <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                                    <div class="server-error">
                                        <%= error %>
                                    </div>
                                    <% } %>

                                        <% String success=(String) request.getAttribute("success"); if (success !=null)
                                            { %>
                                            <div class="server-success">
                                                <%= success %>
                                            </div>
                                            <% } %>

                                                <% if (staff !=null) { %>
                                                    <!-- Avatar Section -->
                                                    <div style="text-align: center; margin-bottom: 30px;">
                                                        <% if (staff.getAvatar() !=null && !staff.getAvatar().isEmpty())
                                                            { %>
                                                            <img src="<%= request.getContextPath() + staff.getAvatar() %>"
                                                                class="profile-avatar" alt="Avatar">
                                                            <% } else { %>
                                                                <div class="profile-avatar"
                                                                    style="display:inline-flex;align-items:center;justify-content:center;color:#aaa;">
                                                                    <i class="fas fa-user" style="font-size: 40px;"></i>
                                                                </div>
                                                                <% } %>
                                                                    <p style="margin-top: 10px; color: #666;">?nh ??i
                                                                        di?n</p>
                                                                    <!-- Form c?p nh?t avatar -->
                                                                    <form
                                                                        action="<%=request.getContextPath()%>/StaffProfileServlet"
                                                                        method="post" enctype="multipart/form-data"
                                                                        style="text-align:center;margin-bottom:20px;">
                                                                        <input type="hidden" name="type"
                                                                            value="update_avatar" />
                                                                        <input type="hidden" name="staffId"
                                                                            value="<%= staff.getStaffId() %>" />
                                                                        <input type="file" name="profilePicture"
                                                                            accept=".png,.jpg,.jpeg" required
                                                                            style="margin-bottom:10px;" />
                                                                        <button type="submit"
                                                                            style="padding:6px 18px;background:#2980b9;color:#fff;border:none;border-radius:4px;cursor:pointer;">??i
                                                                            ?nh ??i di?n</button>
                                                                    </form>
                                                                    <!-- Form c?p nh?t t�i kho?n -->
                                                                    <form
                                                                        action="<%=request.getContextPath()%>/StaffProfileServlet"
                                                                        method="post" style="margin-bottom: 30px;"
                                                                        onsubmit="return validatePasswordChange();">
                                                                        <input type="hidden" name="type"
                                                                            value="update_account" />
                                                                        <input type="hidden" name="userId"
                                                                            value="<%= staff.getUserId() %>" />
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">Email:</div>
                                                                            <div class="profile-value">
                                                                                <input type="email" name="email"
                                                                                    value="<%= user != null ? user.getEmail() : "" %>"
                                                                                    required
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">M?t kh?u c?:
                                                                            </div>
                                                                            <div class="profile-value">
                                                                                <input type="password"
                                                                                    name="oldPassword" id="oldPassword"
                                                                                    placeholder="Nh?p m?t kh?u hi?n t?i"
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">M?t kh?u m?i:
                                                                            </div>
                                                                            <div class="profile-value">
                                                                                <input type="password" name="password"
                                                                                    id="password"
                                                                                    placeholder="?? tr?ng n?u kh�ng ??i"
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">X�c nh?n m?t kh?u
                                                                                m?i:
                                                                            </div>
                                                                            <div class="profile-value">
                                                                                <input type="password"
                                                                                    name="confirmPassword"
                                                                                    id="confirmPassword"
                                                                                    placeholder="Nh?p l?i m?t kh?u m?i"
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div id="passwordError"
                                                                            style="color:red;text-align:center;display:none;margin-bottom:10px;">
                                                                        </div>
                                                                        <div style="text-align:center;margin-top:20px;">
                                                                            <button type="submit"
                                                                                style="padding:10px 30px;font-size:16px;background:#2980b9;color:#fff;border:none;border-radius:5px;cursor:pointer;">L?u
                                                                                t�i kho?n</button>
                                                                        </div>
                                                                    </form>

                                                                    <!-- FORM c?p nh?t th�ng tin -->
                                                                    <form
                                                                        action="<%=request.getContextPath()%>/StaffProfileServlet"
                                                                        method="post" style="margin-bottom: 30px;">
                                                                        <input type="hidden" name="type"
                                                                            value="update_info" />
                                                                        <input type="hidden" name="staffId"
                                                                            value="<%= staff.getStaffId() %>" />
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">M� nh�n vi�n:
                                                                            </div>
                                                                            <div class="profile-value">
                                                                                <%= staff.getStaffId() %>
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">H? t�n:</div>
                                                                            <div class="profile-value">
                                                                                <input type="text" name="fullName"
                                                                                    value="<%= staff.getFullName() != null ? staff.getFullName() : "" %>"
                                                                                    required
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">S? ?i?n tho?i:
                                                                            </div>
                                                                            <div class="profile-value">
                                                                                <input type="text" name="phone"
                                                                                    value="<%= staff.getPhone() != null ? staff.getPhone() : "" %>"
                                                                                    required
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">Ng�y sinh:</div>
                                                                            <div class="profile-value">
                                                                                <input type="date" name="dateOfBirth"
                                                                                    value="<%= staff.getDateOfBirth() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(staff.getDateOfBirth())
                                                                                    : "" %>" required
                                                                                style="width:90%;padding:6px;"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">Gi?i t�nh:</div>
                                                                            <div class="profile-value">
                                                                                <select name="gender" required
                                                                                    style="width:90%;padding:6px;">
                                                                                    <option value="male" <%="male"
                                                                                        .equals(staff.getGender())
                                                                                        ? "selected" : "" %>>Nam
                                                                                    </option>
                                                                                    <option value="female" <%="female"
                                                                                        .equals(staff.getGender())
                                                                                        ? "selected" : "" %>>N?</option>
                                                                                    <option value="other" <%="other"
                                                                                        .equals(staff.getGender())
                                                                                        ? "selected" : "" %>>Kh�c
                                                                                    </option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="profile-row">
                                                                            <div class="profile-label">??a ch?:</div>
                                                                            <div class="profile-value">
                                                                                <input type="text" name="address"
                                                                                    value="<%= staff.getAddress() != null ? staff.getAddress() : "" %>"
                                                                                    required
                                                                                    style="width:90%;padding:6px;" />
                                                                            </div>
                                                                        </div>
                                                                        <div style="text-align:center;margin-top:20px;">
                                                                            <button type="submit"
                                                                                style="padding:10px 30px;font-size:16px;background:#27ae60;color:#fff;border:none;border-radius:5px;cursor:pointer;">L?u
                                                                                thay ??i</button>
                                                                        </div>
                                                                    </form>

                                                                    <!-- Th�ng tin kh�ng cho s?a -->
                                                                    <div class="profile-row">
                                                                        <div class="profile-label">Ch?c v?:</div>
                                                                        <div class="profile-value">
                                                                            <%= staff.getPosition() !=null ?
                                                                                staff.getPosition() : "Ch?a c?p nh?t" %>
                                                                        </div>
                                                                    </div>

                                                                    <div class="profile-row">
                                                                        <div class="profile-label">Lo?i h?p ??ng:</div>
                                                                        <div class="profile-value">
                                                                            <% String empType=staff.getEmploymentType();
                                                                                if("fulltime".equals(empType)) {
                                                                                out.print("To�nth?igian"); } else
                                                                                if("parttime".equals(empType)) {
                                                                                out.print("B�n th?i gian"); } else {
                                                                                out.print("Ch?ac?p nh?t"); } %>
                                                                        </div>
                                                                    </div>

                                                                    <div class="profile-row">
                                                                        <div class="profile-label">Ng�y t?o:</div>
                                                                        <div class="profile-value">
                                                                            <%= staff.getCreatedAt() !=null ? new
                                                                                java.text.SimpleDateFormat("dd/MM/yyyy").format(staff.getCreatedAt())
                                                                                : "Ch?a c?p nh?t" %>
                                                                        </div>
                                                                    </div>

                                                                    <% } else { %>
                                                                        <div
                                                                            style="text-align:center;color:#e74c3c;font-size:18px;margin-top:50px;">
                                                                            <i class="fas fa-exclamation-triangle"
                                                                                style="font-size: 48px; margin-bottom: 20px;"></i><br>
                                                                            Kh�ng t�m th?y th�ng tin nh�n vi�n!
                                                                        </div>
                                                                        <% } %>
                                                    </div>
                        </body>

                        </html>

                        <script>
                            function validatePasswordChange() {
                                var oldPass = document.getElementById('oldPassword').value.trim();
                                var newPass = document.getElementById('password').value.trim();
                                var confirmPass = document.getElementById('confirmPassword').value.trim();
                                var errorDiv = document.getElementById('passwordError');
                                errorDiv.style.display = 'none';
                                if (newPass.length > 0 || confirmPass.length > 0 || oldPass.length > 0) {
                                    if (!oldPass || !newPass || !confirmPass) {
                                        errorDiv.textContent = 'Vui l�ng nh?p ?? m?t kh?u c?, m?t kh?u m?i v� x�c nh?n m?t kh?u m?i.';
                                        errorDiv.style.display = 'block';
                                        return false;
                                    }
                                    if (newPass !== confirmPass) {
                                        errorDiv.textContent = 'M?t kh?u m?i v� x�c nh?n kh�ng kh?p!';
                                        errorDiv.style.display = 'block';
                                        return false;
                                    }
                                    if (newPass.length < 5) {
                                        errorDiv.textContent = 'M?t kh?u m?i ph?i t? 5 k� t? tr? l�n!';
                                        errorDiv.style.display = 'block';
                                        return false;
                                    }
                                }
                                return true;
                            }
                        </script>