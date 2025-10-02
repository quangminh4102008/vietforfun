<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>VietJoy Blog - Your Guide to Vietnamese</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="text-gray-800 bg-gray-50">

<!-- Header -->
<%@ include file="/includes/header.jsp" %>

<main>
  <!-- Blog Hero Section -->
  <section class="bg-yellow-50 py-12">
    <div class="container mx-auto px-4 text-center">
      <h1 class="text-4xl md:text-5xl font-bold text-red-500 mb-3">VietJoy's Blog</h1>
      <p class="text-lg text-gray-600">Your friendly guide to the Vietnamese language and culture.</p>
    </div>
  </section>

  <!-- Blog Posts Grid -->
  <section class="py-16">
    <div class="container mx-auto px-4">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">

        <!-- Vòng lặp bắt đầu -->
        <c:forEach var="post" items="${blogPosts}">
          <div class="bg-white rounded-2xl shadow-lg overflow-hidden flex flex-col transition duration-300 card-hover">
            <img src="${post.imageUrl}" alt="${post.title}" class="w-full h-48 object-cover">
            <div class="p-6 flex-grow flex flex-col">
              <div>
                <span class="text-sm font-semibold text-blue-700 bg-blue-100 px-3 py-1 rounded-full">${post.category}</span>
              </div>
              <h3 class="text-xl font-bold mt-3 mb-2 text-gray-800">${post.title}</h3>
              <p class="text-gray-600 flex-grow mb-4">${post.description}</p>

              <!-- === DÒNG QUAN TRỌNG ĐÃ ĐƯỢC SỬA LẠI CHÍNH XÁC === -->
              <a href="${pageContext.request.contextPath}/blog/${post.slug}" class="mt-auto self-start bg-red-500 text-white px-5 py-2 rounded-full font-semibold hover:bg-red-600 transition">Read More</a>

            </div>
          </div>
        </c:forEach>
        <!-- Vòng lặp kết thúc -->

      </div>
    </div>
  </section>
</main>