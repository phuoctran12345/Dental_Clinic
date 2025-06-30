function renderCalendar() {
    const calendarDays = document.getElementById('calendarDays');
    const calendarHeader = document.getElementById('calendarHeader');

    if (!calendarDays || !calendarHeader) {
        console.error('Không tìm thấy calendarDays hoặc calendarHeader');
        return;
    }

    const date = new Date();
    const year = date.getFullYear();
    const month = date.getMonth();

    const firstDay = new Date(year, month, 1);
    const lastDate = new Date(year, month + 1, 0).getDate();
    const startDay = (firstDay.getDay() + 6) % 7; // Thứ Hai là ngày đầu tuần
    const today = date.getDate();

    if (isNaN(firstDay.getTime()) || isNaN(lastDate)) {
        console.error('Lỗi khi tạo ngày tháng');
        return;
    }

    calendarHeader.innerText = `Tháng ${month + 1} - ${year}`;

    // Xóa ngày cũ, giữ hàng tiêu đề
    while (calendarDays.children.length > 7) {
        calendarDays.removeChild(calendarDays.lastChild);
    }

    // Ô trống đầu tháng
    for (let i = 0; i < startDay; i++) {
        const emptyCell = document.createElement('div');
        calendarDays.appendChild(emptyCell);
    }

    // Các ngày trong tháng
    for (let i = 1; i <= lastDate; i++) {
        const dayCell = document.createElement('div');
        dayCell.classList.add('date');
        dayCell.innerText = i;

        if (i === today) {
            dayCell.classList.add('today');
        }

        calendarDays.appendChild(dayCell);
    }
}

// Hàm cập nhật thời gian (nếu cần)
function updateTime() {
    const timeElement = document.getElementById('time');
    if (timeElement) {
        timeElement.innerText = new Date().toLocaleTimeString();
    }
}

// Render lần đầu
renderCalendar();

// Cập nhật giờ mỗi giây (nếu cần)
setInterval(updateTime, 1000);