<%@ page import="com.tiengviet.entity.User" %>

<%!
  // Khai báo biến cấp lớp
  private User currentUser;
%>

<%
  // Gán session attribute "user" vào biến
  currentUser = (User) session.getAttribute("user");
%>

<header class="bg-yellow-400 shadow-md sticky top-0 z-50">
  <div class="container mx-auto px-4 py-3 flex justify-between items-center">
    <!-- Logo -->
    <div class="flex items-center space-x-2 ml-[-70px]">
      <a href="/" class="flex items-center space-x-2">
        <div class="bg-red-500 text-white rounded-md w-10 h-10 flex items-center justify-center text-lg font-bold">
          VJ
        </div>
        <h1 class="text-2xl font-bold text-red-600">VietForYou</h1>
      </a>
    </div>

    <!-- Navigation + Right -->
    <div class="flex items-center space-x-6 mr-[-100px]">
      <!-- Nav -->
      <nav id="main-nav" class="flex space-x-2 text-gray-700 mr-[30px]">
        <a href="/" class="px-4 py-2 rounded-full transition hover:bg-white hover:text-red-500">Home</a>
        <a href="/courses" class="px-4 py-2 rounded-full transition hover:bg-white hover:text-red-500">Courses</a>
        <a href="/resources" class="px-4 py-2 rounded-full transition hover:bg-white hover:text-red-500">Resources</a>
        <a href="/chatbot" class="px-4 py-2 rounded-full transition hover:bg-white hover:text-red-500">Chat With Zest</a>
        <a href="/blog" class="px-4 py-2 rounded-full transition hover:bg-white hover:text-red-500">Blog</a>
        <a href="<%= request.getContextPath() %>/#contact-section" class="px-4 py-2 rounded-full transition hover:bg-white hover:text-red-500">Contact</a>
      </nav>

      <!-- Sign In / Avatar -->
      <div>
        <% if (currentUser == null) { %>
        <a href="<%= request.getContextPath() %>/login"
           class="px-16 py-2 bg-[#FFD580] text-[#A94400] text-lg tracking-wide font-semibold border border-[#FFA500] rounded-full
                    hover:bg-[#FFB347] hover:text-white hover:border-[#FF8C00] transition duration-200 shadow-md">
          Sign In
        </a>
        <% } else { %>
        <div class="relative ml-2">
          <button id="avatarBtn"
                  class="w-16 h-16 rounded-full bg-yellow-300 border-4 border-white shadow-md overflow-hidden
                           focus:outline-none transform hover:scale-105 transition duration-200">
            <img src="/images/avt/crocodile.png" alt="User Avatar" class="w-full h-full object-cover" />
          </button>
          <div id="avatarMenu"
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
  </div>

  <!-- ===================================================================== -->
  <!-- === SCRIPT ĐÃ ĐƯỢC DI CHUYỂN VÀO ĐÂY VÀ CẢI TIẾN LOGIC === -->
  <!-- ===================================================================== -->
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      // Logic cho dropdown avatar
      const btn  = document.getElementById('avatarBtn');
      const menu = document.getElementById('avatarMenu');
      if (btn && menu) {
        btn.addEventListener('click', e => {
          e.stopPropagation();
          menu.classList.toggle('opacity-0');
          menu.classList.toggle('pointer-events-none');
        });

        document.addEventListener('click', e => {
          if (menu.classList.contains('pointer-events-none')) return;
          if (!btn.contains(e.target) && !menu.contains(e.target)) {
            menu.classList.add('opacity-0','pointer-events-none');
          }
        });
      }

      // Logic để tô đậm link active
      const currentPagePath = window.location.pathname; // Lấy đường dẫn trang, ví dụ: "/resources"
      const navLinks = document.querySelectorAll('#main-nav a');

      navLinks.forEach(link => {
        const linkPath = link.getAttribute('href');

        // So sánh chính xác đường dẫn
        // Trường hợp đặc biệt cho trang chủ
        if ((currentPagePath === '/' || currentPagePath.startsWith('/index')) && linkPath === '/') {
          setActive(link);
        } else if (linkPath !== '/' && currentPagePath.startsWith(linkPath)) {
          // Các trang khác
          setActive(link);
        }
      });

      function setActive(activeLink) {
        activeLink.classList.remove('hover:bg-white', 'hover:text-red-500');
        activeLink.classList.add('bg-white', 'text-red-500', 'font-semibold');
      }
    });
  </script>
</header>