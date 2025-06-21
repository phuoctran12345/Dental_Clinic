<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@page import="java.util.List" %>
<%@page import="Model.Customer" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<%@ include file="/includes/header.jsp" %>
<%@ include file="/includes/banner.jsp" %>
<%@ include file="/includes/list_product.jsp" %>


 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="JS/script.js"></script>
<%@ include file="/includes/footer.jsp" %>
