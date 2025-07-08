<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.io.*" %>
        <%@ page import="java.util.*" %>
            <%@ page import="java.text.SimpleDateFormat" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Xem Log Hệ Thống - RoleStaff</title>
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            margin: 0;
                            padding: 20px;
                            background-color: #f5f5f5;
                        }

                        .container {
                            max-width: 1200px;
                            margin: 0 auto;
                            background: white;
                            padding: 20px;
                            border-radius: 8px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }

                        .header {
                            border-bottom: 2px solid #007bff;
                            padding-bottom: 10px;
                            margin-bottom: 20px;
                        }

                        .log-controls {
                            margin-bottom: 20px;
                            padding: 15px;
                            background: #f8f9fa;
                            border-radius: 5px;
                        }

                        .log-viewer {
                            background: #1e1e1e;
                            color: #ffffff;
                            padding: 15px;
                            border-radius: 5px;
                            max-height: 600px;
                            overflow-y: auto;
                            font-family: 'Courier New', monospace;
                            font-size: 12px;
                            line-height: 1.4;
                        }

                        .log-level-ERROR {
                            color: #ff4444;
                            font-weight: bold;
                        }

                        .log-level-SEVERE {
                            color: #ff4444;
                            font-weight: bold;
                        }

                        .log-level-WARNING {
                            color: #ffaa00;
                        }

                        .log-level-INFO {
                            color: #00aaff;
                        }

                        .log-level-DEBUG {
                            color: #88dd88;
                        }

                        .log-level-FINE {
                            color: #88dd88;
                        }

                        .refresh-btn {
                            background: #007bff;
                            color: white;
                            border: none;
                            padding: 10px 20px;
                            border-radius: 5px;
                            cursor: pointer;
                            font-size: 14px;
                        }

                        .refresh-btn:hover {
                            background: #0056b3;
                        }

                        .log-filter {
                            margin-right: 10px;
                            padding: 5px 10px;
                            border: 1px solid #ddd;
                            border-radius: 3px;
                        }

                        .auto-refresh {
                            margin-left: 10px;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <div class="header">
                            <h1>🔍 Xem Log Hệ Thống</h1>
                            <p>Theo dõi log realtime của ứng dụng RoleStaff</p>
                        </div>

                        <div class="log-controls">
                            <form method="get" style="display: inline;">
                                <select name="logFile" class="log-filter">
                                    <option value="catalina">Catalina Log (General)</option>
                                    <option value="localhost">Localhost Log (App)</option>
                                    <option value="manager">Manager Log</option>
                                    <option value="host-manager">Host Manager Log</option>
                                </select>

                                <select name="lines" class="log-filter">
                                    <option value="100">100 dòng cuối</option>
                                    <option value="200">200 dòng cuối</option>
                                    <option value="500">500 dòng cuối</option>
                                    <option value="1000">1000 dòng cuối</option>
                                </select>

                                <button type="submit" class="refresh-btn">🔄 Refresh</button>

                                <label class="auto-refresh">
                                    <input type="checkbox" id="autoRefresh"> Auto refresh (10s)
                                </label>
                            </form>
                        </div>

                        <div class="log-viewer" id="logContent">
                            <% String logFile=request.getParameter("logFile"); String
                                linesParam=request.getParameter("lines"); if (logFile==null) logFile="localhost" ; if
                                (linesParam==null) linesParam="200" ; int lines=Integer.parseInt(linesParam); // Đường
                                dẫn tới file log String logPath=application.getRealPath("/") + "../logs/" ; String
                                fileName="" ; switch(logFile) { case "catalina" : fileName="catalina.out" ; break;
                                case "localhost" : fileName="localhost." + new SimpleDateFormat("yyyy-MM-dd").format(new
                                Date()) + ".log" ; break; case "manager" : fileName="manager." + new
                                SimpleDateFormat("yyyy-MM-dd").format(new Date()) + ".log" ; break; case "host-manager"
                                : fileName="host-manager." + new SimpleDateFormat("yyyy-MM-dd").format(new Date())
                                + ".log" ; break; default: fileName="localhost." + new
                                SimpleDateFormat("yyyy-MM-dd").format(new Date()) + ".log" ; } File file=new
                                File(logPath + fileName); if (file.exists()) { try { // Đọc file log List<String>
                                logLines = new ArrayList<>();
                                    BufferedReader reader = new BufferedReader(new FileReader(file));
                                    String line;

                                    while ((line = reader.readLine()) != null) {
                                    logLines.add(line);
                                    }
                                    reader.close();

                                    // Lấy n dòng cuối
                                    int startIndex = Math.max(0, logLines.size() - lines);
                                    for (int i = startIndex; i < logLines.size(); i++) { String logLine=logLines.get(i);
                                        String cssClass="" ; // Tô màu theo level if (logLine.contains("SEVERE") ||
                                        logLine.contains("ERROR")) { cssClass="log-level-ERROR" ; } else if
                                        (logLine.contains("WARNING")) { cssClass="log-level-WARNING" ; } else if
                                        (logLine.contains("INFO")) { cssClass="log-level-INFO" ; } else if
                                        (logLine.contains("DEBUG") || logLine.contains("FINE")) {
                                        cssClass="log-level-DEBUG" ; } out.println("<div class='" + cssClass + "'>" +
                                        logLine.replace("<", "&lt;" ).replace(">", "&gt;") +
                                            "
                        </div>");
                        }

                        } catch (Exception e) {
                        out.println("<div class='log-level-ERROR'>❌ Lỗi đọc file log: " + e.getMessage() + "</div>");
                        }
                        } else {
                        out.println("<div class='log-level-WARNING'>⚠️ File log không tồn tại: " +
                            file.getAbsolutePath() + "</div>");
                        out.println("<div class='log-level-INFO'>💡 Hãy chạy ứng dụng để tạo log</div>");
                        }
                        %>
                    </div>
                    </div>

                    <script>
                        // Auto refresh functionality
                        let autoRefreshInterval;

                        document.getElementById('autoRefresh').addEventListener('change', function () {
                            if (this.checked) {
                                autoRefreshInterval = setInterval(function () {
                                    location.reload();
                                }, 10000); // Refresh every 10 seconds
                            } else {
                                clearInterval(autoRefreshInterval);
                            }
                        });

                        // Auto scroll to bottom
                        const logContent = document.getElementById('logContent');
                        logContent.scrollTop = logContent.scrollHeight;
                    </script>
                </body>

                </html>