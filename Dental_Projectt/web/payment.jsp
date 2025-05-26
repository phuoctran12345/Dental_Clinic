<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<title>Thanh toán VNPay QR</title>
<style>
  html, body {
    margin: 0; padding: 0; min-height: 100vh;
    background: #f9fafc;
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    color: #2b2b2b;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  body {
    display: flex;
    justify-content: center;
    padding: 30px 20px;
  }
  .wrapper {
    width: 70vw;
    min-width: 720px;
  }
  .top-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
  }
  .top-bar img.logo {
    height: 48px;
  }
  .countdown {
    font-family: monospace;
    font-weight: 700;
    font-size: 22px;
    border: 2px solid #c8c8c8;
    background: transparent;
    color: #2b2b2b;
    padding: 10px 22px;
    border-radius: 8px;
    min-width: 90px;
    text-align: center;
    user-select: none;
    line-height: 1;
  }
  .alert-box {
    background: #fff1cc;
    border-radius: 8px;
    padding: 22px 24px;
    color: #c76a00;
    font-weight: 700;
    margin-bottom: 40px;
    border: 1.5px solid #d4a421;
    line-height: 1.5;
    font-size: 17px;
  }
  .alert-box strong {
    font-weight: 800;
  }
  .main-content {
    display: flex;
    gap: 60px;
    margin-bottom: 50px;
  }
  .info-box {
    flex: 1 1 320px;
    background: #e6f0fa;
    border-radius: 10px;
    padding: 35px 40px;
  }
  .info-box h3 {
    margin-top: 0;
    margin-bottom: 30px;
    font-weight: 800;
    font-size: 28px;
    color: #1a2f56;
    line-height: 1.1;
  }
  .info-item {
    margin-bottom: 28px;
    font-size: 18px;
    line-height: 1.3;
  }
  .info-item label {
    display: block;
    font-weight: 700;
    color: #2e466d;
    margin-bottom: 10px;
  }
  .info-item .value {
    font-weight: 800;
    font-size: 24px;
    color: #114a8e;
    word-break: break-word;
  }
  .qr-box {
    flex: 1 1 340px;
    text-align: center;
  }
  .qr-box h3 {
    margin-bottom: 16px;
    font-weight: 800;
    font-size: 26px;
    color: #1a2f56;
    line-height: 1.2;
  }
  .qr-box p {
    font-size: 17px;
    margin-bottom: 22px;
    color: #23629b;
    line-height: 1.3;
  }
  .qr-code {
    border: 2px solid #1d7bd9;
    border-radius: 16px;
    padding: 18px;
    display: inline-block;
    margin-bottom: 16px; /* khoảng cách nhỏ giữa ảnh và nút */
  }
  .qr-code img {
    max-width: 300px;
    height: auto;
    display: block;
  }
  .qr-code div {
    font-size: 14px;
    font-style: italic;
    color: #2263a4;
    margin-top: 6px;
  }
  .btn-cancel {
    display: block;
    margin: 0 auto; /* căn giữa nút */
    background-color: #dde6f4;
    border: none;
    border-radius: 10px;
    padding: 16px 36px;
    font-weight: 800;
    font-size: 18px;
    color: #1a458c;
    cursor: pointer;
    transition: background-color 0.3s ease;
    box-shadow: 0 4px 12px rgb(0 0 0 / 0.1);
    white-space: nowrap;
  }
  .btn-cancel:hover {
    background-color: #bbd1f0;
  }
  .guide-link {
    font-size: 15px;
    margin-bottom: 25px;
    font-weight: 600;
  }
  .guide-link a {
    color: #1a458c;
    text-decoration: none;
    transition: text-decoration 0.3s ease;
  }
  .guide-link a:hover {
    text-decoration: underline;
  }
  /* Phần các ngân hàng hỗ trợ */
  .promo-list {
    border-top: 1px solid #ddd;
    padding-top: 25px;
  }
  .promo-list-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 18px;
  }
  .promo-logos {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
    justify-content: flex-start;
  }
  .promo-logos img {
    max-height: 40px;
    width: auto;
    cursor: pointer;
    transition: transform 0.2s ease;
  }
  .promo-logos img:hover {
    transform: scale(1.1);
  }

  @media (max-width: 760px) {
    .wrapper {
      width: 95vw;
      min-width: auto;
    }
    .main-content {
      flex-direction: column;
      gap: 35px;
      margin-bottom: 35px;
    }
    .info-box, .qr-box {
      width: 100%;
    }
    .info-box h3, .qr-box h3 {
      font-size: 24px;
    }
    .info-item {
      font-size: 16px;
      margin-bottom: 20px;
      line-height: 1.25;
    }
    .info-item label {
      font-size: 14px;
      margin-bottom: 6px;
    }
    .info-item .value {
      font-size: 20px;
    }
    .qr-box h3 {
      margin-bottom: 24px;
    }
    .qr-box p {
      font-size: 14px;
      margin-bottom: 20px;
    }
    .btn-cancel {
      font-size: 18px;
      padding: 14px 36px;
    }
    .promo-logos {
      justify-content: center;
      gap: 15px;
    }
    .promo-logos img {
      max-height: 35px;
    }
  }
</style>
</head>
<body>
  <div class="wrapper">

    <div class="top-bar">
      <img class="logo" src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-VNPAY-QR-1.png" alt="VNPay QR" />
      <div class="countdown" aria-label="Giao dịch hết hạn sau">
        <span id="countdown-timer">10:00</span>
      </div>
    </div>

    <div class="alert-box" role="alert">
      ⚠️ Quý khách vui lòng không tắt trình duyệt cho đến khi nhận được kết quả giao dịch trên website. Trường hợp đã thanh toán nhưng chưa nhận kết quả giao dịch, vui lòng bấm <strong>"Tại đây"</strong> để nhận kết quả. Xin cảm ơn!
    </div>

    <div class="main-content">
      <div class="info-box" aria-label="Thông tin đơn hàng">
        <h3>Thông tin đơn hàng (Test)</h3>

        <div class="info-item">
          <label for="amount">Số tiền thanh toán</label>
          <div class="value" id="amount">199.000<span style="font-size: 14px; font-weight: 400;"> VND</span></div>
        </div>
        <div class="info-item">
          <label>Giá trị đơn hàng</label>
          <div>199.000<span style="font-size: 14px; font-weight: 400;"> VND</span></div>
        </div>
        <div class="info-item">
          <label>Phí giao dịch</label>
          <div>0<span style="font-size: 14px; font-weight: 400;"> VND</span></div>
        </div>
        <div class="info-item">
          <label>Mã đơn hàng</label>
          <div>471342047517736962</div>
        </div>
        <div class="info-item">
          <label>Nhà cung cấp</label>
          <div>Phòng khám nha khoa tư nhân Happy Clinic</div>
        </div>
      </div>

      <div class="qr-box" aria-label="Mã QR thanh toán">
        <h3>Quét mã qua ứng dụng Ngân hàng/<br />Ví điện tử</h3>
        <p class="guide-link"><a href="#" tabindex="0">ℹ️ Hướng dẫn thanh toán</a></p>

        <div class="qr-code">
          <img src="https://kalite.vn/wp-content/uploads/2021/09/maqrkalite.jpg" alt="Mã QR thanh toán VNPay" />
          <div>Scan to Pay</div>
        </div>

        <button class="btn-cancel" type="button">Hủy thanh toán</button>
      </div>
    </div>

    <div class="promo-list">
      <div class="promo-list-title">Các ngân hàng hỗ trợ Mobile Banking</div>
      <div class="promo-logos" role="list">
        <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/02/Icon-Vietcombank.png" alt="Vietcombank" role="listitem" />
        <img src="https://play-lh.googleusercontent.com/rNSXUqGnK-ljK6qUdUmy7h_sDrMOzZ1nPwAUAwshsmPaQuwNGn0Xwj-psgFrBSJOHg=w240-h480-rw" alt="Agribank" role="listitem" />
        <img src="https://bidv.com.vn/wps/wcm/connect/674b6448-d23b-484e-b4d3-1e86fa68bd0d/Logo+Nguyen+ban+nen+trang.png?MOD=AJPERES&CACHEID=ROOTWORKSPACE-674b6448-d23b-484e-b4d3-1e86fa68bd0d-pfdjkOq" alt="BIDV" role="listitem" />
        <img src="https://play-lh.googleusercontent.com/F8D0AbyMmiuwsTZYLaPsu_o40XGfQHgvRnq25lVSWupgHPpH3-TQ9soMrWwDJco3siI" alt="VietinBank" role="listitem" />
        <img src="https://inkythuatso.com/uploads/images/2021/12/logo-msb-inkythuatso-07-13-38-58.jpg" alt="MSB" role="listitem" />
        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTO201tsObfmsnXukTP-0eyjE60f0Vo_SPfuw&s" alt="VPBank" role="listitem" />
        <img src="https://www.scb.com.vn/picture/y_nghi_logo_scb_truc_ngang_2_.webp" alt="SCB" role="listitem" />
        <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_evdiNGI4a3qaBab8ISARMJS6Su2IgWDSbA&s" alt="ABBANK" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-ivb.svg" alt="IVB" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-ncb.svg" alt="NCB" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-shb.svg" alt="SHB" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-vib.svg" alt="VIB" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-tpbank.svg" alt="TPBank" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-digibank.svg" alt="Viet Capital Digi Bank" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-vcbpay.svg" alt="VCBPAY" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-eximbank.svg" alt="Eximbank" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-namabank.svg" alt="Nam A Bank" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-bacabank.svg" alt="BAC A BANK" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-mb.svg" alt="MB" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-ocb.svg" alt="OCB" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-hdbank.svg" alt="HDBank" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-wooribank.svg" alt="Woori Bank Vietnam" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-pvcombank.svg" alt="PVcomBank" role="listitem" />
        <img src="https://storage.googleapis.com/fe-production-vnpay-com-vn/logos/banks/logo-bidc.svg" alt="BIDC" role="listitem" />
      </div>
    </div>

  </div>

  <script>
    let timeLeft = 10 * 60;
    const timerElement = document.getElementById('countdown-timer');

    function updateTimer() {
      if (timeLeft <= 0) {
        timerElement.textContent = "00:00";
        clearInterval(timerInterval);
        return;
      }
      const minutes = Math.floor(timeLeft / 60);
      const seconds = timeLeft % 60;

      timerElement.textContent =
        (minutes < 10 ? '0' : '') + minutes + ':' +
        (seconds < 10 ? '0' : '') + seconds;

      timeLeft--;
    }

    updateTimer();
    const timerInterval = setInterval(updateTimer, 1000);
  </script>
</body>
</html>
