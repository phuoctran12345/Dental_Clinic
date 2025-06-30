// State quản lý lịch
const calendarState = {
    currentYear: new Date().getFullYear(),
    currentMonth: new Date().getMonth()
};

function renderCalendar(year, month, highlightDays = []) {
    const calendarDays = document.getElementById('calendarDays');
    const calendarHeader = document.getElementById('calendarHeader');

    const today = new Date();
    const isCurrentMonth = year === today.getFullYear() && month === today.getMonth();

    const firstDay = new Date(year, month, 1);
    const lastDate = new Date(year, month + 1, 0).getDate();
    const startDay = (firstDay.getDay() + 6) % 7; // Bắt đầu tuần từ Thứ 2

    // Cập nhật header
    calendarHeader.innerHTML = `
        <button onclick="changeMonth(-1)" title="Tháng trước">&lt;</button>
        <span>Tháng ${month + 1} - ${year}</span>
        <button onclick="changeMonth(1)" title="Tháng sau">&gt;</button>
    `;

    // Xóa các ngày cũ (giữ lại 7 ô header)
    while (calendarDays.children.length > 7) {
        calendarDays.removeChild(calendarDays.lastChild);
    }

    // Thêm ô trống đầu tháng
    for (let i = 0; i < startDay; i++) {
        const emptyCell = document.createElement('div');
        emptyCell.classList.add('date', 'empty-date');
        calendarDays.appendChild(emptyCell);
    }

    // Thêm các ngày trong tháng
    for (let i = 1; i <= lastDate; i++) {
        const dayCell = document.createElement('div');
        dayCell.classList.add('date');
        dayCell.innerText = i;

        // Highlight ngày hôm nay
        if (isCurrentMonth && i === today.getDate()) {
            dayCell.classList.add('today');
            dayCell.title = `Hôm nay - ${i}/${month + 1}/${year}`;
        }

        // Highlight ngày làm việc
        if (highlightDays.includes(i)) {
            dayCell.classList.add('highlight');
            dayCell.title = `Ngày làm việc - ${i}/${month + 1}/${year}`;
            dayCell.addEventListener('click', function () {
                const clickedDate = new Date(year, month,i);
                const isoDate = clickedDate.toISOString().split('T')[0]; // yyyy-MM-dd
                window.location.href = `doctor_trongtuan.jsp?doctorId=${doctorId}&week=${isoDate}`;
            });

        }

        calendarDays.appendChild(dayCell);
    }

    console.log('Ngày highlight:', highlightDays);
}

function changeMonth(delta) {
    console.log('=== CHANGE MONTH DEBUG ===');
    console.log('Delta:', delta);
    console.log('State trước:', calendarState.currentMonth + 1, calendarState.currentYear);

    // Cập nhật state
    calendarState.currentMonth += delta;

    // Xử lý overflow/underflow tháng
    if (calendarState.currentMonth > 11) {
        calendarState.currentYear++;
        calendarState.currentMonth = 0;
    } else if (calendarState.currentMonth < 0) {
        calendarState.currentYear--;
        calendarState.currentMonth = 11;
    }

    console.log('State sau:', calendarState.currentMonth + 1, calendarState.currentYear);
    console.log('=== END DEBUG ===');

    fetchWorkDays(calendarState.currentYear, calendarState.currentMonth);
}

function fetchWorkDays(year, month) {
    const doctorId = document.getElementById('doctorId')?.value || 1;
    const servletMonth = month + 1; // JS month 0-based, servlet 1-based

    const url = `doctor-workdays?doctorId=${doctorId}&year=${year}&month=${servletMonth}`;
    console.log('Gọi API:', url);

    fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log('Dữ liệu nhận được:', data);
            renderCalendar(year, month, data);
        })
        .catch(error => {
            console.error('Lỗi:', error);
            renderCalendar(year, month, []);
        });
}

// Khởi tạo khi trang load
document.addEventListener('DOMContentLoaded', function () {
    const now = new Date();
    // Tạo currentDate với ngày 1 của tháng hiện tại
    calendarState.currentYear = now.getFullYear();
    calendarState.currentMonth = now.getMonth();

    console.log(`Khởi tạo lịch tháng: ${calendarState.currentMonth + 1}/${calendarState.currentYear}`);
    fetchWorkDays(calendarState.currentYear, calendarState.currentMonth);
});
