<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tiengviet.entity.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    String userLevel = user.getLevel();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile – VietJoy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap');
        html, body { height: 100%; }
        body {
            transform: scale(0.8);
            transform-origin: top left;
            width: 125%;
            height: 125%;
            font-family: 'Nunito', sans-serif;
            display: flex;
            flex-direction: column;
        }
        .form-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 0.5rem center;
            background-repeat: no-repeat;
            background-size: 1.5em 1.5em;
            padding-right: 2.5rem;
        }
        .main-wrapper { flex-grow: 1; }

        /* CSS CHO PHẦN THÔNG BÁO */
        #notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            color: white;
            z-index: 1000;
            opacity: 0;
            transition: opacity 0.3s, transform 0.3s;
            transform: translateY(-20px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        #notification.show {
            opacity: 1;
            transform: translateY(0);
        }
        #notification.success { background-color: #28a745; } /* Màu xanh lá */
        #notification.error { background-color: #dc3545; }   /* Màu đỏ */
    </style>
</head>
<body class="bg-gradient-to-br from-yellow-200 to-orange-300">

<%@ include file="/includes/header.jsp" %>

<!-- THẺ DIV DÙNG ĐỂ HIỂN THỊ THÔNG BÁO -->
<div id="notification"></div>

<div class="main-wrapper flex">
    <!-- Sidebar -->
    <aside class="group w-24 hover:w-64 transition-all duration-300 bg-white/50 backdrop-blur-sm flex flex-col py-8 space-y-4 border-r border-white/30 flex-shrink-0 overflow-hidden">
        <a href="/my-profile" class="flex items-center p-4 space-x-4 group-hover:justify-start justify-center hover:bg-orange-100 rounded-xl transition-all">
            <i class="fas fa-user fa-lg text-orange-600"></i>
            <span class="text-orange-900 font-medium text-sm hidden group-hover:inline">My Profile</span>
        </a>
        <a href="/security" class="flex items-center p-4 space-x-4 group-hover:justify-start justify-center hover:bg-orange-100 rounded-xl transition-all">
            <i class="fas fa-key fa-lg text-orange-600"></i>
            <span class="text-orange-900 font-medium text-sm hidden group-hover:inline">Security</span>
        </a>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 p-8 flex items-center justify-center">
        <div class="w-full max-w-6xl bg-white/80 backdrop-blur-md rounded-2xl shadow-xl overflow-hidden">
            <div class="h-40 bg-gradient-to-r from-yellow-400 to-orange-500"></div>
            <div class="p-8">
                <!-- Phần thông tin -->
                <div id="profile-display" class="flex items-center -mt-24 mb-6">
                    <img src="/images/avt/crocodile.png" alt="Avatar" class="w-32 h-32 rounded-full object-cover border-8 border-white/80 shadow-lg flex-shrink-0">
                    <div class="ml-6 flex-grow">
                        <div class="flex items-center gap-x-4 mb-1">
                            <!-- Thêm ID để JavaScript có thể cập nhật -->
                            <h2 id="display-username" class="text-3xl font-bold text-orange-900"><%= user.getUsername() %></h2>
                            <div class="inline-flex items-center bg-yellow-400 text-yellow-900 px-3 py-1 rounded-full text-sm font-semibold shadow">
                                <i class="fas fa-star mr-2"></i><span id="display-level"><%= userLevel %></span>
                            </div>
                        </div>
                        <p class="text-orange-800/80"><%= user.getEmail() %></p>
                    </div>
                    <button id="edit-button" class="bg-orange-500 text-white font-semibold px-8 py-3 rounded-lg hover:bg-orange-600 transition-all shadow-md ml-auto">Edit</button>
                </div>

                <!-- Form chỉnh sửa (ẩn) -->
                <div id="edit-form-section" class="hidden">
                    <!-- Thêm ID cho form -->
                    <form id="update-profile-form">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                            <div>
                                <label for="username" class="block mb-2 font-semibold text-orange-900">Username</label>
                                <input type="text" id="username" name="username" class="w-full bg-white/70 border border-orange-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-400" value="<%= user.getUsername() %>">
                            </div>
                            <div>
                                <label for="level" class="block mb-2 font-semibold text-orange-900">Level</label>
                                <select id="level" name="level" class="form-select w-full bg-white/70 border border-orange-200 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-orange-400">
                                    <option value="Beginner" <%= "Beginner".equals(userLevel) ? "selected" : "" %>>Beginner</option>
                                    <option value="Intermediate" <%= "Intermediate".equals(userLevel) ? "selected" : "" %>>Intermediate</option>
                                    <option value="Advanced" <%= "Advanced".equals(userLevel) ? "selected" : "" %>>Advanced</option>
                                </select>
                            </div>
                        </div>
                        <div class="mt-8 flex justify-end space-x-4">
                            <button type="button" id="cancel-button" class="bg-gray-200 text-gray-700 font-semibold px-6 py-2 rounded-lg hover:bg-gray-300 transition">Cancel</button>
                            <button type="submit" class="bg-orange-500 text-white font-semibold px-6 py-2 rounded-lg hover:bg-orange-600 transition shadow">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // --- Lấy các phần tử DOM cần thiết ---
    const editButton = document.getElementById('edit-button');
    const cancelButton = document.getElementById('cancel-button');
    const profileDisplaySection = document.getElementById('profile-display');
    const editFormSection = document.getElementById('edit-form-section');
    const updateForm = document.getElementById('update-profile-form');
    const notification = document.getElementById('notification');

    // --- Hàm hiển thị thông báo ---
    function showNotification(message, type) {
        notification.textContent = message;
        notification.className = type; // Gán class 'success' hoặc 'error'
        notification.classList.add('show');

        // Tự động ẩn thông báo sau 3 giây
        setTimeout(() => {
            notification.classList.remove('show');
        }, 3000);
    }

    // --- Chuyển đổi giữa chế độ xem và chỉnh sửa ---
    editButton.addEventListener('click', () => {
        editButton.classList.add('hidden'); // Ẩn nút Edit
        profileDisplaySection.classList.add('hidden'); // Ẩn phần hiển thị thông tin
        editFormSection.classList.remove('hidden'); // Hiện form chỉnh sửa
    });

    cancelButton.addEventListener('click', () => {
        editButton.classList.remove('hidden'); // Hiện lại nút Edit
        profileDisplaySection.classList.remove('hidden'); // Hiện lại phần thông tin
        editFormSection.classList.add('hidden'); // Ẩn form đi
    });

    // --- Xử lý gửi form bằng Fetch API (AJAX) ---
    updateForm.addEventListener('submit', function (event) {
        // Ngăn form gửi đi theo cách truyền thống (tải lại trang)
        event.preventDefault();

        const formData = new FormData(this);

        fetch('update-profile', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
            .then(response => {
                // Luôn cố gắng parse JSON, ngay cả khi có lỗi HTTP
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    showNotification(data.message, 'success');

                    // Cập nhật lại thông tin trên giao diện ngay lập tức
                    const updatedUser = data.updatedUser;
                    document.getElementById('display-username').textContent = updatedUser.username;
                    document.getElementById('display-level').textContent = updatedUser.level;

                    // Tự động chuyển về giao diện hiển thị thông tin
                    cancelButton.click();
                } else {
                    // Hiển thị thông báo lỗi từ server
                    showNotification(data.message || 'An unknown error occurred.', 'error');
                }
            })
            .catch(error => {
                console.error('Error submitting form:', error);
                showNotification('Failed to connect to the server.', 'error');
            });
    });

</script>
</body>
</html>