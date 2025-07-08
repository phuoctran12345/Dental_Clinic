<%@page import="model.User" %>
    <%@page import="dao.MedicineDAO" %>
        <%@page import="model.Medicine" %>
            <%@page import="java.util.List" %>
                <%@ page contentType="text/html;charset=UTF-8" language="java" %>

                    <% MedicineDAO dao=new MedicineDAO(); List<Medicine> medicines = dao.getAllMedicine();
                        %>

                        <!DOCTYPE html>
                        <html lang="vi">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Nhập báo cáo y tế</title>
                            <!-- Bootstrap CSS -->
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <!-- Font Awesome -->
                            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                                rel="stylesheet">
                            <style>
                                body {
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    min-height: 100vh;
                                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                                    padding: 20px 0;
                                }

                                .main-container {
                                    background: rgba(255, 255, 255, 0.95);
                                    border-radius: 20px;
                                    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                                    backdrop-filter: blur(10px);
                                    overflow: hidden;
                                }

                                .header-section {
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    color: white;
                                    text-align: center;
                                    padding: 30px;
                                }

                                .header-section h1 {
                                    margin: 0;
                                    font-size: 2.5rem;
                                    font-weight: 600;
                                }

                                .info-section {
                                    background: #e8f5e8;
                                    border-left: 4px solid #4CAF50;
                                    padding: 20px;
                                    margin: 30px 0;
                                    border-radius: 8px;
                                }

                                .form-section {
                                    background: white;
                                    padding: 30px;
                                    border-radius: 15px;
                                    margin: 20px 0;
                                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                                }

                                .form-section h3 {
                                    color: #667eea;
                                    border-bottom: 2px solid #f1f3f4;
                                    padding-bottom: 10px;
                                    margin-bottom: 25px;
                                    font-weight: 600;
                                }

                                .form-label {
                                    font-weight: 600;
                                    color: #333;
                                    margin-bottom: 8px;
                                }

                                .form-control,
                                .form-select {
                                    border-radius: 10px;
                                    border: 2px solid #e1e5e9;
                                    padding: 12px 15px;
                                    transition: all 0.3s ease;
                                }

                                .form-control:focus,
                                .form-select:focus {
                                    border-color: #667eea;
                                    box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                                }

                                .medicine-card {
                                    background: #f8f9ff;
                                    border: 2px solid #e1e5e9;
                                    border-radius: 15px;
                                    padding: 20px;
                                    margin: 15px 0;
                                    transition: all 0.3s ease;
                                }

                                .medicine-card:hover {
                                    border-color: #667eea;
                                    transform: translateY(-2px);
                                    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.15);
                                }

                                .medicine-card h4 {
                                    color: #667eea;
                                    margin-bottom: 15px;
                                    font-weight: 600;
                                }

                                .btn-primary {
                                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                    border: none;
                                    border-radius: 25px;
                                    padding: 12px 30px;
                                    font-weight: 600;
                                    font-size: 1.1rem;
                                    transition: all 0.3s ease;
                                }

                                .btn-primary:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
                                }

                                .btn-secondary {
                                    background: #6c757d;
                                    border: none;
                                    border-radius: 25px;
                                    padding: 12px 30px;
                                    font-weight: 600;
                                    margin-left: 15px;
                                    transition: all 0.3s ease;
                                }

                                .btn-secondary:hover {
                                    background: #5a6268;
                                    transform: translateY(-2px);
                                }

                                .info-badge {
                                    display: inline-flex;
                                    align-items: center;
                                    background: #667eea;
                                    color: white;
                                    padding: 8px 15px;
                                    border-radius: 20px;
                                    font-weight: 500;
                                    margin: 5px 10px 5px 0;
                                }

                                .medicine-select-section {
                                    background: #fff;
                                    border-radius: 10px;
                                    padding: 20px;
                                    margin: 20px 0;
                                }

                                .select-wrapper {
                                    position: relative;
                                }

                                .select-wrapper select {
                                    appearance: none;
                                    background-image: url("data:image/svg+xml;charset=US-ASCII,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'><path fill='%23666' d='m0 0 2 2 2-2z'/></svg>");
                                    background-repeat: no-repeat;
                                    background-position: right 15px center;
                                    background-size: 12px;
                                }

                                .action-buttons {
                                    text-align: center;
                                    padding: 30px 0;
                                }

                                .btn-ai-note {
                                    position: absolute;
                                    top: 5px;
                                    right: 5px;
                                    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                                    color: white;
                                    border: none;
                                    border-radius: 20px;
                                    padding: 8px 15px;
                                    font-size: 0.85rem;
                                    font-weight: 600;
                                    transition: all 0.3s ease;
                                    box-shadow: 0 2px 8px rgba(255, 107, 107, 0.3);
                                }

                                .btn-ai-note:hover {
                                    background: linear-gradient(135deg, #ee5a24 0%, #ff6b6b 100%);
                                    transform: translateY(-2px);
                                    box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
                                    color: white;
                                }

                                .btn-ai-note:disabled {
                                    background: #ccc;
                                    transform: none;
                                    box-shadow: none;
                                    cursor: not-allowed;
                                }

                                .ai-loading {
                                    margin-top: 10px;
                                    padding: 10px;
                                    background: linear-gradient(135deg, #74b9ff 0%, #0984e3 100%);
                                    color: white;
                                    border-radius: 8px;
                                    font-size: 0.9rem;
                                    text-align: center;
                                    animation: pulse 1.5s infinite;
                                }

                                @keyframes pulse {
                                    0% {
                                        opacity: 1;
                                    }

                                    50% {
                                        opacity: 0.7;
                                    }

                                    100% {
                                        opacity: 1;
                                    }
                                }

                                @media (max-width: 768px) {
                                    .main-container {
                                        margin: 10px;
                                        border-radius: 15px;
                                    }

                                    .header-section {
                                        padding: 20px;
                                    }

                                    .header-section h1 {
                                        font-size: 2rem;
                                    }

                                    .form-section {
                                        padding: 20px;
                                    }

                                    .btn-ai-note {
                                        position: static;
                                        margin-top: 10px;
                                        width: 100%;
                                    }
                                }
                            </style>
                            <script>
                                function renderMedicineFields() {
                                    const num = document.getElementById("numMedicines").value;
                                    const container = document.getElementById("medicineContainer");
                                    container.innerHTML = "";

                                    for (let i = 0; i < num; i++) {
                                        const div = document.createElement("div");
                                        div.className = "medicine-card";
                                        div.innerHTML = `
                    <h4><i class="fas fa-pills me-2"></i>Thuốc ${i + 1}:</h4>
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form-label">Chọn thuốc:</label>
                            <div class="select-wrapper">
                                <select name="medicine_id" class="form-select" required>
                                    <option value="">-- Chọn thuốc --</option>
                                    <% for (Medicine med : medicines) { %>
                                        <option value="<%= med.getMedicineId() %>"><%= med.getName() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Số lượng:</label>
                            <input type="number" name="quantity" class="form-control" min="1" required placeholder="Nhập số lượng">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Cách dùng:</label>
                            <textarea name="usage" class="form-control" rows="2" placeholder="Ví dụ: Uống 2 viên/ngày sau ăn"></textarea>
                        </div>
                    </div>
                `;
                                        container.appendChild(div);
                                    }
                                }

                                // Function để tạo ghi chú AI
                                function generateAiNote() {
                                    console.log('=== Starting AI note generation ===');

                                    // Lấy dữ liệu từ form
                                    const diagnosis = document.querySelector('textarea[name="diagnosis"]').value;
                                    const treatmentPlan = document.querySelector('textarea[name="treatment_plan"]').value;
                                    const currentNote = document.getElementById('noteTextarea').value;
                                    const patientId = '<%= request.getParameter("patient_id") %>';
                                    const appointmentId = '<%= request.getParameter("appointment_id") %>';

                                    // Debug thông tin cơ bản
                                    console.log('Diagnosis:', diagnosis);
                                    console.log('Treatment Plan:', treatmentPlan);
                                    console.log('Current Note:', currentNote);
                                    console.log('Patient ID:', patientId);
                                    console.log('Appointment ID:', appointmentId);

                                    // Lấy thông tin thuốc
                                    const numMedicines = parseInt(document.getElementById('numMedicines').value) || 0;
                                    const medicineSelects = document.querySelectorAll('select[name="medicine_id"]');
                                    const quantityInputs = document.querySelectorAll('input[name="quantity"]');
                                    const usageTextareas = document.querySelectorAll('textarea[name="usage"]');

                                    console.log('Number of medicines:', numMedicines);
                                    console.log('Medicine selects found:', medicineSelects.length);
                                    console.log('Quantity inputs found:', quantityInputs.length);
                                    console.log('Usage textareas found:', usageTextareas.length);

                                    // Validate dữ liệu
                                    if (!diagnosis.trim() && !treatmentPlan.trim()) {
                                        alert('Vui lòng nhập ít nhất chẩn đoán hoặc kế hoạch điều trị trước khi sử dụng AI!');
                                        return;
                                    }

                                    // Disable nút và hiển thị loading
                                    const btn = document.getElementById('aiNoteBtn');
                                    const loading = document.getElementById('aiNoteLoading');
                                    btn.disabled = true;
                                    loading.style.display = 'block';

                                    // Tạo FormData
                                    const formData = new FormData();
                                    formData.append('diagnosis', diagnosis);
                                    formData.append('treatment_plan', treatmentPlan);
                                    formData.append('current_note', currentNote);
                                    formData.append('patient_id', patientId);
                                    formData.append('appointment_id', appointmentId);
                                    formData.append('num_medicines', numMedicines.toString());

                                    // Debug medicine data chi tiết
                                    console.log('=== Medicine Data Debug ===');
                                    for (let i = 0; i < numMedicines; i++) {
                                        console.log(`Medicine ${i + 1}:`);

                                        if (i < medicineSelects.length && medicineSelects[i]) {
                                            const medicineId = medicineSelects[i].value;
                                            const medicineName = medicineSelects[i].selectedOptions[0] ? medicineSelects[i].selectedOptions[0].text : 'N/A';
                                            console.log(`  - ID: ${medicineId}`);
                                            console.log(`  - Name: ${medicineName}`);
                                            if (medicineId) {
                                                formData.append('medicine_id', medicineId);
                                            }
                                        } else {
                                            console.log(`  - No medicine select found at index ${i}`);
                                        }

                                        if (i < quantityInputs.length && quantityInputs[i]) {
                                            const quantity = quantityInputs[i].value;
                                            console.log(`  - Quantity: ${quantity}`);
                                            if (quantity) {
                                                formData.append('quantity', quantity);
                                            }
                                        } else {
                                            console.log(`  - No quantity input found at index ${i}`);
                                        }

                                        if (i < usageTextareas.length && usageTextareas[i]) {
                                            const usage = usageTextareas[i].value;
                                            console.log(`  - Usage: ${usage}`);
                                            formData.append('usage', usage || '');
                                        } else {
                                            console.log(`  - No usage textarea found at index ${i}`);
                                        }
                                    }

                                    // Debug FormData 
                                    console.log('=== FormData Debug ===');
                                    for (let pair of formData.entries()) {
                                        console.log(pair[0] + ': ' + pair[1]);
                                    }

                                    // Gửi request đến servlet
                                    console.log('Sending request to MedicalNoteAiServlet...');
                                    fetch('../../MedicalNoteAiServlet', {
                                        method: 'POST',
                                        body: formData
                                    })
                                        .then(response => {
                                            console.log('Response status:', response.status);
                                            return response.text();
                                        })
                                        .then(data => {
                                            console.log('AI Response received:', data);

                                            // Cập nhật textarea với ghi chú từ AI
                                            document.getElementById('noteTextarea').value = data;

                                            // Hiển thị thông báo thành công
                                            showSuccessMessage('Ghi chú đã được cải thiện bằng AI!');
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert('Có lỗi xảy ra khi tạo ghi chú AI. Vui lòng thử lại!');
                                        })
                                        .finally(() => {
                                            // Re-enable nút và ẩn loading
                                            btn.disabled = false;
                                            loading.style.display = 'none';
                                        });
                                }

                                // Function hiển thị thông báo thành công
                                function showSuccessMessage(message) {
                                    const alert = document.createElement('div');
                                    alert.className = 'alert alert-success alert-dismissible fade show';
                                    alert.style.position = 'fixed';
                                    alert.style.top = '20px';
                                    alert.style.right = '20px';
                                    alert.style.zIndex = '9999';
                                    alert.style.maxWidth = '300px';
                                    alert.innerHTML = `
                                        <i class="fas fa-check-circle me-2"></i>${message}
                                        <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
                                    `;
                                    document.body.appendChild(alert);

                                    // Tự động ẩn sau 3 giây
                                    setTimeout(() => {
                                        if (alert.parentElement) {
                                            alert.remove();
                                        }
                                    }, 3000);
                                }
                            </script>
                        </head>

                        <body>
                            <div class="container">
                                <div class="main-container">
                                    <div class="header-section">
                                        <h1><i class="fas fa-file-medical-alt me-3"></i>Nhập báo cáo y tế</h1>
                                    </div>

                                    <div class="p-4">
                                        <div class="info-section">
                                            <h5><i class="fas fa-info-circle me-2"></i>Thông tin cuộc hẹn:</h5>
                                            <div class="mt-3">
                                                <span class="info-badge">
                                                    <i class="fas fa-hashtag me-2"></i>
                                                    Appointment ID: <%= request.getParameter("appointment_id") %>
                                                </span>
                                                <span class="info-badge">
                                                    <i class="fas fa-user me-2"></i>
                                                    Patient ID: <%= request.getParameter("patient_id") %>
                                                </span>
                                                <span class="info-badge">
                                                    <i class="fas fa-user-md me-2"></i>
                                                    Doctor ID: <%= request.getParameter("doctor_id") %>
                                                </span>
                                            </div>
                                        </div>

                                        <form action="../../AddReportServlet" method="post">
                                            <input type="hidden" name="appointment_id" value="<%= request.getParameter("appointment_id") %>">
                                            <input type="hidden" name="patient_id" value="<%= request.getParameter("patient_id") %>">
                                            <input type="hidden" name="doctor_id" value="<%= request.getParameter("doctor_id") %>">

                                            <div class="form-section">
                                                <h3><i class="fas fa-stethoscope me-2"></i>Chẩn đoán và điều trị</h3>

                                                <div class="mb-4">
                                                    <label class="form-label">
                                                        <i class="fas fa-search me-2"></i>Chẩn đoán:
                                                    </label>
                                                    <textarea name="diagnosis" class="form-control" rows="4" required
                                                        placeholder="Nhập chẩn đoán chi tiết cho bệnh nhân..."></textarea>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label">
                                                        <i class="fas fa-procedures me-2"></i>Kế hoạch điều trị:
                                                    </label>
                                                    <textarea name="treatment_plan" class="form-control" rows="4"
                                                        required
                                                        placeholder="Mô tả kế hoạch điều trị chi tiết..."></textarea>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label">
                                                        <i class="fas fa-sticky-note me-2"></i>Ghi chú:
                                                    </label>
                                                    <div class="position-relative">
                                                        <textarea name="note" id="noteTextarea" class="form-control"
                                                            rows="6"
                                                            placeholder="Ghi chú nha khoa cho bệnh nhân - sử dụng AI để tự động tạo ghi chú chuyên nghiệp dựa trên chẩn đoán và điều trị..."></textarea>
                                                        <button type="button" id="aiNoteBtn" class="btn btn-ai-note"
                                                            onclick="generateAiNote()">
                                                            <i class="fas fa-magic me-2"></i>AI Cải thiện ghi chú
                                                        </button>
                                                    </div>
                                                    <div id="aiNoteLoading" class="ai-loading" style="display: none;">
                                                        <i class="fas fa-spinner fa-spin me-2"></i>AI đang tạo ghi
                                                        chú...
                                                    </div>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label">
                                                        <i class="fas fa-signature me-2"></i>Chữ ký bác sĩ:
                                                    </label>
                                                    <input type="text" name="sign" class="form-control" required
                                                        placeholder="Nhập tên bác sĩ">
                                                </div>
                                            </div>

                                            <div class="form-section">
                                                <h3><i class="fas fa-pills me-2"></i>Kê đơn thuốc</h3>

                                                <div class="medicine-select-section">
                                                    <label class="form-label">
                                                        <i class="fas fa-list-ol me-2"></i>Số loại thuốc:
                                                    </label>
                                                    <div class="select-wrapper">
                                                        <select id="numMedicines" class="form-select"
                                                            onchange="renderMedicineFields()">
                                                            <option value="0">0 (Không kê thuốc)</option>
                                                            <option value="1">1</option>
                                                            <option value="2">2</option>
                                                            <option value="3">3</option>
                                                            <option value="4">4</option>
                                                            <option value="5">5</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div id="medicineContainer"></div>
                                            </div>

                                            <div class="action-buttons">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="fas fa-save me-2"></i>Lưu báo cáo
                                                </button>
                                                <a href="../../DoctorAppointmentsToanServlet" class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- Bootstrap JS -->
                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>