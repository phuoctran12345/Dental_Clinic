const calendarHeader = document.getElementById('calendarHeader');
const calendarDays = document.getElementById('calendarDays');
const timeSlotForm = document.getElementById('timeSlotForm');
const selectedDateLabel = document.getElementById('selectedDateLabel');

let today = new Date();
let currentMonth = today.getMonth();
let currentYear = today.getFullYear();

function renderCalendar(month, year) {
    calendarHeader.innerHTML = `Tháng ${month + 1} - ${year}`;

    const firstDayRaw = new Date(year, month, 1).getDay();
    const firstDay = (firstDayRaw + 6) % 7; // Thứ 2 là 0, Chủ nhật là 6
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    // Xóa các ngày cũ (giữ lại header 7 ngày trong tuần)
    while (calendarDays.children.length > 7) {
        calendarDays.removeChild(calendarDays.lastChild);
    }

    // Thêm ô trống đầu tháng
    for (let i = 0; i < firstDay; i++) {
        const empty = document.createElement('div');
        calendarDays.appendChild(empty);
    }

    // Tạo ngày
    for (let day = 1; day <= daysInMonth; day++) {
        const dateDiv = document.createElement('div');
        dateDiv.className = 'date';
        dateDiv.textContent = day;

        const isToday = (day === today.getDate() && month === today.getMonth() && year === today.getFullYear());
        if (isToday) {
            dateDiv.classList.add('today');
        }

        dateDiv.addEventListener('click', () => {
            document.querySelectorAll('.date').forEach(d => d.classList.remove('highlight'));
            dateDiv.classList.add('highlight');

            showTimeForm(day, month + 1, year);
        });

        calendarDays.appendChild(dateDiv);
    }
}

function showTimeForm(day, month, year) {
    selectedDateLabel.textContent = `${day}/${month}/${year}`;
    timeSlotForm.style.display = 'block';
}

function closeTimeForm() {
    timeSlotForm.style.display = 'none';
}

// Khởi tạo khi trang load
document.addEventListener('DOMContentLoaded', function () {
    renderCalendar(currentMonth, currentYear);
});