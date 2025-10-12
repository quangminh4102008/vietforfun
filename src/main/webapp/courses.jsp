<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vietforyou - Courses</title>
  <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
  <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      zoom: 80%;
      /* Đảm bảo chiều cao tối thiểu 100vh để footer không bị tràn lên khi nội dung ngắn */
      min-height: 100vh;
      overflow-x: hidden;
      font-family: 'Fredoka', sans-serif;
      background-color: #fff9f0;
    }
    .course-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }
    .level-badge {
      font-size: 0.75rem;
      padding: 0.25rem 0.75rem;
      border-radius: 9999px;
    }
  </style>
</head>
<body class="min-h-screen flex flex-col">

<%@ include file="/includes/header.jsp" %>

<main class="container mx-auto px-4 py-12 flex-grow">
  <!-- Filters -->
  <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6">
    <h2 class="text-3xl font-bold text-red-600 mb-4 md:mb-0">Our Courses</h2>
    <div class="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
      <div class="relative">
        <select id="levelFilter" class="appearance-none bg-white border-2 border-yellow-300 rounded-full pl-4 pr-10 py-2 font-medium text-gray-700 focus:outline-none focus:border-yellow-400 w-full">
          <option value="">All Levels</option>
          <option value="beginner">Beginner</option>
          <option value="intermediate">Intermediate</option>
          <option value="advanced">Advanced</option>
        </select>
        <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
          <i class="fas fa-chevron-down text-yellow-500"></i>
        </div>
      </div>
      <div class="relative flex-grow">
        <input id="searchInput" type="text" placeholder="Search courses..." class="search-input bg-white border-2 border-yellow-300 rounded-full pl-4 pr-10 py-2 font-medium text-gray-700 focus:outline-none focus:border-yellow-400 w-full">
        <div class="absolute inset-y-0 right-0 flex items-center pr-3">
          <i class="fas fa-search text-yellow-500"></i>
        </div>
      </div>
    </div>
  </div>
  <!-- Courses Grid -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
    <c:forEach var="course" items="${courseList}">
      <div class="course-card bg-white rounded-2xl overflow-hidden shadow-lg transition duration-300 hover:shadow-xl"
           data-title="${fn:toLowerCase(course.title)}"
           data-description="${fn:toLowerCase(course.description)}"
           data-level="${fn:toLowerCase(course.level)}">

        <div class="h-40 w-full bg-gradient-to-r from-red-400 to-yellow-400 relative overflow-hidden rounded-t-2xl">
          <c:choose>
            <c:when test="${not empty course.thumbnailUrl}">
              <div class="absolute inset-0 bg-cover bg-center" style="background-image: url('${course.thumbnailUrl}');"></div>
            </c:when>
            <c:otherwise>
              <div class="flex justify-center items-center h-full">
                <i class="fas fa-book-open text-white text-6xl"></i>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="p-6">
          <div class="flex justify-between items-start mb-2">
            <h3 class="text-xl font-bold text-gray-800">${course.title}</h3>
              <%-- Cập nhật logic màu sắc cho badge cấp độ --%>
            <span class="level-badge font-bold
              <c:choose>
                <c:when test="${fn:toLowerCase(course.level) eq 'beginner'}">bg-green-100 text-green-800</c:when>
                <c:when test="${fn:toLowerCase(course.level) eq 'intermediate'}">bg-yellow-100 text-yellow-800</c:when>
                <c:when test="${fn:toLowerCase(course.level) eq 'advanced'}">bg-red-100 text-red-800</c:when>
                <c:otherwise>bg-gray-100 text-gray-800</c:otherwise> <%-- Fallback color --%>
              </c:choose>
            ">${course.level}</span>
          </div>
          <p class="text-gray-600 mb-4">${course.description}</p>
            <%-- BƯỚC 1: SỬA NÚT BẤM "START NOW" --%>
          <c:choose>
            <%-- Trường hợp 1: Người dùng ĐÃ đăng nhập (sessionScope.user không rỗng) --%>
            <c:when test="${not empty sessionScope.user}">
              <a href="quiz?courseId=${course.id}" class="w-full bg-red-500 hover:bg-red-600 text-white py-2 rounded-full font-bold transition block text-center">
                Start Now <i class="fas fa-arrow-right ml-2"></i>
              </a>
            </c:when>

            <%-- Trường hợp 2: Người dùng CHƯA đăng nhập --%>
            <c:otherwise>
              <a href="/login" class="w-full bg-gray-400 hover:bg-gray-500 text-white py-2 rounded-full font-bold transition block text-center">
                Sign in to start <i class="fas fa-sign-in-alt ml-2"></i>
              </a>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </c:forEach>
  </div>
</main>

<%@ include file="/includes/footer.jsp" %>

<!-- Filter Script -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Logic tô sáng link navigation bar
    document.addEventListener('DOMContentLoaded', function() {
      const currentPageURL = window.location.href;
      const navLinks = document.querySelectorAll('#main-nav a'); // Đảm bảo ID 'main-nav' tồn tại trên thẻ cha của các link navigation

      navLinks.forEach(link => {
        if (currentPageURL === link.href) {
          link.classList.remove('hover:bg-white', 'hover:text-red-500');
          link.classList.add('bg-white', 'text-red-500', 'font-semibold');
        }
      });
    });

    // Logic lọc và tìm kiếm khóa học
    const searchInput = document.getElementById("searchInput");
    const levelFilter = document.getElementById("levelFilter");
    const courseCards = document.querySelectorAll(".course-card");

    function filterCourses() {
      const searchTerm = searchInput.value.toLowerCase();
      const selectedLevel = levelFilter.value.toLowerCase();

      courseCards.forEach(card => {
        const title = card.dataset.title;
        const desc = card.dataset.description;
        const level = card.dataset.level;

        const matchSearch = title.includes(searchTerm) || desc.includes(searchTerm);
        const matchLevel = !selectedLevel || level === selectedLevel;

        card.style.display = (matchSearch && matchLevel) ? "block" : "none";
      });
    }

    searchInput.addEventListener("input", filterCourses);
    levelFilter.addEventListener("change", filterCourses);
  });
</script>

</body>
</html>