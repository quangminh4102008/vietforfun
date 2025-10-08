<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VietForYou - Learn Vietnamese with a Smile!</title>
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        html {
            scroll-behavior: smooth;
        }
        body {
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
<!-- Header -->
<%@ include file="/includes/header.jsp" %>

<!-- Hero Section -->
<section class="bg-gradient-to-r from-yellow-300 to-red-400 py-16">
    <div class="container mx-auto px-4 flex flex-col md:flex-row items-center">
        <div class="md:w-1/2 mb-10 md:mb-0">
            <h2 class="text-4xl md:text-5xl font-bold text-white mb-6">Learn Vietnamese with a Smile!  😊</h2>
            <p class="text-xl text-white mb-8">Our fun, friendly lessons make learning Vietnamese feel like playtime! Whether you're overseas Vietnamese or just love our culture, we'll have you speaking in no time!</p>

            <!-- === CÁC NÚT ĐÃ ĐƯỢC SỬA === -->
            <div class="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
                <a href="/courses" class="bg-white text-red-500 px-8 py-3 rounded-full font-bold text-lg shadow-lg hover:bg-red-500 hover:text-white transition bounce">Start Learning</a>
                <a href="/resources" class="bg-green-500 text-white px-8 py-3 rounded-full font-bold text-lg shadow-lg hover:bg-green-600 transition bounce">Explore Resources</a>
            </div>

        </div>
        <div class="md:w-1/2 flex justify-center">
            <div class="relative w-64 h-64 md:w-80 md:h-80 rounded-full overflow-hidden border-8 border-yellow-300 shadow-lg">
                <div class="absolute inset-0 bg-yellow-200 rounded-full"></div>
                <img src="/images/iconiclogo.jpg" alt="Happy student learning Vietnamese" class="absolute w-full h-full object-cover rounded-full border-4 border-white shadow-lg wiggle">
            </div>
        </div>
    </div>
</section>

<!-- Why Section -->
<section class="py-16 bg-white">
    <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center mb-12 text-red-500">Why Learn With VietForYou? </h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- Card 1 -->
            <div class="bg-yellow-50 p-6 rounded-2xl shadow-md transition duration-300 card-hover">
                <div class="bg-red-400 text-white w-16 h-16 rounded-full flex items-center justify-center mb-4 mx-auto">
                    <i class="fas fa-heart text-2xl"></i>
                </div>
                <h3 class="text-xl font-bold text-center mb-3 text-red-500">Preserve Our Language</h3>
                <p class="text-center">Keep Vietnamese alive in your family! Our lessons help overseas Vietnamese stay connected to their roots through language and culture.</p>
            </div>
            <!-- Card 2 -->
            <div class="bg-green-50 p-6 rounded-2xl shadow-md transition duration-300 card-hover">
                <div class="bg-green-400 text-white w-16 h-16 rounded-full flex items-center justify-center mb-4 mx-auto">
                    <i class="fas fa-mobile-alt text-2xl"></i>
                </div>
                <h3 class="text-xl font-bold text-center mb-3 text-green-600">Learn Anywhere</h3>
                <p class="text-center">5 minutes or 50 minutes - learn at your pace! Our mobile-friendly platform fits into your busy schedule wherever you are.</p>
            </div>
            <!-- Card 3 -->
            <div class="bg-blue-50 p-6 rounded-2xl shadow-md transition duration-300 card-hover">
                <div class="bg-blue-400 text-white w-16 h-16 rounded-full flex items-center justify-center mb-4 mx-auto">
                    <i class="fas fa-users text-2xl"></i>
                </div>
                <h3 class="text-xl font-bold text-center mb-3 text-blue-500">Friendly Community</h3>
                <p class="text-center">You're never alone! Join our supportive community of learners who cheer each other on. Mistakes are just part of the fun!</p>
            </div>
        </div>
    </div>
</section>

<!-- Services Section -->
<section class="py-16 bg-yellow-50">
    <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center mb-12 text-red-500">What We Offer 📚</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- Service 1: Fun Courses -->
            <div class="bg-white p-6 rounded-2xl shadow-lg flex flex-col items-center text-center transition duration-300 hover:shadow-xl card-hover">
                <div class="bg-yellow-400 text-white w-20 h-20 rounded-full flex items-center justify-center mb-4">
                    <i class="fas fa-graduation-cap text-3xl"></i>
                </div>
                <h3 class="text-xl font-bold mb-3 text-red-500">Fun Courses</h3>
                <p class="mb-4">From "Xin chào" to fluent conversations, our bite-sized lessons make learning feel like a game!</p>
                <a href="/courses" class="mt-auto text-yellow-500 font-semibold hover:text-yellow-600 flex items-center">
                    See courses <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>

            <!-- Service 2: Free Resources -->
            <div class="bg-white p-6 rounded-2xl shadow-lg flex flex-col items-center text-center transition duration-300 hover:shadow-xl card-hover">
                <div class="bg-green-400 text-white w-20 h-20 rounded-full flex items-center justify-center mb-4">
                    <i class="fas fa-book-open text-3xl"></i>
                </div>
                <h3 class="text-xl font-bold mb-3 text-green-600">Free Resources</h3>
                <p class="mb-4">Flashcards, worksheets, audio clips - all designed to make Vietnamese stick in your memory!</p>
                <a href="/resources" class="mt-auto text-green-500 font-semibold hover:text-green-600 flex items-center">
                    Explore resources <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>

            <!-- Service 3: Chat with Zest (Chatbot) -->
            <div class="bg-white p-6 rounded-2xl shadow-lg flex flex-col items-center text-center transition duration-300 hover:shadow-xl card-hover">
                <div class="bg-blue-400 text-white w-20 h-20 rounded-full flex items-center justify-center mb-4">
                    <i class="fas fa-comments text-3xl"></i>
                </div>
                <h3 class="text-xl font-bold mb-3 text-blue-500">Chat with Zest</h3>
                <p class="mb-4">Have a question? Our friendly AI assistant, Zest, is here 24/7 to help you with anything about VietForYou!</p>
                <a href="/chatbot" class="mt-auto text-blue-500 font-semibold hover:text-blue-600 flex items-center">
                    Start Chatting <i class="fas fa-arrow-right ml-2"></i>
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Contact Section -->
<!-- === LỖI CÚ PHÁP ĐÃ ĐƯỢC SỬA === -->
<section id="contact-section" class="py-16 bg-white">
    <div class="container mx-auto px-4">
        <h2 class="text-3xl font-bold text-center mb-12 text-red-500">Say Hello!  💌</h2>
        <div class="flex flex-col md:flex-row gap-12">
            <div class="md:w-1/2">
                <div class="bg-yellow-100 p-8 rounded-2xl shadow-md">
                    <div class="bg-red-400 text-white w-16 h-16 rounded-full flex items-center justify-center mb-6 mx-auto">
                        <i class="fas fa-envelope text-2xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-center mb-6 text-red-500">We'd love to hear from you!</h3>
                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="bg-yellow-400 text-white rounded-full w-10 h-10 flex items-center justify-center mr-4">
                                <i class="fas fa-user"></i>
                            </div>
                            <div>
                                <h4 class="font-bold">Founder</h4>
                                <p>Minh Quang Trương </p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="bg-green-400 text-white rounded-full w-10 h-10 flex items-center justify-center mr-4">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div>
                                <h4 class="font-bold">Email</h4>
                                <p>bi066109@gmail.com</p>
                            </div>
                        </div>
                        <div class="flex items-start">
                            <div class="bg-blue-400 text-white rounded-full w-10 h-10 flex items-center justify-center mr-4">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div>
                                <h4 class="font-bold">Phone</h4>
                                <p>+84 (329) 499-444</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="md:w-1/2">
                <form class="bg-yellow-50 p-8 rounded-2xl shadow-md">
                    <div class="mb-6">
                        <label class="block text-gray-700 mb-2 font-semibold" for="name">Your Name</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-yellow-500"></i>
                            </div>
                            <input type="text" id="name" class="pl-10 w-full px-4 py-3 rounded-full border border-yellow-300 focus:outline-none focus:ring-2 focus:ring-yellow-400" placeholder="What should we call you?">
                        </div>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 mb-2 font-semibold" for="email">Email Address</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-envelope text-yellow-500"></i>
                            </div>
                            <input type="email" id="email" class="pl-10 w-full px-4 py-3 rounded-full border border-yellow-300 focus:outline-none focus:ring-2 focus:ring-yellow-400" placeholder="Your email">
                        </div>
                    </div>
                    <div class="mb-6">
                        <label class="block text-gray-700 mb-2 font-semibold" for="message">Your Message</label>
                        <div class="relative">
                            <div class="absolute top-3 left-3 pl-1 flex items-start pointer-events-none">
                                <i class="fas fa-comment-dots text-yellow-500"></i>
                            </div>
                            <textarea id="message" rows="4" class="pl-10 w-full px-4 py-3 rounded-2xl border border-yellow-300 focus:outline-none focus:ring-2 focus:ring-yellow-400" placeholder="What would you like to tell us?"></textarea>
                        </div>
                    </div>
                    <button type="submit" class="w-full bg-red-500 text-white py-3 px-6 rounded-full font-bold hover:bg-red-600 transition bounce">
                        Send Message <i class="fas fa-paper-plane ml-2"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<%@ include file="/includes/footer.jsp" %>

<script>
    // Simple animation for buttons on page load
    const animatedElements = document.querySelectorAll('button, a.btn'); // Target specific buttons/links if needed
    animatedElements.forEach((el, index) => {
        setTimeout(() => {
            // Check if 'animate.css' is being used or add a custom animation class
            // For this example, let's assume a custom fadeIn class is available
            // el.classList.add('animate__animated', 'animate__fadeInUp');
        }, index * 100);
    });
</script>

</body>
</html>