<%@ page import="java.sql.*" %>
    <%@ page import="utils.DBContext" %>
        <html>

        <head>
            <title>Danh Sach Bac Si</title>
        </head>

        <body>
            <h2>Danh Sach Bac Si</h2>
            <% try { Connection conn=DBContext.getConnection(); PreparedStatement ps=conn.prepareStatement("SELECT
                doctor_id, user_id, full_name, specialty, status FROM Doctors"); ResultSet rs=ps.executeQuery();
                out.println("<table border='1'>");
                out.println("<tr>
                    <th>ID</th>
                    <th>UserID</th>
                    <th>Ten</th>
                    <th>Chuyen khoa</th>
                    <th>Status</th>
                </tr>");

                int count = 0;
                while (rs.next()) {
                count++;
                out.println("<tr>");
                    out.println("<td>" + rs.getInt("doctor_id") + "</td>");
                    out.println("<td>" + rs.getInt("user_id") + "</td>");
                    out.println("<td>" + rs.getString("full_name") + "</td>");
                    out.println("<td>" + rs.getString("specialty") + "</td>");
                    out.println("<td>" + rs.getString("status") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                out.println("<p>Tong so: " + count + "</p>");

                rs.close();
                ps.close();
                conn.close();
                } catch (Exception e) {
                out.println("Loi: " + e.getMessage());
                }
                %>
        </body>

        </html>