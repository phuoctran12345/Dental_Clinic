<%-- 
    Document   : doctor_taikham
    Created on : May 24, 2025, 4:49:29 PM
    Author     : ASUS
--%>

<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ include file="/jsp/doctor/doctor_header.jsp" %>
<%@ include file="/jsp/doctor/doctor_menu.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Trang Tái Khám</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                overflow-x: hidden;
                overflow-y: hidden;
            }
            .taikham_container {
                font-family: Arial, sans-serif;
                padding-left: 282px;
                padding-top: 15px;
                margin-right: 10px;
                min-height: 100vh;
            }
            #menu-toggle:checked ~.taikham_container {
                transform: translateX(-125px);
                transition: transform 0.3s ease;
            }

            .taikham-header {
                font-size: 22px;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .taikham-search {
                margin-bottom: 20px;
            }

            .taikham-search input {
                width: 250px;
                padding: 8px;
                border-radius: 6px;
                border: 1px solid #ccc;
            }

            .patient-card-container {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                align-items: center;
                padding: 15px;
                margin-bottom: 15px;
                justify-content: space-between;
            }

            .patient-info {
                display: flex;
                align-items: center;
            }

            .patient-avatar {
                border-radius: 50%;
                width: 60px;
                height: 60px;
                margin-right: 15px;
            }

            .patient-details {
                font-size: 14px;
            }

            .patient-details b {
                display: block;
            }

            .btn-reexam {
                background: #007bff;
                color: white;
                border: none;
                padding: 10px 16px;
                border-radius: 8px;
                cursor: pointer;
            }

            .reexam-popup {
                position: absolute;
                background: white;
                border: 1px solid #ccc;
                padding: 15px;
                border-radius: 12px;
                width: 250px;
                display: none;
                z-index: 10;
            }

            .reexam-popup select, .reexam-popup input[type="date"] {
                width: 100%;
                padding: 6px;
                margin-top: 6px;
                margin-bottom: 10px;
                border-radius: 6px;
                border: 1px solid #ccc;
            }

            .popup-button-group {
                display: flex;
                justify-content: space-between;
            }

            .popup-button-group button {
                padding: 6px 12px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
            }

            .btn-cancel {
                background: #f87171;
                color: white;
            }

            .btn-create {
                background: #3b82f6;
                color: white;
            }

            .pagination-wrapper {
                text-align: center;
                margin-top: 20px;
            }

            .pagination-wrapper span, .pagination-wrapper a {
                display: inline-block;
                padding: 6px 12px;
                margin: 0 3px;
                border-radius: 6px;
                background: #e2e8f0;
                color: #333;
                text-decoration: none;
            }

            .pagination-wrapper .active-page {
                background: #3b82f6;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="taikham_container">
            <div class="taikham-header">Tái khám</div>

            <div class="taikham-search">
                <input type="text" placeholder="Tìm kiếm bệnh nhân" id="searchInput"/>
            </div>

            <div id="patientList">
                <c:forEach var="i" begin="1" end="6">
                    <div class="patient-card-container">
                        <div class="patient-info">
                            <img class="patient-avatar" src="https://randomuser.me/api/portraits/men/32.jpg" alt="avatar"/>
                            <div class="patient-details">
                                <b>Tên bệnh nhân</b>
                                Địa chỉ: thôn A, xã B, thành phố C<br/>
                                Giới tính: nam &nbsp;&nbsp;&nbsp;&nbsp; Tuổi: 29
                            </div>
                        </div>
                        <button class="btn-reexam" onclick="showPopup(this)">Tái khám</button>
                    </div>
                </c:forEach>
            </div>

            

            <div class="pagination-wrapper">
                <span>&laquo;</span>
                <a class="active-page" href="#">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <span>&raquo;</span>
            </div>
        </div>
        <script>
            function showPopup(button) {
                const popup = document.getElementById("reexamPopup");
                const rect = button.getBoundingClientRect();
                popup.style.top = (rect.top + window.scrollY + 40) + "px";
                popup.style.left = (rect.left + window.scrollX - 100) + "px";
                popup.style.display = "block";
            }

            function hidePopup() {
                document.getElementById("reexamPopup").style.display = "none";
            }

            $('#searchInput').on('input', function () {
                const keyword = $(this).val().toLowerCase();
                $('.patient-card-container').each(function () {
                    const name = $(this).find('.patient-details b').text().toLowerCase();
                    $(this).toggle(name.includes(keyword));
                });
            });
        </script>

    </body>
</html>
