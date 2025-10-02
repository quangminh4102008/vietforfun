<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<%--
    Bảo vệ trang: Chỉ cho phép truy cập nếu đã xác thực OTP.
    Chúng ta dùng JSTL <c:if> và <c:redirect> để an toàn hơn scriptlet.
--%>
<c:if test="${empty sessionScope.isOtpVerifiedForReset or not sessionScope.isOtpVerifiedForReset}">
  <%-- Nếu cờ xác thực không tồn tại hoặc là false, chuyển hướng về trang login --%>
  <c:redirect url="${pageContext.request.contextPath}/login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reset Password - VietJoy</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Comic+Neue:wght@400;700&display=swap');
    body { font-family: 'Comic Neue', cursive; }
  </style>
</head>
<body class="bg-yellow-50 min-h-screen flex items-center justify-center">


<div class="bg-white rounded-2xl shadow-xl p-8 max-w-md w-full">
  <h1 class="text-3xl font-bold text-orange-500 text-center mb-6">Create a New Password</h1>

  <c:if test="${not empty errorMessage}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
      <span class="block sm:inline">${errorMessage}</span>
    </div>
  </c:if>

  <form id="resetForm" action="${pageContext.request.contextPath}/reset-password" method="post">
    <div class="mb-4">
      <label for="newPassword" class="block text-gray-700 text-sm font-bold mb-2">New Password:</label>
      <input type="password" id="newPassword" name="newPassword" required
             class="shadow appearance-none border rounded-lg w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:shadow-outline focus:border-orange-400">
    </div>
    <div class="mb-6">
      <label for="confirmPassword" class="block text-gray-700 text-sm font-bold mb-2">Confirm New Password:</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required
             class="shadow appearance-none border rounded-lg w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:shadow-outline focus:border-orange-400">
    </div>
    <div class="flex items-center justify-center">
      <button type="submit" id="submitBtn"
              class="w-full bg-orange-500 hover:bg-orange-600 text-white font-bold py-3 px-4 rounded-lg focus:outline-none focus:shadow-outline transition-transform transform hover:scale-105">
        Reset Password
      </button>
    </div>
  </form>
</div>
<script>
  const form = document.getElementById('resetForm');
  const newPassword = document.getElementById('newPassword');
  const confirmPassword = document.getElementById('confirmPassword');

  form.addEventListener('submit', function(e) {
    if (newPassword.value.length < 6) { // Thêm kiểm tra độ dài tối thiểu
      e.preventDefault();
      alert("Password must be at least 6 characters long.");
      return;
    }
    if (newPassword.value !== confirmPassword.value) {
      e.preventDefault();
      alert("Passwords do not match!");
    }
  });
</script>
</body>
</html>