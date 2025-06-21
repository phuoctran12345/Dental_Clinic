// Nhấp nháy chữ 76 BILLIARDS
function toggleBlink() {
    let text = document.getElementById("blink-text");
    text.style.visibility = (text.style.visibility === "hidden") ? "visible" : "hidden";
}
setInterval(toggleBlink, 300);

// Hiệu ứng đổi viền chữ
function changeShadow() {
    let text = document.getElementById("blink-text");
    let colors = ["red", "orange", "yellow", "green", "blue", "purple"];
    let index = 0;

    setInterval(() => {
        text.style.textShadow = `2px 2px 10px ${colors[index]}`;
        index = (index + 1) % colors.length;
    }, 300);
}
window.onload = changeShadow;

function scrollToSection(sectionId) {
    const section = document.getElementById(sectionId);
    if (section) {
        section.scrollIntoView({behavior: "smooth"});
    }
}
//--------------------------------------------------------------------------------------------


document.addEventListener("DOMContentLoaded", function () {
    function updateTotalSelectedCount() {
        let totalSelected = 0;
        document.querySelectorAll("[id^='selected-quantity-']").forEach(elem => {
            totalSelected += parseInt(elem.innerText);
        });
        document.getElementById("selected-count").innerText = totalSelected;

        // Lưu tổng số bàn đã chọn vào sessionStorage
        sessionStorage.setItem("totalSelected", totalSelected);
    }

    function saveTableData() {
        let tableData = {};
        document.querySelectorAll("[id^='selected-quantity-']").forEach(elem => {
            let tableId = elem.id.split("-")[2]; // Lấy ID bàn
            let selected = parseInt(elem.innerText);
            let quantity = parseInt(document.getElementById("quantity-" + tableId).innerText);
            let category = document.getElementById("category-" + tableId).innerText;
            let quality = document.getElementById("quality-" + tableId).innerText;
            let price = parseInt(document.getElementById("price-" + tableId).innerText); // ✅ Lấy giá bàn

            tableData[tableId] = {selected, quantity, category, quality, price}; // ✅ Thêm price
        });

        sessionStorage.setItem("tableData", JSON.stringify(tableData));
    }


    function loadTableData() {
        let tableData = JSON.parse(sessionStorage.getItem("tableData"));
        if (tableData) {
            Object.keys(tableData).forEach(tableId => {
                document.getElementById("selected-quantity-" + tableId).innerText = tableData[tableId].selected;
                document.getElementById("quantity-" + tableId).innerText = tableData[tableId].quantity;
                document.getElementById("category-" + tableId).innerText = tableData[tableId].category;
                document.getElementById("quality-" + tableId).innerText = tableData[tableId].quality;
                document.getElementById("price-" + tableId).innerText = tableData[tableId].price; // ✅ Load lại price
            });
        }

        let totalSelected = sessionStorage.getItem("totalSelected");
        if (totalSelected) {
            document.getElementById("selected-count").innerText = totalSelected;
        }
    }



    // Tải dữ liệu từ sessionStorage khi trang load lại
    loadTableData();

    document.querySelectorAll(".plus-btn").forEach(button => {
        button.onclick = function () {
            let tableId = this.getAttribute("data-id");
            let quantityElem = document.getElementById("quantity-" + tableId);
            let selectedElem = document.getElementById("selected-quantity-" + tableId);

            let quantity = parseInt(quantityElem.innerText);
            let selected = parseInt(selectedElem.innerText);

            if (quantity > 0) {
                quantityElem.innerText = quantity - 1;
                selectedElem.innerText = selected + 1;
                updateTotalSelectedCount();
                saveTableData(); // Lưu dữ liệu vào sessionStorage
            }
        };
    });

    document.querySelectorAll(".minus-btn").forEach(button => {
        button.onclick = function () {
            let tableId = this.getAttribute("data-id");
            let quantityElem = document.getElementById("quantity-" + tableId);
            let selectedElem = document.getElementById("selected-quantity-" + tableId);

            let quantity = parseInt(quantityElem.innerText);
            let selected = parseInt(selectedElem.innerText);

            if (selected > 0) {
                quantityElem.innerText = quantity + 1;
                selectedElem.innerText = selected - 1;
                updateTotalSelectedCount();
                saveTableData(); // Lưu dữ liệu vào sessionStorage
            }
        };
    });
});


// Lưu trạng thái ban đầu của các bàn khi trang load
let initialTableData = [];

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".table-item").forEach((table) => {
        initialTableData.push({
            tableId: table.getAttribute("data-table-id"),
            remaining: parseInt(table.querySelector(".remaining-count").innerText)
        });
    });

    // Gán sự kiện cho nút Reset
    document.getElementById("reset-btn").addEventListener("click", resetSelection);
});



document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".table-item").forEach((table) => {
        initialTableData.push({
            tableId: table.getAttribute("data-table-id"),
            remaining: parseInt(table.querySelector(".remaining-count").innerText)
        });
    });

    // Gán sự kiện cho nút Reset
    document.getElementById("logout-btn").addEventListener("click", resetSelection);
});
//--------------------------------------------------------------------------------------------

function resetSelection() {
    console.log("Reset về trạng thái ban đầu...");

    // 1️⃣ Reset tổng số bàn đã chọn về 0
    document.getElementById("selected-count").innerText = "0";

    // 2️⃣ Reset từng bàn về trạng thái ban đầu
    document.querySelectorAll("[id^='selected-quantity-']").forEach(elem => {
        let tableId = elem.id.split("-")[2]; // Lấy ID bàn
        let selectedCount = parseInt(elem.innerText); // Số bàn đã chọn trước đó

        elem.innerText = "0"; // Reset số bàn đã chọn về 0

        // Khôi phục số bàn còn lại từ dữ liệu ban đầu + số bàn đã chọn
        let initialData = initialTableData.find(t => t.tableId === tableId);
        if (initialData) {
            document.getElementById("quantity-" + tableId).innerText =
                    parseInt(initialData.remaining) + selectedCount;
        }
    });

    // 3️⃣ Xóa dữ liệu trong sessionStorage
    sessionStorage.removeItem("tableData");
    sessionStorage.removeItem("totalSelected");

    console.log("Reset thành công!");
    location.reload();
}
//--------------------------------------------------------------------------------------------
document.addEventListener("DOMContentLoaded", function () {
    function updateCartCount() {
        let totalSelected = sessionStorage.getItem("totalSelected") || 0;
        let cartCountElem = document.getElementById("cart-count");
        let cartButton = document.querySelector(".cart-btn");


        if (totalSelected > 0) {
            cartCountElem.innerText = totalSelected;
            cartCountElem.style.display = "inline-block"; // Hiển thị số lượng
            cartButton.style.opacity = "1"; // Hiện rõ
            cartButton.style.pointerEvents = "auto"; // Cho phép bấm
        } else {
            cartCountElem.style.display = "none"; // Ẩn nếu không có bàn nào được chọn
            cartButton.style.opacity = "0.5"; // Làm mờ
            cartButton.style.pointerEvents = "none"; // Không cho bấm

        }
    }
    // Cập nhật khi trang load
    updateCartCount();

    // Cập nhật mỗi khi thêm bàn
    document.querySelectorAll(".plus-btn, .minus-btn").forEach(button => {
        button.addEventListener("click", updateCartCount);
    });
});
////////////////////////////////////

document.addEventListener("DOMContentLoaded", function () {
    let tableData = JSON.parse(sessionStorage.getItem("tableData")) || {};
    let selectedContainer = document.getElementById("selected-table-container");
    let totalSelected = 0;
    let totalAllPrice = 0; // ✅ Tổng tiền tất cả bàn

    if (Object.keys(tableData).length === 0) {
        selectedContainer.innerHTML = "<p class='text-muted'>Chưa có bàn nào được chọn.</p>";
    } else {
        let tableList = `
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Bàn</th>
                        <th>Loại</th>
                        <th>Chất lượng</th>
                        <th>Đã chọn</th>
                        <th>Giá (VND)</th>
                        <th>Thành tiền (VND)</th>
                    </tr>
                </thead>
                <tbody>`;

        Object.keys(tableData).forEach(tableId => {
            let selected = tableData[tableId].selected;
            let category = tableData[tableId].category || "N/A";
            let quality = tableData[tableId].quality || "N/A";
            let price = tableData[tableId].price || 0;

            if (selected > 0) {
                let totalPrice = price * selected; // ✅ Tính tổng giá cho bàn đó
                totalAllPrice += totalPrice; // ✅ Cộng vào tổng tất cả bàn

                tableList += `
                    <tr>
                        <td><strong>Bàn ${tableId}</strong></td>
                        <td>${category}</td>
                        <td>${quality}</td>
                        <td>${selected}</td>
                        <td>${price.toLocaleString()}</td>
                        <td>${totalPrice.toLocaleString()}</td>
                    </tr>`;

                totalSelected += selected;
            }
        });

        tableList += `
                </tbody>
            </table>`;

        selectedContainer.innerHTML = tableList;
    }

    document.getElementById("total-selected").innerText = totalSelected;
    document.getElementById("total-price").innerText = totalAllPrice.toLocaleString();
});




// Hàm xóa toàn bộ bàn đã chọn
function clearSelection() {
    sessionStorage.removeItem("tableData");
    sessionStorage.removeItem("totalSelected");
    location.reload();
}

document.getElementById('upload-receipt').addEventListener('change', function (e) {
    let receiptImage = e.target.files[0]; // Lấy file ảnh từ input

    if (receiptImage) {
        // Tạo URL tạm thời cho ảnh (hoặc bạn có thể sử dụng tên file nếu cần)
        let receiptImageUrl = URL.createObjectURL(receiptImage);

        // Lưu ảnh hóa đơn vào sessionStorage
        sessionStorage.setItem('receiptImage', receiptImageUrl);

        // Hiển thị ảnh lên giao diện
        document.getElementById('receipt-preview').src = receiptImageUrl;
        document.getElementById('receipt-preview').classList.remove('d-none');
    }
});

function updateTotalBill() {
    let tableData = sessionStorage.getItem("tableData");
    let totalAllPrice = 0;

    if (tableData) {
        tableData = JSON.parse(tableData);
        for (let key in tableData) {
            let item = tableData[key];
            totalAllPrice += item.selected * item.price;
        }
    }

    // Cập nhật giao diện
    document.getElementById("total-price").innerText = totalAllPrice.toLocaleString() + " VND";

    // Lưu vào sessionStorage
    sessionStorage.setItem("totalBill", totalAllPrice);
}
updateTotalBill();