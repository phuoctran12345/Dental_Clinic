<%-- Document : staff_doilich Created on : 17 thg 7, 2025, 21:02:48 Author : tranhongphuoc --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Đổi lịch hẹn - Staff</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                body {
                    background: #f4f6fb;
                    font-family: Arial, sans-serif;
                }

                .container {
                    max-width: 600px;
                    margin: 40px auto;
                    background: #fff;
                    border-radius: 12px;
                    box-shadow: 0 2px 8px #0001;
                    padding: 32px;
                }

                .form-label {
                    font-weight: 500;
                }

                .time-slot {
                    display: inline-block;
                    margin: 4px 6px 4px 0;
                    padding: 8px 16px;
                    border-radius: 6px;
                    border: 1px solid #bbb;
                    background: #f8f9fa;
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .time-slot.selected {
                    background: #00796b;
                    color: #fff;
                    border-color: #00796b;
                }

                .time-slot.booked {
                    background: #fee2e2;
                    color: #dc2626;
                    border-color: #ef4444;
                    cursor: not-allowed;
                }

                .time-slot.past {
                    background: #cfd2d6;
                    color: #555;
                    border-color: #bbb;
                    cursor: not-allowed;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h3 class="mb-4">Đổi lịch hẹn cho bệnh nhân</h3>
                <form id="rescheduleForm" method="post"
                    action="<%=request.getContextPath()%>/RescheduleAppointmentServlet">
                    <div class="mb-3">
                        <label class="form-label">Chọn lịch hẹn cần đổi:</label>
                        <select id="appointmentId" name="appointmentId" class="form-select" required
                            onchange="onAppointmentChange()">
                            <% java.util.List<model.Appointment> appointments = (java.util.List<model.Appointment>)
                                    request.getAttribute("appointments");
                                    if (appointments != null) {
                                    for (model.Appointment ap : appointments) {
                                    %>
                                    <option value="<%=ap.getAppointmentId()%>" data-doctor-id="<%=ap.getDoctorId()%>">
                                        [#<%=ap.getAppointmentId()%>] <%=ap.getPatientName()%> - BS:
                                                <%=ap.getDoctorName()%> - Ngày: <%=ap.getFormattedDate()%> - Ca:
                                                        <%=ap.getFormattedTime()%>
                                    </option>
                                    <% } } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Chọn ngày mới:</label>
                        <input type="date" id="newDate" name="newDate" class="form-control" required
                            onchange="if(this.value) loadStaffSlots()">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Chọn ca khám mới:</label>
                        <div id="slotGrid"></div>
                        <input type="hidden" name="newSlotId" id="newSlotId">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Lý do đổi lịch:</label>
                        <textarea name="reason" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">Xác nhận đổi lịch</button>
                    </div>
                </form>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <%-- Sinh JS map appointmentId -> doctorId --%>
                <% java.util.List<model.Appointment> appointments = (java.util.List<model.Appointment>)
                        request.getAttribute("appointments");
                        StringBuilder mapBuilder = new StringBuilder("{");
                        if (appointments != null) {
                        for (int i = 0; i < appointments.size(); i++) { model.Appointment ap=appointments.get(i);
                            mapBuilder.append("\"").append(ap.getAppointmentId()).append("\":").append(ap.getDoctorId());
                            if (i < appointments.size() - 1) mapBuilder.append(","); } } mapBuilder.append("}"); %>
                            <script>
                                let appointmentDoctorMap = <%= mapBuilder.toString() %>;
                            </script>
                            <script>
                                function onAppointmentChange() {
                                    document.getElementById('slotGrid').innerHTML = '';
                                    document.getElementById('newSlotId').value = '';
                                }

                                function loadStaffSlots() {
                                    const appointmentId = document.getElementById('appointmentId').value;
                                    const doctorId = appointmentDoctorMap[appointmentId];
                                    const date = document.getElementById('newDate').value;
                                    if (!doctorId || !date || !appointmentId) return;
                                    fetch('<%=request.getContextPath()%>/GetAvailableSlotsServlet?doctorId=' + doctorId + '&date=' + date + '&appointmentId=' + appointmentId)
                                        .then(res => res.json())
                                        .then(data => renderSlotGrid(data))
                                        .catch(err => {
                                            document.getElementById('slotGrid').innerHTML = '<span class="text-danger">Lỗi tải ca khám!</span>';
                                        });
                                }

                                function renderSlotGrid(slots) {
                                    const grid = document.getElementById('slotGrid');
                                    grid.innerHTML = '';
                                    if (!slots || slots.length === 0) {
                                        grid.innerHTML = '<span class="text-danger">Không còn ca khám trống!</span>';
                                        return;
                                    }
                                    slots.forEach(slot => {
                                        const btn = document.createElement('button');
                                        btn.type = 'button';
                                        btn.className = 'time-slot';
                                        btn.textContent = `${slot.startTime} - ${slot.endTime}`;
                                        btn.onclick = function () {
                                            document.querySelectorAll('.time-slot').forEach(e => e.classList.remove('selected'));
                                            btn.classList.add('selected');
                                            document.getElementById('newSlotId').value = slot.slotId;
                                        };
                                        grid.appendChild(btn);
                                    });
                                }
                            </script>
        </body>

        </html>