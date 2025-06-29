<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="dao.DoctorDAO" %>
        <%@ page import="model.Doctors" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.sql.Connection" %>
                    <%@ page import="utils.DBContext" %>

                        <!DOCTYPE html>
                        <html>

                        <head>
                            <title>Debug Doctors</title>
                            <style>
                                .debug {
                                    background: #f0f0f0;
                                    padding: 10px;
                                    margin: 10px 0;
                                    border-left: 4px solid #007bff;
                                }

                                .error {
                                    border-left-color: #dc3545;
                                }

                                .success {
                                    border-left-color: #28a745;
                                }
                            </style>
                        </head>

                        <body>
                            <h1>🔍 Debug Doctors System</h1>

                            <div class="debug">
                                <h3>1. Test Database Connection</h3>
                                <% try { Connection conn=DBContext.getConnection(); if (conn !=null) {
                                    out.println("<span style='color: green'>✅ Database connection: SUCCESS</span>");
                                    conn.close();
                                    } else {
                                    out.println("<span style='color: red'>❌ Database connection: FAILED</span>");
                                    }
                                    } catch (Exception e) {
                                    out.println("<span style='color: red'>❌ Database error: " + e.getMessage() +
                                        "</span>");
                                    }
                                    %>
                            </div>

                            <div class="debug">
                                <h3>2. Test DoctorDAO.getAllDoctors()</h3>
                                <% try { List<Doctors> doctors = DoctorDAO.getAllDoctors();
                                    out.println("<p><strong>Số lượng bác sĩ:</strong> " + (doctors != null ?
                                        doctors.size() : "null") + "</p>");

                                    if (doctors != null && !doctors.isEmpty()) {
                                    out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                                        out.println("<tr>
                                            <th>ID</th>
                                            <th>User ID</th>
                                            <th>Họ tên</th>
                                            <th>Chuyên khoa</th>
                                            <th>Trạng thái</th>
                                        </tr>");

                                        for (Doctors doctor : doctors) {
                                        out.println("<tr>");
                                            out.println("<td>" + doctor.getDoctor_id() + "</td>");
                                            out.println("<td>" + doctor.getUser_id() + "</td>");
                                            out.println("<td>" + doctor.getFull_name() + "</td>");
                                            out.println("<td>" + doctor.getSpecialty() + "</td>");
                                            out.println("<td>" + doctor.getStatus() + "</td>");
                                            out.println("</tr>");
                                        }
                                        out.println("</table>");
                                    } else {
                                    out.println("<span style='color: orange'>⚠️ Danh sách bác sĩ trống!</span>");
                                    }
                                    } catch (Exception e) {
                                    out.println("<span style='color: red'>❌ Error calling getAllDoctors(): " +
                                        e.getMessage() + "</span>");
                                    e.printStackTrace();
                                    }
                                    %>
                            </div>

                            <div class="debug">
                                <h3>3. Raw SQL Test</h3>
                                <% try { Connection conn=DBContext.getConnection(); java.sql.PreparedStatement
                                    ps=conn.prepareStatement("SELECT COUNT(*) as total FROM Doctors");
                                    java.sql.ResultSet rs=ps.executeQuery(); if (rs.next()) { out.println("<p>
                                    <strong>Tổng số bác sĩ trong DB:</strong> " + rs.getInt("total") + "</p>");
                                    }
                                    rs.close();
                                    ps.close();
                                    conn.close();
                                    } catch (Exception e) {
                                    out.println("<span style='color: red'>❌ Raw SQL error: " + e.getMessage() +
                                        "</span>");
                                    }
                                    %>
                            </div>

                            <div class="debug">
                                <h3>4. Sample Doctor Data</h3>
                                <% try { Connection conn=DBContext.getConnection(); java.sql.PreparedStatement
                                    ps=conn.prepareStatement("SELECT * FROM Doctors LIMIT 2"); java.sql.ResultSet
                                    rs=ps.executeQuery(); out.println("<table border='1'
                                    style='border-collapse: collapse; width: 100%;'>");
                                    out.println("<tr>
                                        <th>doctor_id</th>
                                        <th>user_id</th>
                                        <th>full_name</th>
                                        <th>specialty</th>
                                        <th>status</th>
                                    </tr>");

                                    while (rs.next()) {
                                    out.println("<tr>");
                                        out.println("<td>" + rs.getString("doctor_id") + "</td>");
                                        out.println("<td>" + rs.getString("user_id") + "</td>");
                                        out.println("<td>" + rs.getString("full_name") + "</td>");
                                        out.println("<td>" + rs.getString("specialty") + "</td>");
                                        out.println("<td>" + rs.getString("status") + "</td>");
                                        out.println("</tr>");
                                    }
                                    out.println("</table>");

                                    rs.close();
                                    ps.close();
                                    conn.close();
                                    } catch (Exception e) {
                                    out.println("<span style='color: red'>❌ Sample data error: " + e.getMessage() +
                                        "</span>");
                                    }
                                    %>
                            </div>

                            <br>
                            <a href="jsp/staff/staff_datlich.jsp">← Quay lại Staff Đặt Lịch</a>
                        </body>

                        </html>