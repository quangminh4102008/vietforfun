<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="now" class="java.util.Date" />
<c:set var="sevenDaysInMillis" value="${7 * 24 * 60 * 60 * 1000}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vietforyou - Learning Resources</title>
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
            font-family: 'Fredoka', sans-serif; background-color: #FFF9F0; }
        .resource-card { transition: transform 0.3s ease, box-shadow 0.3s ease; border: 2px solid transparent; }
        .resource-card:hover { transform: translateY(-8px); box-shadow: 0 12px 24px rgba(249, 115, 22, 0.2); border-color: #FBBF24; }
        .type-icon-container { width: 80px; height: 80px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: -40px auto 1rem; position: relative; background-color: white; border: 4px solid #FFF9F0; }
        .type-icon-container i { font-size: 2.5rem; }
        .btn-action { padding: 0.5rem 1rem; border-radius: 9999px; font-weight: bold; transition: all 0.2s ease; display: block; font-size: 0.875rem; }
        .btn-action:hover { transform: scale(1.05); }
        .btn-download { background-color: #FB923C; color: white; }
        .btn-view { background-color: #FBBF24; color: #422006; }
        .new-badge { position: absolute; top: 10px; right: 10px; background-color: #ef4444; color: white; padding: 3px 10px; border-radius: 9999px; font-size: 0.75rem; font-weight: bold; z-index: 10; animation: pulse-animation 1.5s infinite; }
        @keyframes pulse-animation { 0% { transform: scale(1); } 50% { transform: scale(1.1); } 100% { transform: scale(1); } }
    </style>
</head>
<body class="min-h-screen flex flex-col">

<%@ include file="/includes/header.jsp" %>

<main class="container mx-auto px-4 py-12 flex-grow">
    <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-orange-500">Resource Hub</h1>
        <p class="text-gray-600 mt-2">Discover our collection of helpful learning materials!</p>
    </div>
    <div class="flex flex-col md:flex-row md:items-center md:justify-center mb-8">
        <div class="w-full lg:w-3/4 flex flex-col sm:flex-row bg-white p-4 rounded-full shadow-md border-2 border-orange-100 space-y-4 sm:space-y-0 sm:space-x-4">
            <div class="relative flex-1">
                <select id="typeFilter" class="w-full bg-transparent rounded-full pl-4 pr-10 py-2 font-semibold text-orange-800 focus:outline-none">
                    <option value="">All Types</option>
                    <option value="pdf">PDF</option>
                    <option value="video">Video</option>
                    <option value="audio">Audio</option>
                    <option value="website">Website</option>
                </select>
                <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-orange-400"><i class="fas fa-chevron-down"></i></div>
            </div>
            <div class="relative flex-1">
                <input id="searchInput" type="text" placeholder="Search by name..." class="w-full bg-transparent rounded-full pl-4 pr-10 py-2 font-semibold text-orange-800 focus:outline-none" />
                <div class="absolute inset-y-0 right-0 flex items-center pr-3 text-orange-400"><i class="fas fa-search"></i></div>
            </div>
        </div>
    </div>

    <div id="resourceGrid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
        <c:forEach var="resource" items="${resourceList}">
            <div class="resource-card relative bg-white rounded-2xl shadow-lg flex flex-col" data-title="${fn:toLowerCase(resource.title)}" data-type="${fn:toLowerCase(resource.type)}">

                <c:if test="${resource.uploadedAt != null && (now.time - resource.uploadedAt.time) < sevenDaysInMillis}">
                    <span class="new-badge">New!</span>
                </c:if>

                <div>
                    <c:choose>
                        <c:when test="${fn:toLowerCase(resource.type) eq 'pdf'}"><div class="h-24 bg-gradient-to-r from-red-400 to-red-500 rounded-t-2xl"></div></c:when>
                        <c:when test="${fn:toLowerCase(resource.type) eq 'video'}"><div class="h-24 bg-gradient-to-r from-blue-400 to-blue-500 rounded-t-2xl"></div></c:when>
                        <c:when test="${fn:toLowerCase(resource.type) eq 'audio'}"><div class="h-24 bg-gradient-to-r from-green-400 to-green-500 rounded-t-2xl"></div></c:when>
                        <c:otherwise><div class="h-24 bg-gradient-to-r from-purple-400 to-purple-500 rounded-t-2xl"></div></c:otherwise>
                    </c:choose>
                </div>

                <div class="type-icon-container shadow-md">
                    <c:choose>
                        <c:when test="${fn:toLowerCase(resource.type) eq 'pdf'}"><i class="fas fa-file-pdf text-red-500"></i></c:when>
                        <c:when test="${fn:toLowerCase(resource.type) eq 'video'}"><i class="fas fa-video text-blue-500"></i></c:when>
                        <c:when test="${fn:toLowerCase(resource.type) eq 'audio'}"><i class="fas fa-volume-up text-green-500"></i></c:when>
                        <c:otherwise><i class="fas fa-globe text-purple-500"></i></c:otherwise>
                    </c:choose>
                </div>

                <div class="p-5 pt-0 text-center flex flex-col flex-grow">
                    <div class="flex-grow">
                        <h3 class="text-lg font-bold text-gray-800 mb-2 flex items-center justify-center min-h-[56px]">
                            <a href="resources?id=${resource.id}" class="hover:text-orange-500 transition-colors">
                                    ${resource.title}
                            </a>
                        </h3>
                        <p class="text-gray-500 text-sm mb-4">
                                ${resource.description}
                        </p>
                    </div>

                    <div class="mt-auto">
                        <c:choose>
                            <c:when test="${fn:toLowerCase(resource.type) eq 'pdf'}">
                                <a href="${resource.url}" download class="btn-action btn-download"><i class="fas fa-download mr-1"></i> Download</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${resource.url}" target="_blank" class="btn-action btn-view"><i class="fas fa-external-link-alt mr-1"></i> View Now</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div id="noResultsMessage" class="hidden text-center py-16">
        <i class="fas fa-ghost fa-3x text-orange-300 mb-4"></i>
        <h3 class="text-2xl font-semibold text-orange-500">Oops, Nothing Found!</h3>
        <p class="text-gray-500 mt-2">Please try again with a different filter or keyword.</p>
    </div>
</main>

<%@ include file="/includes/footer.jsp" %>
<script>document.addEventListener("DOMContentLoaded",function(){const e=document.getElementById("searchInput"),t=document.getElementById("typeFilter"),n=document.querySelectorAll(".resource-card"),o=document.getElementById("noResultsMessage");function c(){const c=e.value.toLowerCase().trim(),l=t.value.toLowerCase();let a=0;n.forEach(e=>{const t=e.dataset.title,n=e.dataset.type,s=(""===c||t.includes(c))&&(""===l||n===s);s?(e.style.display="block",a++):e.style.display="none"}),o.style.display=0===a?"block":"none"}e.addEventListener("input",c),t.addEventListener("change",c)});</script>
</body>
</html>