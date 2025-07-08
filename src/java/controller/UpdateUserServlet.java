package controller;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import model.User;
import model.Patients;
import dao.UserDAO;
import dao.PatientDAO;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 5,  // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class UpdateUserServlet extends HttpServlet {
    private static final String RETURN_URL = "/jsp/patient/user_taikhoan.jsp";
    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg"};

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            request.setAttribute("error", "Phiên đăng nhập đã hết hạn");
            request.getRequestDispatcher(RETURN_URL).forward(request, response);
            return;
        }

        String type = request.getParameter("type");
        String field = request.getParameter("field");

        if ("email".equals(field)) {
            // Cập nhật email
            String email = request.getParameter("value");
            if (email == null || email.trim().isEmpty() || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
                request.setAttribute("error", "Vui lòng nhập email hợp lệ");
            } else {
                boolean success = UserDAO.updateEmail(currentUser.getId(), email);
                if (success) {
                    currentUser.setEmail(email);
                    session.setAttribute("user", currentUser);
                    request.setAttribute("success", "Cập nhật email thành công");
                } else {
                    request.setAttribute("error", "Lỗi khi cập nhật email");
                }
            }
        } else if ("password".equals(type)) {
            // Cập nhật mật khẩu
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || newPassword == null || confirmPassword == null ||
                oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp");
            } else if (!oldPassword.equals(currentUser.getPasswordHash())) {
                request.setAttribute("error", "Mật khẩu cũ không đúng");
            } else {
                boolean success = UserDAO.updatePasswordHash(currentUser.getId(), newPassword);
                if (success) {
                    currentUser.setPasswordHash(newPassword);
                    session.setAttribute("user", currentUser);
                    request.setAttribute("success", "Đổi mật khẩu thành công");
                } else {
                    request.setAttribute("error", "Lỗi khi cập nhật mật khẩu");
                }
            }
        } else if ("profile_picture".equals(type)) {
            // Cập nhật ảnh đại diện
            String patientIdStr = request.getParameter("patientId");
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Không tìm thấy ID bệnh nhân");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            int patientId;
            try {
                patientId = Integer.parseInt(patientIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID bệnh nhân không hợp lệ");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            Part filePart = request.getPart("profilePicture");
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Vui lòng chọn file ảnh");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            String fileName = extractFileName(filePart);
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!isValidExtension(fileExtension)) {
                request.setAttribute("error", "Chỉ chấp nhận file PNG, JPG hoặc JPEG");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            String newFileName = "patient_" + patientId + "_" + System.currentTimeMillis() + fileExtension;
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + newFileName;
            filePart.write(filePath);

            String relativePath = "/" + UPLOAD_DIR + "/" + newFileName;
            boolean success = PatientDAO.updatePatientAvatar(patientId, relativePath);
            if (success) {
                Patients patient = (Patients) session.getAttribute("patient");
                if (patient != null && patient.getPatientId() == patientId) {
                    patient.setAvatar(relativePath);
                    session.setAttribute("patient", patient);
                }
                request.setAttribute("success", "Cập nhật ảnh đại diện thành công");
            } else {
                request.setAttribute("error", "Lỗi khi cập nhật ảnh đại diện");
            }
        } else if ("update_patient_info".equals(type)) {
            // Cập nhật hoặc thêm thông tin bệnh nhân
            Patients currentPatient = (Patients) session.getAttribute("patient");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String dobStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");

            if (fullName == null || phone == null || dobStr == null || gender == null ||
                fullName.trim().isEmpty() || phone.trim().isEmpty() || dobStr.trim().isEmpty() || gender.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin cá nhân.");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            // Kiểm tra định dạng số điện thoại
            if (!phone.matches("^[0-9]{10,11}$")) {
                request.setAttribute("error", "Số điện thoại phải có 10-11 số.");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            // Kiểm tra giới tính
            if (!gender.matches("^(male|female|other)$")) {
                request.setAttribute("error", "Giới tính không hợp lệ. Vui lòng chọn Nam, Nữ hoặc Khác.");
                request.getRequestDispatcher(RETURN_URL).forward(request, response);
                return;
            }

            String relativePath = null;
            if (request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
                Part filePart = request.getPart("profilePicture");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = extractFileName(filePart);
                    String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
                    if (!isValidExtension(fileExtension)) {
                        request.setAttribute("error", "Chỉ chấp nhận file PNG, JPG hoặc JPEG");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }

                    String idForFile = currentPatient != null ? String.valueOf(currentPatient.getPatientId()) : String.valueOf(currentUser.getId());
                    String newFileName = "patient_" + idForFile + "_" + System.currentTimeMillis() + fileExtension;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String filePath = uploadPath + File.separator + newFileName;
                    filePart.write(filePath);
                    relativePath = "/" + UPLOAD_DIR + "/" + newFileName;
                }
            }

            try {
                java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
                java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());

                if (currentPatient == null) {
                    // Thêm bệnh nhân mới
                    Patients newPatient = new Patients();
                    newPatient.setId(currentUser.getId());
                    newPatient.setFullName(fullName);
                    newPatient.setPhone(phone);
                    newPatient.setDateOfBirth(sqlDate);
                    newPatient.setGender(gender);
                    if (relativePath != null) {
                        newPatient.setAvatar(relativePath);
                    }

                    boolean inserted = PatientDAO.insertNewPatient(newPatient);
                    if (inserted) {
                        Patients fetched = UserDAO.getPatientByUserId(currentUser.getId());
                        session.setAttribute("patient", fetched);
                        request.setAttribute("success", "Đã lưu thông tin bệnh nhân.");
                    } else {
                        request.setAttribute("error", "Lưu thông tin thất bại.");
                    }
                } else {
                    // Cập nhật bệnh nhân hiện có
                    String patientIdStr = request.getParameter("patientId");
                    if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                        request.setAttribute("error", "Không tìm thấy ID bệnh nhân");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }
                    int patientId;
                    try {
                        patientId = Integer.parseInt(patientIdStr);
                        if (patientId != currentPatient.getPatientId()) {
                            request.setAttribute("error", "ID bệnh nhân không khớp");
                            request.getRequestDispatcher(RETURN_URL).forward(request, response);
                            return;
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "ID bệnh nhân không hợp lệ");
                        request.getRequestDispatcher(RETURN_URL).forward(request, response);
                        return;
                    }

                    currentPatient.setFullName(fullName);
                    currentPatient.setPhone(phone);
                    currentPatient.setDateOfBirth(sqlDate);
                    currentPatient.setGender(gender);
                    if (relativePath != null) {
                        currentPatient.setAvatar(relativePath);
                    }

                    boolean updated = PatientDAO.updatePatientInfo(currentPatient);
                    if (updated) {
                        session.setAttribute("patient", currentPatient);
                        request.setAttribute("success", "Cập nhật thông tin thành công.");
                    } else {
                        request.setAttribute("error", "Cập nhật thất bại.");
                    }
                }
            } catch (ParseException e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ.");
            }
        } else {
            request.setAttribute("error", "Yêu cầu không hợp lệ");
        }

        request.getRequestDispatcher(RETURN_URL).forward(request, response);
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String cd : contentDisposition.split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private boolean isValidExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equals(extension)) {
                return true;
            }
        }
        return false;
    }
}
