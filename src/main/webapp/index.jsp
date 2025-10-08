<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VietForYou - Learn Vietnamese with a Smile!</title>
    <!-- ... (các thẻ link và script khác) ... -->

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        html {
            scroll-behavior: smooth;
        }

        /* === ĐÃ CẬP NHẬT ĐỂ DÙNG 'zoom' THAY VÌ 'transform: scale()' === */
        body {
            /* Dùng 'zoom' để thu nhỏ trang mà không làm hỏng bố cục */
            zoom: 80%;
            /* Đảm bảo chiều cao tối thiểu 100vh để footer không bị tràn lên khi nội dung ngắn */
            min-height: 100vh;

            font-family: 'Fredoka', sans-serif;
            background-color: #FFF9F0;
        }

        .bounce:hover {
            animation: bounce 0.5s;
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }
        .wiggle:hover {
            animation: wiggle 0.5s ease-in-out;
        }
        @keyframes wiggle {
            0%, 100% { transform: rotate(0deg); }
            25% { transform: rotate(3deg); }
            75% { transform: rotate(-3deg); }
        }
        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
    </style>
</head>
<body class="text-gray-800">
<!-- ... Phần còn lại của nội dung HTML ... -->
<!-- Header -->
<%@ include file="/includes/header.jsp" %>
<!-- Hero Section -->
<!-- ... Nội dung các sections ... -->
<!-- Contact Section -->
<section id="contact-section" class="py-16 bg-white">
    <!-- ... Nội dung contact ... -->
</section>

<!-- Footer -->
<%@ include file="/includes/footer.jsp" %>

<script>
    // ... (Script) ...
</script>

</body>
</html>