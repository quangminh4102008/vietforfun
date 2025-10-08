<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LingoLearn | OTP Verification</title>
  <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
  <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script>
    // Tailwind CSS configuration from your example
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            lingo: {
              orange: '#FF9500',
              yellow: '#FFCC00',
              green: '#58CC02',
              blue: '#1CB0F6',
            }
          },
          fontFamily: {
            'sans': ['"Comic Neue"', 'cursive']
          }
        }
      }
    }
  </script>
  <style>
    /* All CSS from your example is kept, with minor adjustments */
    @import url('https://fonts.googleapis.com/css2?family=Comic+Neue:wght@400;700&display=swap');
    body {
      zoom: 80%;
      /* Đảm bảo chiều cao tối thiểu 100vh để footer không bị tràn lên khi nội dung ngắn */
      min-height: 100vh;
      overflow-x: hidden;
      font-family: 'Comic Neue', cursive; background-color: #f5f5f5; }
    .otp-input { width: 50px; height: 60px; font-size: 24px; text-align: center; margin: 0 5px; border-radius: 12px; border: 3px solid #FFCC00; background-color: white; color: #333; font-weight: bold; transition: all 0.3s; }
    .otp-input:focus { border-color: #FF9500; outline: none; transform: scale(1.05); box-shadow: 0 0 10px rgba(255, 149, 0, 0.5); }
    .progress-bar { height: 8px; border-radius: 4px; background-color: #e0e0e0; overflow: hidden; }
    .progress-fill { height: 100%; background: linear-gradient(90deg, #FF9500, #FFCC00); animation: progress 60s linear forwards; }
    @keyframes progress { from { width: 100%; } to { width: 0%; } }
    .btn-hover:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(255, 149, 0, 0.3); }
    .btn-active:active { transform: translateY(0); }
  </style>
</head>
<body class="bg-lingo-yellow bg-opacity-10 min-h-screen flex flex-col items-center justify-center">
<div class="container mx-auto px-4 py-8">
  <!-- Main content -->
  <main class="flex flex-col items-center justify-center">
    <div class="bg-white rounded-3xl shadow-xl p-8 w-full max-w-md">
      <header class="text-center mb-6">
        <h1 class="text-4xl font-bold text-lingo-orange">VietJoy</h1>
        <p class="text-lg text-gray-600 mt-2">The fun way to master new skills!</p>
      </header>

      <div class="text-center mb-6">
        <div class="w-20 h-20 bg-lingo-yellow rounded-full flex items-center justify-center mx-auto mb-4">
          <i class="fas fa-envelope text-3xl text-white"></i>
        </div>
        <h2 class="text-2xl font-bold text-gray-800">Verify Your Email</h2>

        <c:if test="${not empty errorMessage}">
          <p class="text-red-500 font-bold mt-2">${errorMessage}</p>
        </c:if>

        <p class="text-gray-600 mt-2">We've sent a 6-digit code to:</p>
        <%-- FIX 1: Dòng này bây giờ sẽ hoạt động --%>
        <p class="font-bold text-lingo-orange">${sessionScope.emailForVerification}</p>
      </div>

      <!-- DYNAMIC FORM: This form will submit the data to your /verify servlet -->
      <form id="otpForm" action="<c:url value='/${sessionScope.formAction}'/>" method="post">        <!-- This hidden input will hold the combined 6-digit OTP -->
        <input type="hidden" name="otp" id="hiddenOtpInput">

        <div class="mb-6">
          <div class="flex justify-center mb-4" id="otp-container">
            <input type="text" maxlength="1" class="otp-input" data-index="0">
            <input type="text" maxlength="1" class="otp-input" data-index="1">
            <input type="text" maxlength="1" class="otp-input" data-index="2">
            <input type="text" maxlength="1" class="otp-input" data-index="3">
            <input type="text" maxlength="1" class="otp-input" data-index="4">
            <input type="text" maxlength="1" class="otp-input" data-index="5">
          </div>

          <!-- Timer and resend -->
          <div class="flex justify-between items-center mt-4">
            <div class="text-sm text-gray-500">
              <span id="timer">01:00</span> remaining
            </div>
            <!-- DYNAMIC RESEND: This is now a link to trigger the resend servlet -->
            <!-- DYNAMIC RESEND: The href will be set by JavaScript when the timer ends -->
            <a href="#" id="resendLink" class="text-sm font-bold text-lingo-orange opacity-50 cursor-not-allowed" style="pointer-events: none;">
              Resend Code
            </a>
          </div>

          <!-- Progress bar -->
          <div class="progress-bar mt-2">
            <div class="progress-fill"></div>
          </div>
        </div>

        <!-- Verify button -->
        <button type="submit" id="verifyBtn" class="w-full py-4 bg-lingo-orange hover:bg-lingo-orange-dark text-white font-bold rounded-xl transition-all duration-300 btn-hover btn-active disabled:opacity-50 disabled:cursor-not-allowed" disabled>
          Verify & Continue
          <i class="fas fa-arrow-right ml-2"></i>
        </button>
      </form>
    </div>
  </main>
</div>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const resendUrl = `<c:url value="/resend-otp"/>`;
    const otpForm = document.getElementById('otpForm');
    const otpContainer = document.getElementById('otp-container');
    const otpInputs = document.querySelectorAll('.otp-input');
    const hiddenOtpInput = document.getElementById('hiddenOtpInput');
    const verifyBtn = document.getElementById('verifyBtn');
    const resendLink = document.getElementById('resendLink');
    const timerElement = document.getElementById('timer');

    let timeLeft = 60; // 1 minute in seconds
    let timerInterval;

    function startTimer() {
      clearInterval(timerInterval);
      timeLeft = 60;
      resendLink.classList.add('opacity-50', 'cursor-not-allowed');
      resendLink.style.pointerEvents = 'none';

      timerInterval = setInterval(() => {
        timeLeft--;
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;

        // *** DÒNG QUAN TRỌNG ĐÃ ĐƯỢC SỬA ***
        // Sử dụng cách nối chuỗi bằng dấu '+' để tránh xung đột với JSP
        timerElement.textContent = minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');

        if (timeLeft <= 0) {
          clearInterval(timerInterval);
          timerElement.textContent = "00:00";
          resendLink.classList.remove('opacity-50', 'cursor-not-allowed');
          resendLink.style.pointerEvents = 'auto';
          resendLink.href = resendUrl; // QUAN TRỌNG: Gán URL cho link khi hết giờ
        }
      }, 1000);
    }

    otpContainer.addEventListener('input', (e) => {
      if (e.target.tagName === 'INPUT') {
        const target = e.target;
        const next = target.nextElementSibling;
        if (target.value && next) {
          next.focus();
        }
        checkOTPCompletion();
      }
    });

    otpContainer.addEventListener('keydown', (e) => {
      if (e.key === 'Backspace' && e.target.tagName === 'INPUT') {
        if (!e.target.value && e.target.previousElementSibling) {
          e.target.previousElementSibling.focus();
        }
      }
    });

    function checkOTPCompletion() {
      verifyBtn.disabled = ![...otpInputs].every(input => input.value);
    }

    otpForm.addEventListener('submit', () => {
      hiddenOtpInput.value = [...otpInputs].map(input => input.value).join('');
    });

    // Start the timer when the page loads
    startTimer();
  });
</script>
</body>
</html>