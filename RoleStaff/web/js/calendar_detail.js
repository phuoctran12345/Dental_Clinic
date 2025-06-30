function renderCalendar(year, month, highlightDays = []) {
            const calendarDays = document.getElementById('calendarDays');
            const calendarHeader = document.getElementById('calendarHeader');

            const today = new Date();
            const isCurrentMonth = year === today.getFullYear() && month === today.getMonth();

            const firstDay = new Date(year, month, 1);
            const lastDate = new Date(year, month + 1, 0).getDate();
            const startDay = (firstDay.getDay() + 6) % 7; // Bắt đầu tuần từ Thứ 2

            calendarHeader.innerText = `Tháng ${month + 1} - ${year}`;

            // Xóa các ngày cũ (giữ lại 7 ô header)
            while (calendarDays.children.length > 7) {
                calendarDays.removeChild(calendarDays.lastChild);
            }

            // Thêm ô trống đầu tháng
            for (let i = 0; i < startDay; i++) {
                const emptyCell = document.createElement('div');
                calendarDays.appendChild(emptyCell);
            }

            // Thêm các ngày trong tháng
            for (let i = 1; i <= lastDate; i++) {
                const dayCell = document.createElement('div');
                dayCell.classList.add('date');
                dayCell.innerText = i;

                if (isCurrentMonth && i === today.getDate()) {
                    dayCell.classList.add('today');
                }
                if (highlightDays.includes(i)) {
                    dayCell.classList.add('highlight');
                }

                calendarDays.appendChild(dayCell);
            }
        }

        function fetchWorkDays(doctorId, year, month) {
            const servletMonth = month + 1; // JS month 0-based, servlet 1-based

            fetch(`/doctor-workdays?doctorId=${doctorId}&year=${year}&month=${servletMonth}`)
                .then(response => response.json())
                .then(data => {
                    renderCalendar(year, month, data);
                })
                .catch(error => {
                    console.error('Lỗi khi lấy lịch làm việc:', error);
                    renderCalendar(year, month);
                });
        }

        document.addEventListener('DOMContentLoaded', function () {
            const now = new Date();
            const doctorId = 1; // TODO: lấy ID bác sĩ từ session hoặc biến JS

            fetchWorkDays(doctorId, now.getFullYear(), now.getMonth());
        });
    