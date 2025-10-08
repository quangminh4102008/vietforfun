<%@ page import="com.tiengviet.entity.User" %>

<%!
  private User currentUser;
%>

<%
  currentUser = (User) session.getAttribute("user");
%>

<header class="bg-yellow-400 shadow-md sticky top-0 z-50">
  <!-- SỬA: Xóa các class ml-[-70px] và mr-[-100px] gây lỗi -->
  <div class="container mx-auto px-4 py-3 flex justify-between items-center">

    <!-- Logo -->
    <div class="flex items-center space-x-2">
      <a href="/" class="flex items-center space-x-2">
        <div class="bg-red-500 text-white rounded-md w-10 h-10 flex items-center justify-center text-lg font-bold flex-shrink-0">
          VJ
        </div>
        <!-- Giảm kích thước chữ trên Mobile -->
        <h1 class="text-2xl sm:text-3xl font-bold text-red-600">VietForYou</h1>
      </a>
    </div>

    <!-- === NAV/RIGHT DESKTOP (Ẩn trên Mobile) === -->
    <div class="hidden md:flex items-center space-x-6">

      <!-- Nav -->
      <!-- SỬ DỤNG hidden md:flex -->
      <nav id="main-nav" class="flex space-x-2 text-gray-700">
        <a href="/" class="px-3 py-2 rounded-full transition hover:bg-white hover:text-red-500">Home</a>
        <a href="/courses" class="px-3 py-2 rounded-full transition hover:bg-white hover:text-red-500">Courses</a>
        <a href="/resources" class="px-3 py-2 rounded-full transition hover:bg-white hover:text-red-500">Resources</a>
        <a href="/chatbot" class="px-3 py-2 rounded-full transition hover:bg-white hover:text-red-500">Chat With Zest</a>
        <a href="/blog" class="px-3 py-2 rounded-full transition hover:bg-white hover:text-red-500">Blog</a>
        <a href="<%= request.getContextPath() %>/#contact-section" class="px-3 py-2 rounded-full transition hover:bg-white hover:text-red-500">Contact</a>
      </nav>

      <!-- Sign In / Avatar -->
      <div>
        <% if (currentUser == null) { %>
        <a href="<%= request.getContextPath() %>/login"
           class="px-8 py-2 bg-[#FFD580] text-[#A94400] text-lg tracking-wide font-semibold border border-[#FFA500] rounded-full
                    hover:bg-[#FFB347] hover:text-white hover:border-[#FF8C00] transition duration-200 shadow-md flex-shrink-0">
          Sign In
        </a>
        <% } else { %>
        <div class="relative ml-2">
          <button id="avatarBtnDesktop"
                  class="w-10 h-10 rounded-full bg-yellow-300 border-4 border-white shadow-md overflow-hidden
                           focus:outline-none transform hover:scale-105 transition duration-200">
            <img src="/images/avt/crocodile.png" alt="User Avatar" class="w-full h-full object-cover" />
          </button>
          <div id="avatarMenuDesktop"
               class="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-lg py-2
                        opacity-0 pointer-events-none transition-opacity duration-200 z-50">
            <div class="px-4 py-3 border-b">
              <p class="font-bold text-gray-800 truncate"><%= currentUser.getUsername() %></p>
              <p class="text-sm text-gray-500 truncate"><%= currentUser.getEmail() %></p>
            </div>
            <a href="<%= request.getContextPath() %>/my-profile" class="block px-4 py-2 text-gray-700 hover:bg-gray-100">Security</a>
            <a href="<%= request.getContextPath() %>/logout" class="block px-4 py-2 text-red-500 hover:bg-red-100 rounded-b-xl">Log out</a>
          </div>
        </div>
        <% } %>
      </div>
    </div>

    <!-- === HAMBURGER BUTTON MOBILE (Hiện trên Mobile) === -->
    <button id="mobile-menu-button" class="md:hidden text-gray-800 p-2 rounded-md hover:bg-yellow-300">
      <i class="fas fa-bars text-xl"></i>
    </button>
  </div>

  <!-- === MOBILE MENU DROPDOWN (Ẩn mặc định) === -->
  <div id="mobile-menu" class="hidden md:hidden bg-yellow-300">
    <nav class="flex flex-col p-4 space-y-2">
      <a href="/" class="py-2 px-4 hover:bg-white rounded-lg">Home</a>
      <a href="/courses" class="py-2 px-4 hover:bg-white rounded-lg">Courses</a>
      <a href="/resources" class="py-2 px-4 hover:bg-white rounded-lg">Resources</a>
      <a href="/chatbot" class="py-2 px-4 hover:bg-white rounded-lg">Chat With Zest</a>
      <a href="/blog" class="py-2 px-4 hover:bg-white rounded-lg">Blog</a>
      <a href="<%= request.getContextPath() %>/#contact-section" class="py-2 px-4 hover:bg-white rounded-lg">Contact</a>

      <% if (currentUser == null) { %>
      <a href="<%= request.getContextPath() %>/login" class="mt-4 py-2 px-4 bg-red-500 text-white font-bold rounded-full text-center">Sign In</a>
      <% } else { %>
      <a href="<%= request.getContextPath() %>/my-profile" class="mt-4 py-2 px-4 bg-red-500 text-white font-bold rounded-full text-center">My Profile</a>
      <a href="<%= request.getContextPath() %>/logout" class="py-2 px-4 text-red-700 font-bold hover:bg-red-100 rounded-lg">Log out</a>
      <% } %>
    </nav>
  </div>


  <!-- ===================================================================== -->
  <!-- === SCRIPT ĐÃ ĐƯỢC CẢI TIẾN LOGIC VÀ THÊM CHO MOBILE MENU === -->
  <!-- ===================================================================== -->
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      // === LOGIC CHO DESKTOP AVATAR DROPDOWN ===
      const btnDesktop  = document.getElementById('avatarBtnDesktop');
      const menuDesktop = document.getElementById('avatarMenuDesktop');
      if (btnDesktop && menuDesktop) {
        btnDesktop.addEventListener('click', e => {
          e.stopPropagation();
          menuDesktop.classList.toggle('opacity-0');
          menuDesktop.classList.toggle('pointer-events-none');
        });

        document.addEventListener('click', e => {
          if (menuDesktop.classList.contains('pointer-events-none')) return;
          if (!btnDesktop.contains(e.target) && !menuDesktop.contains(e.target)) {
            menuDesktop.classList.add('opacity-0','pointer-events-none');
          }
        });
      }

      // === LOGIC CHO MOBILE MENU (HAMBURGER) ===
      const mobileMenuButton = document.getElementById('mobile-menu-button');
      const mobileMenu = document.getElementById('mobile-menu');

      mobileMenuButton.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
      });


      // === LOGIC TÔ ĐẬM LINK ACTIVE ===
      const currentPagePath = window.location.pathname;
      const navLinks = document.querySelectorAll('#main-nav a, #mobile-menu a'); // Chọn cả link Mobile và Desktop

      navLinks.forEach(link => {
        let linkPath = link.getAttribute('href');

        // Xử lý các đường dẫn tương đối
        if (linkPath.startsWith('<%= request.getContextPath() %>')) {
          linkPath = linkPath.substring('<%= request.getContextPath() %>'.length);
        }

        // So sánh chính xác đường dẫn
        // 1. Trường hợp Trang chủ:
        if ((currentPagePath === '/' || currentPagePath.startsWith('/index')) && linkPath === '/') {
          setActive(link);
        }
        // 2. Các trường hợp trang con:
        else if (linkPath !== '/' && currentPagePath.startsWith(linkPath)) {
          setActive(link);
        }
      });

      function setActive(activeLink) {
        // Xóa các class transition mặc định
        activeLink.classList.remove('hover:bg-white', 'hover:text-red-500');

        // Thêm class active
        // Đối với Desktop Nav
        if (activeLink.closest('#main-nav')) {
          activeLink.classList.add('bg-white', 'text-red-500', 'font-semibold');
        }
        // Đối với Mobile Nav
        else if (activeLink.closest('#mobile-menu')) {
          activeLink.classList.add('bg-white', 'text-red-700', 'font-bold');
        }
      }
    });
  </script>
</header>