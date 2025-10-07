<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Log In – VietJoy</title>
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <script src="https://cdn.tailwindcss.com"></script>
    <%-- Sửa lỗi Font Awesome: Sử dụng link CSS từ CDN --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

    <!-- Animated background blobs + floating icons styles -->
    <style>
        @keyframes bg-pan {
            0% { background-position:0% 50%; }
            50% { background-position:100% 50%; }
            100% { background-position:0% 50%; }
        }
        body {
            transform: scale(0.8);
            transform-origin: top left;
            width: 125%;
            height: 125%;
            background: linear-gradient(270deg, #FFE082, #FFB74D, #FF8A65);
            background-size:600% 600%;
            animation:bg-pan 12s ease infinite;
        }
        .blob {
            position: absolute;
            background: rgba(255,205,100,0.4);
            border-radius: 50%;
            filter: blur(60px);
            animation: blob-move 12s infinite;
        }
        .blob:nth-child(1) { width: 300px; height: 300px; top: -100px; left: -100px; }
        .blob:nth-child(2) { width: 400px; height: 400px; top: 50%; left: 70%; background: rgba(255,135,85,0.4); }
        .blob:nth-child(3) { width: 250px; height: 250px; top: 75%; left: 10%; background: rgba(250,180,100,0.4); }
        @keyframes blob-move {
            0%   { transform: translate(0,0) scale(1); }
            25%  { transform: translate(30px,-50px) scale(1.1); }
            50%  { transform: translate(-20px,30px) scale(0.9); }
            75%  { transform: translate(50px,20px) scale(1.05); }
            100% { transform: translate(0,0) scale(1); }
        }
        @keyframes float {
            0%,100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        .float-icon {
            position: absolute;
            font-size: 3rem;
            color: rgba(255,255,255,0.2);
            animation: float 6s ease-in-out infinite;
        }
        .form-container { width: 500px; max-width: 90%; }
    </style>
</head>
<body class="relative min-h-screen flex items-center justify-center overflow-hidden">

<!-- Blobs -->
<div class="blob"></div>
<div class="blob"></div>
<div class="blob"></div>

<!-- Floating icons -->
<i class="fas fa-book-open float-icon" style="top:15%; left:15%;"></i>
<i class="fas fa-user-graduate float-icon" style="top:25%; left:85%; animation-delay:2s;"></i>
<i class="fas fa-comments float-icon" style="top:70%; left:30%; animation-delay:4s;"></i>
<i class="fas fa-lightbulb float-icon" style="top:60%; left:85%; animation-delay:6s;"></i>

<!-- Login Form -->
<div class="form-container bg-white bg-opacity-80 backdrop-blur-md p-12 rounded-3xl shadow-2xl z-10">
    <h1 class="text-5xl font-extrabold text-orange-600 text-center mb-8">Welcome Back!</h1>
    <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-6"> <%-- Giảm space-y một chút --%>
        <div>
            <label for="username" class="block text-xl font-semibold text-orange-700 mb-2">Username</label>
            <input type="text" id="username" name="username" required
                   class="w-full px-6 py-5 rounded-xl border-2 border-orange-300 focus:border-orange-500 outline-none text-2xl"/>
        </div>
        <div>
            <label for="password" class="block text-xl font-semibold text-orange-700 mb-2">Password</label>
            <input type="password" id="password" name="password" required
                   class="w-full px-6 py-5 rounded-xl border-2 border-orange-300 focus:border-orange-500 outline-none text-2xl"/>
        </div>

        <!-- === PHẦN THÊM VÀO: LINK QUÊN MẬT KHẨU === -->
        <div class="text-right">
            <a href="${pageContext.request.contextPath}/forgot-password.jsp" class="font-bold text-lg text-orange-600 hover:text-orange-800 hover:underline transition">
                Forgot Password?
            </a>
        </div>
        <!-- === KẾT THÚC PHẦN THÊM VÀO === -->

        <button type="submit"
                class="w-full py-5 rounded-full bg-gradient-to-r from-orange-400 to-yellow-400 text-white font-bold text-2xl shadow-lg hover:from-yellow-400 hover:to-orange-400 transition">
            Log In
        </button>

        <p class="text-center text-orange-700 text-lg">Don't have an account?
            <a href="${pageContext.request.contextPath}/register.jsp" class="font-bold underline hover:text-orange-900">Sign Up</a>
        </p>

        <%-- Hiển thị thông báo lỗi hoặc thành công --%>
        <p class="text-red-600 text-center text-lg font-bold">${errorMessage}</p>
        <p class="text-green-600 text-center text-lg font-bold">${successMessage}</p>
        <c:remove var="successMessage" scope="session" />
    </form>
</div>
</body>
</html>