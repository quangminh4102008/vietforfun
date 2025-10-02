<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sign Up – VietJoy</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://kit.fontawesome.com/your_kit_id.js" crossorigin="anonymous"></script>

  <!-- Animated background blobs + floating icons styles -->
  <style>
    /* Moving gradient already inlined */
    @keyframes bg-pan {
      0% { background-position:0% 50%; }
      50% { background-position:100% 50%; }
      100% { background-position:0% 50%; }
    }
    body {
      background: linear-gradient(270deg, #FFE082, #FFB74D, #FF8A65);
      background-size:600% 600%;
      animation:bg-pan 12s ease infinite;
    }

    /* Blob shapes */
    .blob {
      position: absolute;
      background: rgba(255,205,100,0.4);
      border-radius: 50%;
      filter: blur(60px);
      animation: blob-move 12s infinite;
    }
    .blob:nth-child(1) { width: 300px; height: 300px; top: -100px; left: -100px; animation-delay: 0s; }
    .blob:nth-child(2) { width: 400px; height: 400px; top: 50%; left: 70%; background: rgba(255,135,85,0.4); animation-delay: 4s; }
    .blob:nth-child(3) { width: 250px; height: 250px; top: 75%; left: 10%; background: rgba(250,180,100,0.4); animation-delay: 8s; }
    @keyframes blob-move {
      0%   { transform: translate(0,0) scale(1); }
      25%  { transform: translate(30px,-50px) scale(1.1); }
      50%  { transform: translate(-20px,30px) scale(0.9); }
      75%  { transform: translate(50px,20px) scale(1.05); }
      100% { transform: translate(0,0) scale(1); }
    }

    /* Floating icon animation */
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

    /* Form container sizing */
    .form-container {
      width: 600px;
      max-width: 90%;
    }
  </style>

  <script>
    function validateForm() {
      const pwd = document.getElementById('password').value;
      const msg = document.getElementById('pwdMsg');
      if (!/(?=.*\d).{8,}/.test(pwd)) {
        msg.textContent = 'Password must be at least 8 characters and include a number.';
        return false;
      }
      return true;
    }
  </script>
</head>
<body class="relative min-h-screen flex items-center justify-center overflow-hidden">

<!-- Blobs -->
<div class="blob"></div>
<div class="blob"></div>
<div class="blob"></div>

<!-- Floating icons -->
<i class="fas fa-book-open float-icon" style="top:15%; left:10%;"></i>
<i class="fas fa-user-graduate float-icon" style="top:25%; left:80%; animation-delay:2s;"></i>
<i class="fas fa-comments float-icon" style="top:70%; left:30%; animation-delay:4s;"></i>
<i class="fas fa-lightbulb float-icon" style="top:60%; left:85%; animation-delay:6s;"></i>

<!-- Registration Form -->
<div class="form-container bg-white bg-opacity-90 backdrop-blur-md p-10 rounded-3xl shadow-2xl z-10">
  <h1 class="text-4xl font-extrabold text-yellow-600 text-center mb-6">Create Your Account</h1>
  <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()" class="space-y-6">
    <div>
      <label for="username" class="block text-lg font-semibold text-yellow-800 mb-2">Username</label>
      <input type="text" id="username" name="username" required
             class="w-full px-5 py-4 rounded-xl border-2 border-yellow-300 focus:border-yellow-500 outline-none text-xl"/>
    </div>
    <div>
      <label for="email" class="block text-lg font-semibold text-yellow-800 mb-2">Email Address</label>
      <input type="email" id="email" name="email" required
             class="w-full px-5 py-4 rounded-xl border-2 border-yellow-300 focus:border-yellow-500 outline-none text-xl"/>
    </div>
    <div>
      <label for="password" class="block text-lg font-semibold text-yellow-800 mb-2">Password</label>
      <input type="password" id="password" name="password" required
             class="w-full px-5 py-4 rounded-xl border-2 border-yellow-300 focus:border-yellow-500 outline-none text-xl"/>
      <p id="pwdMsg" class="mt-2 text-red-600 text-lg"></p>
    </div>
    <div>
      <label for="confirmPassword" class="block text-lg font-semibold text-yellow-800 mb-2">Confirm Password</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required
             class="w-full px-5 py-4 rounded-xl border-2 border-yellow-300 focus:border-yellow-500 outline-none text-xl"/>
    </div>
    <div>
      <label for="level" class="block text-lg font-semibold text-yellow-800 mb-2">Level</label>
      <select id="level" name="level" required
              class="w-full px-5 py-4 rounded-xl border-2 border-yellow-300 focus:border-yellow-500 outline-none text-xl bg-white">
        <option value="" disabled selected>Select your level</option>
        <option value="Beginner">Beginner</option>
        <option value="Intermediate">Intermediate</option>
        <option value="Advanced">Advanced</option>
      </select>
    </div>
    <button type="submit"
            class="w-full py-4 rounded-full bg-gradient-to-r from-yellow-400 to-orange-400 text-white font-bold text-2xl shadow-lg hover:from-orange-400 hover:to-yellow-400 transition">
      Sign Up
    </button>
    <p class="text-center text-yellow-800 text-lg">Already have an account?
      <a href="${pageContext.request.contextPath}/login" class="font-bold underline hover:text-yellow-900">Log In</a>
    </p>
    <p class="text-red-600 text-center text-lg">${errorMessage}</p>
  </form>
</div>
</body>
</html>
