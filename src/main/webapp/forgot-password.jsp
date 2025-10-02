<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Forgot Password - VietJoy</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    /* Bạn có thể thêm các style tương tự như các trang khác */
    @import url('https://fonts.googleapis.com/css2?family=Comic+Neue:wght@400;700&display=swap');
    body { font-family: 'Comic Neue', cursive; }
  </style>
</head>
<body class="bg-yellow-50 min-h-screen flex items-center justify-center">
<div class="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full">
  <h1 class="text-3xl font-bold text-orange-500 text-center mb-2">Forgot Your Password?</h1>
  <p class="text-gray-600 text-center mb-6">No worries! Enter your email and we'll send you a reset code.</p>

  <c:if test="${not empty errorMessage}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
      <span class="block sm:inline">${errorMessage}</span>
    </div>
  </c:if>

  <form action="forgot-password" method="post">
    <div class="mb-4">
      <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email Address:</label>
      <input type="email" id="email" name="email" required
             class="shadow appearance-none border rounded-lg w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:shadow-outline focus:border-orange-400">
    </div>
    <div class="flex items-center justify-between">
      <button type="submit"
              class="w-full bg-orange-500 hover:bg-orange-600 text-white font-bold py-3 px-4 rounded-lg focus:outline-none focus:shadow-outline transition-transform transform hover:scale-105">
        Send Reset Code
      </button>
    </div>
    <div class="text-center mt-4">
      <a href="login.jsp" class="inline-block align-baseline font-bold text-sm text-orange-500 hover:text-orange-800">
        Back to Login
      </a>
    </div>
  </form>
</div>
</body>
</html>