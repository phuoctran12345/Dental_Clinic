// Hàm mở modal đổi lịch
function openRescheduleModal(appointmentId, patientName, currentDateTime, doctorId, doctorName, serviceId, serviceName) {
    // Reset form
    document.getElementById('rescheduleForm').reset();
    
    // Set các giá trị input hidden
    document.getElementById('rescheduleAppointmentId').value = appointmentId;
    document.getElementById('rescheduleDoctorId').value = doctorId;
    document.getElementById('rescheduleServiceId').value = serviceId;
    
    // Set thông tin hiển thị
    document.getElementById('reschedulePatient').textContent = patientName;
    document.getElementById('rescheduleCurrentDateTime').textContent = currentDateTime;
    document.getElementById('rescheduleServiceName').textContent = serviceName;

    // Reset các trường khác
    document.getElementById('rescheduleDatePicker').value = '';
    document.getElementById('rescheduleSlotId').value = '';
    document.getElementById('rescheduleSlotGrid').innerHTML = '';
    document.getElementById('rescheduleSlotContainer').style.display = 'none';
    document.getElementById('rescheduleSlotError').style.display = 'none';

    // Khởi tạo date picker
    initRescheduleDatePicker(doctorId);

    // Hiển thị modal
    new bootstrap.Modal(document.getElementById('rescheduleModal')).show();
}

// Khởi tạo date picker với các ngày làm việc của bác sĩ
function initRescheduleDatePicker(doctorId) {
    // Lấy ngày làm việc của bác sĩ từ server
    fetch(`${contextPath}/GetDoctorWorkDatesServlet?doctorId=${doctorId}`)
        .then(response => response.json())
        .then(workDates => {
            $('#rescheduleDatePicker').datepicker({
                format: 'dd/mm/yyyy',
                startDate: new Date(),
                daysOfWeekHighlighted: "0,6",
                autoclose: true,
                beforeShowDay: function(date) {
                    // Chỉ enable các ngày làm việc của bác sĩ
                    const dateStr = date.toISOString().split('T')[0];
                    return workDates.includes(dateStr);
                }
            }).on('changeDate', function(e) {
                loadAvailableSlots(doctorId, e.format());
            });
        });
}

// Load danh sách slot trống
function loadAvailableSlots(doctorId, date) {
    const appointmentId = document.getElementById('rescheduleAppointmentId').value;
    
    fetch(`${contextPath}/GetAvailableSlotsServlet?doctorId=${doctorId}&date=${date}&appointmentId=${appointmentId}`)
        .then(response => response.json())
        .then(slots => {
            // Hiển thị step 2
            const timeStep = document.getElementById('timeStep');
            timeStep.style.display = 'block';
            timeStep.classList.add('active');
            
            // Render slots
            const grid = document.querySelector('.time-slot-grid');
            grid.innerHTML = '';
            
            if (slots.length === 0) {
                grid.innerHTML = '<div class="no-slots">Không có ca trống trong ngày này</div>';
                return;
            }

            slots.forEach(slot => {
                const timeSlot = document.createElement('div');
                timeSlot.className = 'time-slot';
                timeSlot.textContent = formatTime(slot.startTime);
                timeSlot.onclick = () => selectTimeSlot(slot.id, timeSlot);
                grid.appendChild(timeSlot);
            });

            document.getElementById('rescheduleSlotContainer').style.display = 'block';
            document.getElementById('rescheduleSlotError').style.display = 'none';
        });
}

// Chọn slot thời gian
function selectSlot(slotId, element) {
    // Bỏ chọn slot cũ
    document.querySelectorAll('.time-slot.selected').forEach(slot => {
        slot.classList.remove('selected');
    });
    
    // Chọn slot mới
    element.classList.add('selected');
    document.getElementById('rescheduleSlotId').value = slotId;
}

// Xử lý submit form đổi lịch
document.getElementById('rescheduleForm').onsubmit = function(e) {
    e.preventDefault();
    
    if (!document.getElementById('rescheduleSlotId').value) {
        alert('Vui lòng chọn ca khám');
        return false;
    }

    // Submit form
    this.submit();
};
