<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${post.title} - VietJoy Blog</title>
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body{
            transform: scale(0.8);
            transform-origin: top left;
            width: 125%;
            height: 125%;
        }
        /* Thêm style cho nội dung bài viết để hiển thị đẹp hơn */
        .post-content h2 {
            font-size: 1.875rem; /* text-3xl */
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 1rem;
        }
        .post-content p {
            font-size: 1.125rem; /* text-lg */
            line-height: 1.75;
            margin-bottom: 1.5rem;
        }
        .post-content ul {
            list-style-type: disc;
            margin-left: 2rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body class="bg-white">

<!-- Header -->
<%@ include file="/includes/header.jsp" %>

<main class="py-12">
    <div class="container mx-auto px-4 max-w-4xl">

        <c:if test="${not empty post}">
            <article>
                <!-- Category -->
                <span class="text-sm font-semibold text-red-700 bg-red-100 px-3 py-1 rounded-full">${post.category}</span>

                <!-- Title -->
                <h1 class="text-4xl md:text-5xl font-bold text-gray-800 my-4">${post.title}</h1>

                <!-- Main Image -->
                <img src="${post.imageUrl}" alt="${post.title}" class="w-full h-auto rounded-2xl shadow-lg my-8">

                <!-- Post Content -->
                <div class="post-content text-gray-700">
                    <c:out value="${post.content}" escapeXml="false" />
                </div>
            </article>
        </c:if>

        <c:if test="${empty post}">
            <div class="text-center py-20">
                <h1 class="text-4xl font-bold">404 - Post Not Found</h1>
                <p class="text-lg mt-4">Sorry, we couldn't find the post you were looking for.</p>
                <a href="${pageContext.request.contextPath}/blog" class="mt-8 inline-block bg-red-500 text-white px-6 py-3 rounded-full font-semibold">Back to Blog</a>
            </div>
        </c:if>

    </div>
</main>

<!-- Footer -->
<%@ include file="/includes/footer.jsp" %>

</body>
</html>