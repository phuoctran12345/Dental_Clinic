<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .search-container {
            max-width: 500px;
            margin: 0 auto;
        }
        .search-form {
            display: flex;
            gap: 10px;
        }
        .search-input {
            border-radius: 20px;
            padding-left: 20px;
        }
        .search-button {
            border-radius: 20px;
            padding: 0 20px;
        }
    </style>
</head>
<body>
    <header class="bg-white shadow-sm py-3">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <h1 class="h4 mb-0">Hospital Management</h1>
                </div>
                <div class="col-md-8">
                    <div class="search-container">
                        <form class="search-form" action="<c:url value='/search'/>" method="GET">
                            <div class="input-group">
                                <input type="text" 
                                       class="form-control search-input" 
                                       name="query" 
                                       placeholder="Tìm kiếm..."
                                       aria-label="Search">
                                <button class="btn btn-primary search-button" type="submit">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Bootstrap JS và Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html> 