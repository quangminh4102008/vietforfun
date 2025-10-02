<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>VietJoy - ${resource.title}</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'Fredoka', sans-serif; background-color: #FFF9F0; }
    .content-area h2 { font-size: 1.8rem; font-weight: bold; color: #333; margin-top: 2rem; margin-bottom: 1rem; }
    .content-area h3 { font-size: 1.5rem; font-weight: bold; color: #444; margin-top: 1.5rem; margin-bottom: 0.75rem; }
    .content-area p { margin-bottom: 1rem; line-height: 1.7; color: #555; }
    .content-area ul { list-style-type: disc; margin-left: 2rem; margin-bottom: 1rem; }
    .content-area li { margin-bottom: 0.5rem; }
    .content-area a { color: #f97316; text-decoration: underline; }
  </style>
</head>
<body class="min-h-screen flex flex-col">

<%@ include file="/includes/header.jsp" %>

<main class="container mx-auto px-4 py-12 flex-grow">
  <c:if test="${not empty resource}">
    <div class="max-w-4xl mx-auto bg-white rounded-2xl shadow-xl overflow-hidden p-8">
      <div class="mb-6">
        <a href="resources" class="text-orange-500 font-semibold hover:text-orange-600">
          <i class="fas fa-arrow-left mr-2"></i> Back to Resource Hub
        </a>
      </div>

      <h1 class="text-4xl font-bold text-gray-800">${resource.title}</h1>
      <p class="text-gray-500 mt-2 mb-6">${resource.description}</p>

      <c:if test="${not empty resource.imageUrl}">
        <img src="${resource.imageUrl}" alt="${resource.title}" class="w-full h-auto object-cover rounded-lg shadow-md mb-8">
      </c:if>

      <div class="content-area">
        <c:out value="${resource.content}" escapeXml="false"/>
      </div>

      <div class="mt-12 text-center">
        <a href="${resource.url}"
           class="inline-block bg-orange-500 hover:bg-orange-600 text-white font-bold py-3 px-8 rounded-full text-lg transition-transform hover:scale-105"
           <c:if test="${fn:toLowerCase(resource.type) eq 'pdf'}">download</c:if>
           <c:if test="${fn:toLowerCase(resource.type) ne 'pdf'}">target="_blank"</c:if>
        >
          <c:choose>
            <c:when test="${fn:toLowerCase(resource.type) eq 'pdf'}"><i class="fas fa-download mr-2"></i> Download Document</c:when>
            <c:when test="${fn:toLowerCase(resource.type) eq 'video'}"><i class="fas fa-play-circle mr-2"></i> Watch Video</c:when>
            <c:when test="${fn:toLowerCase(resource.type) eq 'audio'}"><i class="fas fa-volume-up mr-2"></i> Listen to Audio</c:when>
            <c:when test="${fn:toLowerCase(resource.type) eq 'website'}"><i class="fas fa-external-link-alt mr-2"></i> Visit Website</c:when>
          </c:choose>
        </a>
      </div>
    </div>
  </c:if>
  <c:if test="${empty resource}">
    <div class="text-center py-16">
      <h1 class="text-4xl font-bold text-red-500">404 - Not Found</h1>
      <p class="text-gray-600 mt-4">The resource you are looking for does not exist or has been removed.</p>
    </div>
  </c:if>
</main>

<%@ include file="/includes/footer.jsp" %>
</body>
</html>