//// 🚀 N8N CODE NODE - GOOGLE CALENDAR INTEGRATION
//// Copy toàn bộ code này vào Code Node trong N8N workflow
//
//// Lấy data từ webhook
//const webhookData = $('Webhook').first().json;
//
//console.log('=== 🔍 WEBHOOK DATA RECEIVED ===');
//console.log(JSON.stringify(webhookData, null, 2));
//
//// Parse thời gian từ data Java backend
//let appointmentDate = webhookData.appointmentDate || '2025-07-12';
//let appointmentTime = webhookData.appointmentTime || '08:00 - 09:00';
//
//// Tách start và end time
//let timeParts = appointmentTime.split(' - ');
//let startTime = timeParts[0] ? timeParts[0].trim() : '08:00';
//let endTime = timeParts[1] ? timeParts[1].trim() : '09:00';
//
//// Tạo ISO datetime format với timezone +07:00
//let startDateTime = `${appointmentDate}T${startTime}:00+07:00`;
//let endDateTime = `${appointmentDate}T${endTime}:00+07:00`;
//
//// Lấy email từ data
//let userEmail = webhookData.userEmail || webhookData.to || 'phuocthde180577@fpt.edu.vn';
//let doctorEmail = webhookData.doctorEmail || 'de180577tranhongphuoc@gmail.com';
//
//// Tạo attendees array theo format Google Calendar cần
//let attendees = [];
//if (userEmail) {
//  attendees.push({ email: userEmail });
//}
//if (doctorEmail && doctorEmail !== userEmail) {
//  attendees.push({ email: doctorEmail });
//}
//
//// Fallback nếu không có attendees từ Java
//if (attendees.length === 0) {
//  attendees = [
//    { email: 'phuocthde180577@fpt.edu.vn' },
//    { email: 'de180577tranhongphuoc@gmail.com' }
//  ];
//}
//
//// Tạo event data cho Google Calendar
//const calendarData = {
//  summary: webhookData.eventTitle || `Lịch khám - ${webhookData.serviceName || 'Khám răng'}`,
//  description: webhookData.eventDescription || `
//🏥 Dịch vụ: ${webhookData.serviceName || 'Khám răng'}
//👤 Bệnh nhân: ${webhookData.userName || 'Khách hàng'}
//👨‍⚕️ Bác sĩ: ${webhookData.doctorName || 'Bác sĩ'}
//📍 Địa điểm: ${webhookData.location || webhookData.clinicAddress || 'FPT University Đà Nẵng'}
//💼 Mã hóa đơn: ${webhookData.billId || 'N/A'}
//📝 Lý do: ${webhookData.reason || 'Khám tổng quát'}
//  `,
//  start: {
//    dateTime: startDateTime,
//    timeZone: 'Asia/Ho_Chi_Minh'
//  },
//  end: {
//    dateTime: endDateTime,
//    timeZone: 'Asia/Ho_Chi_Minh'
//  },
//  location: webhookData.location || webhookData.clinicAddress || 'FPT University Đà Nẵng',
//  attendees: attendees
//};
//
//console.log('=== 📅 CALENDAR DATA OUTPUT ===');
//console.log(JSON.stringify(calendarData, null, 2));
//
//console.log('=== ✅ SUMMARY ===');
//console.log(`📧 Attendees: ${attendees.map(a => a.email).join(', ')}`);
//console.log(`⏰ Time: ${startDateTime} → ${endDateTime}`);
//console.log(`🏥 Service: ${webhookData.serviceName || 'Khám răng'}`);
//console.log(`👤 Patient: ${webhookData.userName || 'Khách hàng'}`);
//console.log(`👨‍⚕️ Doctor: ${webhookData.doctorName || 'Bác sĩ'}`);
//
//// Trả về data cho Google Calendar node
//return { json: calendarData }; 