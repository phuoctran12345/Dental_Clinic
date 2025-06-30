<%-- 
    Document   : demo
    Created on : May 17, 2025, 8:05:39 PM
    Author     : Home
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Hình răng xoay</title>
<style>
  body {
    background: #222;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    perspective: 800px; /* tạo chiều sâu */
  }
  .tooth-image {
    width: 300px;
    height: 300px;
    background: url('imgs/dental.png') no-repeat center/contain;
    border-radius: 20px;
    transform-style: preserve-3d;
    animation: spin 10s linear infinite;
    box-shadow: 0 10px 20px rgba(0,255,255,0.5);
  }
  @keyframes spin {
    from {
      transform: rotateY(0deg) rotateX(0deg);
    }
    to {
      transform: rotateY(360deg) rotateX(20deg);
    }
  }
</style>
</head>
<body>
  <div class="tooth-image"></div>
  <h2>hello</h2>
</body>
</html>
