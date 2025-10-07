<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tiengviet.entity.User" %>
<%
    // Ensure user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Security Settings – VietJoy</title>
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
    <style>
        body{
            transform: scale(0.8);
            transform-origin: top left;
            width: 125%;
            height: 125%;
        }
        /* Playful bounce in */
        @keyframes bounceIn {
            0%   { opacity: 0; transform: scale(0.8) }
            60%  { opacity: 1; transform: scale(1.05) }
            100% { transform: scale(1) }
        }
        .animate-bounce-in {
            animation: bounceIn 0.6s ease forwards;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-yellow-200 to-orange-300 min-h-screen flex flex-col">

<%@ include file="/includes/header.jsp" %>

<div class="flex flex-1">
    <!-- Sidebar (same as my-profile, in English) -->
    <aside class="group w-24 hover:w-64 transition-all duration-300 bg-white/50 backdrop-blur-sm
                  flex flex-col py-8 space-y-8 border-r border-white/30 flex-shrink-0 overflow-hidden">
        <a href="<%=request.getContextPath()%>/my-profile"
           class="flex items-center p-4 space-x-4 justify-center group-hover:justify-start
                hover:bg-orange-100 rounded-xl transition-all">
            <i class="fas fa-user fa-lg text-orange-600"></i>
            <span class="text-orange-900 font-medium text-sm hidden group-hover:inline">My Profile</span>
        </a>
        <a href="<%=request.getContextPath()%>/security"
           class="flex items-center p-4 space-x-4 justify-center group-hover:justify-start
                hover:bg-orange-100 rounded-xl transition-all bg-orange-200">
            <i class="fas fa-key fa-lg text-orange-600"></i>
            <span class="text-orange-900 font-medium text-sm hidden group-hover:inline">Security</span>
        </a>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-8">
        <div class="max-w-xl mx-auto bg-white/90 p-6 rounded-2xl shadow-lg space-y-4">
            <h2 class="text-3xl font-extrabold text-orange-700 text-center">Security Settings</h2>
            <p class="text-center text-gray-600">Manage your password safely</p>

            <div class="flex justify-center">
                <button id="openBtn"
                        class="bg-orange-500 hover:bg-orange-600 text-white font-bold py-2 px-6 rounded-full
                         transition transform hover:scale-105 shadow-lg focus:outline-none">
                    Change Password
                </button>
            </div>

            <div id="formContainer" class="hidden mt-4">
                <form method="post" action="<%=request.getContextPath()%>/security"
                      class="bg-gradient-to-br from-orange-100 to-yellow-100 p-6 rounded-lg animate-bounce-in space-y-4">
                    <input type="hidden" name="action" value="change-password">

                    <div>
                        <label for="currentPassword"
                               class="block text-sm font-semibold text-orange-800 mb-1">Current Password</label>
                        <input id="currentPassword" name="currentPassword" type="password" required
                               class="w-full px-3 py-2 border border-orange-300 rounded-lg
                            focus:outline-none focus:ring-2 focus:ring-yellow-400">
                    </div>

                    <div>
                        <label for="newPassword"
                               class="block text-sm font-semibold text-orange-800 mb-1">New Password</label>
                        <input id="newPassword" name="newPassword" type="password" required
                               class="w-full px-3 py-2 border border-orange-300 rounded-lg
                            focus:outline-none focus:ring-2 focus:ring-yellow-400">
                    </div>

                    <div>
                        <label for="confirmPassword"
                               class="block text-sm font-semibold text-orange-800 mb-1">Confirm New Password</label>
                        <input id="confirmPassword" name="confirmPassword" type="password" required
                               class="w-full px-3 py-2 border border-orange-300 rounded-lg
                            focus:outline-none focus:ring-2 focus:ring-yellow-400">
                    </div>

                    <div class="flex justify-end space-x-3">
                        <button type="button" id="cancelBtn"
                                class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-2 px-4 rounded-lg transition">
                            Cancel
                        </button>
                        <button type="submit"
                                class="bg-yellow-400 hover:bg-yellow-500 text-orange-800 font-bold py-2 px-6 rounded-full
                             transition transform hover:scale-105 shadow-lg">
                            Save
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    const openBtn   = document.getElementById('openBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    const formCont  = document.getElementById('formContainer');

    openBtn.addEventListener('click', () => {
        formCont.classList.remove('hidden');
        openBtn.classList.add('hidden');
    });
    cancelBtn.addEventListener('click', () => {
        formCont.classList.add('hidden');
        openBtn.classList.remove('hidden');
    });
</script>
</body>
</html>
