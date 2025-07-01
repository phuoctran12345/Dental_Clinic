/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.MedicalReport;
import dao.MedicineDAO;
import model.Prescription;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author Home
 */
public class ExportMedicalReportServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ExportMedicalReportServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportMedicalReportServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
        int reportId = Integer.parseInt(request.getParameter("reportId"));
        MedicineDAO dao = new MedicineDAO();

        MedicalReport report = dao.getMedicalReportById(reportId);

        if (report == null) {
            response.getWriter().println("Không tìm thấy báo cáo y tế!");
            return;
        }

        List<Prescription> prescriptions = dao.getPrescriptionsByReportId(report.getReportId());

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=report_" + reportId + ".pdf");

        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Load font tiếng Việt
        String fontPath = getServletContext().getRealPath("/fonts/DejaVuSans.ttf");
        BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        Font titleFont = new Font(baseFont, 20, Font.BOLD, new BaseColor(0, 70, 140));
        Font subTitleFont = new Font(baseFont, 14, Font.BOLD, BaseColor.BLACK);
        Font labelFont = new Font(baseFont, 12, Font.BOLD, BaseColor.DARK_GRAY);
        Font valueFont = new Font(baseFont, 12, Font.NORMAL, BaseColor.BLACK);

        // Tiêu đề chính
        Paragraph title = new Paragraph("BÁO CÁO Y TẾ", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20f);
        document.add(title);

        // Bảng thông tin báo cáo: 2 cột, có viền nhẹ, padding
        PdfPTable infoTable = new PdfPTable(new float[]{3, 7});
        infoTable.setWidthPercentage(80);
        infoTable.setSpacingAfter(20f);

        addInfoCell(infoTable, "Mã báo cáo:", labelFont);
        addInfoCell(infoTable, String.valueOf(report.getReportId()), valueFont);

        addInfoCell(infoTable, "Bệnh nhân:", labelFont);
        addInfoCell(infoTable, safeString(report.getPatientName()), valueFont);

        addInfoCell(infoTable, "Bác sĩ:", labelFont);
        addInfoCell(infoTable, safeString(report.getDoctorName()), valueFont);

        addInfoCell(infoTable, "Chẩn đoán:", labelFont);
        addInfoCell(infoTable, safeString(report.getDiagnosis()), valueFont);

        addInfoCell(infoTable, "Phác đồ điều trị:", labelFont);
        addInfoCell(infoTable, safeString(report.getTreatmentPlan()), valueFont);

        addInfoCell(infoTable, "Ghi chú:", labelFont);
        addInfoCell(infoTable, safeString(report.getNote()), valueFont);

        addInfoCell(infoTable, "Ngày tạo:", labelFont);
        String formattedDate = report.getCreatedAt() != null
                ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(report.getCreatedAt()) : "";
        addInfoCell(infoTable, formattedDate, valueFont);

        addInfoCell(infoTable, "Chữ ký:", labelFont);
        addInfoCell(infoTable, safeString(report.getSign()), valueFont);

        document.add(infoTable);

        // Ngang phân cách
        LineSeparator ls = new LineSeparator();
        ls.setOffset(-5);
        document.add(new Chunk(ls));

        document.add(Chunk.NEWLINE);

        // Phần đơn thuốc
        Paragraph prescriptionTitle = new Paragraph("ĐƠN THUỐC", subTitleFont);
        prescriptionTitle.setAlignment(Element.ALIGN_LEFT);
        prescriptionTitle.setSpacingAfter(10f);
        document.add(prescriptionTitle);

        if (prescriptions != null && !prescriptions.isEmpty()) {
            PdfPTable table = new PdfPTable(new float[]{5, 2, 3});
            table.setWidthPercentage(100);
            table.setHeaderRows(1);

            // Header bảng đơn thuốc, nền xanh nhẹ
            PdfPCell cellName = new PdfPCell(new Phrase("Tên thuốc", labelFont));
            cellName.setBackgroundColor(new BaseColor(230, 240, 255));
            cellName.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellName.setPadding(5);
            table.addCell(cellName);

            PdfPCell cellQty = new PdfPCell(new Phrase("Số lượng", labelFont));
            cellQty.setBackgroundColor(new BaseColor(230, 240, 255));
            cellQty.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellQty.setPadding(5);
            table.addCell(cellQty);

            PdfPCell cellUsage = new PdfPCell(new Phrase("Cách dùng", labelFont));
            cellUsage.setBackgroundColor(new BaseColor(230, 240, 255));
            cellUsage.setHorizontalAlignment(Element.ALIGN_CENTER);
            cellUsage.setPadding(5);
            table.addCell(cellUsage);

            // Dữ liệu đơn thuốc
            for (Prescription p : prescriptions) {
                PdfPCell cell1 = new PdfPCell(new Phrase(safeString(p.getName()), valueFont));
                cell1.setPadding(5);
                table.addCell(cell1);

                PdfPCell cell2 = new PdfPCell(new Phrase(String.valueOf(p.getQuantity()), valueFont));
                cell2.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell2.setPadding(5);
                table.addCell(cell2);

                PdfPCell cell3 = new PdfPCell(new Phrase(safeString(p.getUsage()), valueFont));
                cell3.setPadding(5);
                table.addCell(cell3);
            }

            document.add(table);
        } else {
            Paragraph noPrescription = new Paragraph("Không có đơn thuốc nào được kê.", valueFont);
            noPrescription.setSpacingBefore(10f);
            document.add(noPrescription);
        }

        document.close();

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("Lỗi khi xuất file PDF!");
    }
}

private String safeString(String str) {
    return str == null ? "" : str;
}

private void addInfoCell(PdfPTable table, String text, Font font) {
    PdfPCell cell = new PdfPCell(new Phrase(text, font));
    cell.setPadding(8);
    cell.setBorderWidth(0.5f);
    cell.setBorderColor(BaseColor.LIGHT_GRAY);
    if (font.getStyle() == Font.BOLD) {
        cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cell.setBackgroundColor(new BaseColor(245, 245, 245));
    } else {
        cell.setHorizontalAlignment(Element.ALIGN_LEFT);
    }
    table.addCell(cell);
}



    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
