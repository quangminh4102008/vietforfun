<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List, com.tiengviet.entity.Question, com.google.gson.Gson" %>
<%@ page import="com.google.gson.GsonBuilder" %>

<%
    // This scriptlet gets the list of questions from the request and converts it to a JSON string.
    // This allows the questions data to be easily used by the JavaScript code on the client side.
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    Gson gson = new GsonBuilder().serializeNulls().create();
    String questionsJson = gson.toJson(questions);
%>

<%-- Lấy đường dẫn gốc của ứng dụng để đảm bảo URL tài nguyên luôn đúng --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

    <title>Quiz: <c:out value="${course.title}" default="Playful Quiz"/></title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@700;800;900&display=swap" rel="stylesheet">
    <style>
        /* CSS Variables for a consistent theme */
        :root {
            --primary-orange: #FF9800;
            --primary-orange-dark: #F57C00;
            --light-yellow: #FFF3E0;
            --background-cream: #FFFAF0;
            --red: #EA2B2B;
            --green-correct: #28A745;
            --green-light: #D4EDDA;
            --red-wrong: #DC3545;
            --red-light: #F8D7DA;
            --gray-light: #E0E0E0;
            --gray-medium: #757575;
            --text-dark: #5D4037;
            --white: #FFFFFF;
        }

        /* Base Styles */
        body {
            transform: scale(0.8);
            transform-origin: top left;
            width: 125%;
            height: 125%;
            margin: 0;
            font-family: 'Nunito', sans-serif;
            background-color: var(--background-cream);
            color: var(--text-dark);
        }

        /* Page Layout */
        .quiz-page, .error-page {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding: 20px;
            box-sizing: border-box;
        }

        /* Error Page Specific Styles */
        .error-page {
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .error-message {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .btn-return {
            display: inline-block;
            padding: 12px 25px;
            background-color: var(--primary-orange);
            color: var(--white);
            text-decoration: none;
            border-radius: 12px;
            font-weight: 700;
        }

        /* Quiz Header */
        .quiz-header {
            padding: 20px 0;
            display: flex;
            align-items: center;
            gap: 15px;
            width: 100%;
        }

        .btn-back {
            font-size: 24px;
            font-weight: 800;
            color: var(--gray-medium);
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 50%;
            transition: background-color 0.2s;
        }

        .btn-back:hover {
            background-color: var(--gray-light);
        }

        .progress-container {
            flex-grow: 1;
            height: 20px;
            background-color: var(--light-yellow);
            border-radius: 10px;
            border: 2px solid #FADCB3;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #FFB74D, var(--primary-orange));
            width: 0%;
            border-radius: 8px;
            transition: width 0.4s ease;
        }

        .hearts {
            font-size: 24px;
            color: var(--red);
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        /* Quiz Body - Main Content */
        .quiz-body {
            flex-grow: 1;
            padding: 20px 0;
            text-align: center;
        }

        /* Course Info Header */
        .course-info-header {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .question-title {
            font-size: 32px;
            font-weight: 900;
            color: var(--primary-orange-dark);
            margin: 0;
        }

        .level-badge {
            font-size: 1rem;
            padding: 0.4rem 1rem;
            border-radius: 9999px;
            font-weight: 700;
            background-color: var(--green-light);
            color: var(--green-correct);
            text-transform: capitalize;
        }

        /* Question Display */
        .question-display {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            margin-bottom: 20px;
            min-height: 50px;
        }

        .question-icon {
            font-size: 40px;
        }

        .question-text {
            font-size: 36px;
            font-weight: 800;
            color: var(--text-dark);
        }

        /* === IMPROVED "PLAYFUL" IMAGE STYLES === */
        .question-image-container {
            background-color: var(--white);
            border: 4px solid var(--light-yellow);
            border-bottom-width: 10px;
            border-radius: 30px;
            padding: 15px;
            box-shadow: 0 10px 20px rgba(93, 64, 55, 0.1);
            display: inline-block;
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }

        .question-image-container:hover {
            transform: scale(1.05) rotate(2deg);
            cursor: pointer;
        }

        .question-image {
            display: block;
            max-width: 100%;
            max-height: 250px;
            border-radius: 18px;
        }

        @keyframes imageZoomIn {
            from { opacity: 0; transform: scale(0.6); }
            to { opacity: 1; transform: scale(1); }
        }

        .animate-image {
            animation: imageZoomIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
        }

        /* === Custom Audio Player Styles === */
        .audio-player-container {
            margin-bottom: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .custom-audio-player {
            display: flex;
            align-items: center;
            gap: 20px;
            background-color: var(--white);
            padding: 15px 30px;
            border-radius: 50px;
            border: 3px solid var(--light-yellow);
            width: 100%;
            max-width: 450px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .play-pause-btn {
            background-color: var(--primary-orange);
            color: var(--white);
            border: none;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.2s ease;
            flex-shrink: 0;
        }

        .play-pause-btn:hover {
            background-color: var(--primary-orange-dark);
            transform: scale(1.05);
        }

        .play-pause-btn svg {
            width: 32px;
            height: 32px;
            fill: var(--white);
        }

        .audio-progress-container {
            flex-grow: 1;
            height: 12px;
            background-color: var(--light-yellow);
            border-radius: 10px;
            cursor: pointer;
            overflow: hidden;
        }

        .audio-progress-bar {
            height: 100%;
            width: 0%;
            background-color: var(--primary-orange);
            border-radius: 10px;
            transition: width 0.1s linear;
        }

        /* Options Container */
        .options-container {
            max-width: 70%;
            margin: 0 auto;
        }

        .options-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .option-item {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            min-height: 85px;
            padding: 20px;
            font-size: 28px;
            font-weight: 800;
            background: var(--white);
            border: 3px solid var(--light-yellow);
            border-bottom-width: 8px;
            border-radius: 24px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
            color: var(--text-dark);
        }

        .option-item.selected {
            background-color: var(--light-yellow);
            border-color: var(--primary-orange);
        }

        .option-item.correct, .fill-in-blank-input.correct {
            background-color: var(--green-light);
            border-color: var(--green-correct);
            color: var(--green-correct);
        }

        .option-item.wrong, .fill-in-blank-input.wrong {
            background-color: var(--red-light);
            border-color: var(--red-wrong);
            color: var(--red-wrong);
        }

        /* CSS for Fill in the Blank */
        .fill-in-blank-input {
            width: 100%;
            min-height: 85px;
            padding: 20px;
            font-size: 28px;
            font-weight: 800;
            font-family: 'Nunito', sans-serif;
            background: var(--white);
            border: 3px solid var(--light-yellow);
            border-bottom-width: 8px;
            border-radius: 24px;
            text-align: center;
            color: var(--text-dark);
            box-sizing: border-box;
            transition: all 0.2s ease;
        }

        .fill-in-blank-input:focus {
            outline: none;
            border-color: var(--primary-orange);
        }

        .correct-answer-display {
            margin-top: 15px;
            font-size: 20px;
            font-weight: 700;
            color: var(--green-correct);
        }

        /* Quiz Footer */
        .quiz-footer {
            position: sticky;
            bottom: 0;
            padding: 20px 0;
            background-color: var(--background-cream);
            width: 100%;
        }

        .footer-buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn {
            width: 48%;
            padding: 20px;
            font-size: 18px;
            font-weight: 800;
            text-transform: uppercase;
            border-radius: 18px;
            border: none;
            border-bottom-width: 6px;
            border-style: solid;
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .btn-check {
            background-color: var(--primary-orange);
            color: var(--white);
            border-color: var(--primary-orange-dark);
        }

        .btn-skip {
            background-color: var(--gray-light);
            color: var(--gray-medium);
            border-color: #BDBDBD;
        }

        .btn-check:disabled, .btn-skip:disabled {
            background-color: var(--gray-light);
            color: var(--gray-medium);
            border-color: #BDBDBD;
            cursor: not-allowed;
            opacity: 0.7;
        }

        /* === VIBRANT FINAL SCORE STYLES === */
        .final-score-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            animation: fadeIn-animation 0.5s ease-out both;
            position: relative;
            overflow: hidden;
            padding: 20px 0;
        }

        .result-icon {
            font-size: 120px;
            line-height: 1;
            margin-bottom: 20px;
            animation-delay: 0.2s;
        }

        .result-title {
            font-size: 52px;
            font-weight: 900;
            margin: 0 0 15px 0;
            animation-delay: 0.3s;
        }

        .score-display {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .score-value {
            font-size: 64px;
            font-weight: 900;
            color: var(--primary-orange-dark);
            line-height: 1.1;
            animation: score-pop-in 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275) 0.5s both;
        }

        .result-message {
            font-size: 20px;
            color: var(--gray-medium);
            margin: 20px 0 0 0;
            max-width: 80%;
        }

        @keyframes fadeIn-animation {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes score-pop-in {
            from { opacity: 0; transform: scale(0.5); }
            to { opacity: 1; transform: scale(1); }
        }

        .pulse-animation {
            animation: pulse-effect 1.5s infinite;
        }
        @keyframes pulse-effect {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.15); }
        }

        .nod-animation {
            animation: nod-effect 2s infinite ease-in-out;
        }
        @keyframes nod-effect {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .confetti-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .confetti {
            width: 10px;
            height: 20px;
            background-color: #f00;
            position: absolute;
            top: -20px;
            opacity: 0.8;
            animation: confetti-fall linear infinite;
        }

        @keyframes confetti-fall {
            to {
                transform: translateY(120vh) rotate(360deg);
                opacity: 0;
            }
        }

        /* === GAME OVER MODAL STYLES === */
        .hidden {
            display: none !important;
        }

        #modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            z-index: 100;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        #game-over-modal {
            background: var(--white);
            padding: 40px;
            border-radius: 30px;
            border: 4px solid var(--red-light);
            border-bottom-width: 10px;
            text-align: center;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
            animation: bounceIn 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
        }

        .modal-icon {
            font-size: 90px;
            line-height: 1;
            margin-bottom: 15px;
        }

        .modal-title {
            font-size: 36px;
            font-weight: 900;
            color: var(--red-wrong);
            margin: 0 0 10px 0;
        }

        .modal-text {
            font-size: 18px;
            color: var(--gray-medium);
            margin: 0 0 30px 0;
        }

        .modal-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .modal-buttons .btn {
            width: auto;
            flex-grow: 1;
        }

        @keyframes bounceIn {
            from { opacity: 0; transform: scale(0.5); }
            to { opacity: 1; transform: scale(1); }
        }

    </style>
</head>
<body>

<%-- Conditional rendering based on data availability --%>
<c:choose>
    <c:when test="${not empty errorMessage}">
        <div class="error-page">
            <h1 class="error-message"><c:out value="${errorMessage}"/></h1>
            <a href="courses" class="btn-return">Return to Courses</a>
        </div>
    </c:when>

    <c:when test="${empty questions or fn:length(questions) == 0}">
        <div class="error-page">
            <h1 class="error-message">This course doesn't have any questions yet.</h1>
            <a href="courses" class="btn-return">Return to Courses</a>
        </div>
    </c:when>

    <c:otherwise>
        <div class="quiz-page">
            <header class="quiz-header">
                <a href="courses" class="btn-back" title="Return to courses">×</a>
                <div class="progress-container">
                    <div class="progress-bar" id="progress-bar"></div>
                </div>
                <div class="hearts">❤️<span id="hearts-count">5</span></div>
            </header>

            <main class="quiz-body">
                <div class="course-info-header">
                    <h1 class="question-title">${course.title}</h1>
                    <span class="level-badge">${course.level}</span>
                </div>

                <div class="question-display">
                    <span class="question-icon" id="question-icon">🤔</span>
                    <span class="question-text" id="question-text-element"></span>
                </div>

                <div class="question-image-container" id="question-image-container" style="display: none;">
                    <img src="" alt="Question Image" class="question-image" id="question-image">
                </div>

                <div class="audio-player-container" id="audio-player-container">
                        <%-- Custom Audio player will be populated by JavaScript --%>
                </div>

                <div class="options-container" id="options-container">
                    <div class="options-list" id="options-list">
                            <%-- Options or Input field will be populated by JavaScript --%>
                    </div>
                </div>
            </main>

            <footer class="quiz-footer">
                <div class="footer-buttons">
                    <button class="btn btn-skip" id="skip-btn">Skip</button>
                    <button class="btn btn-check" id="check-btn" disabled>Check</button>
                </div>
            </footer>

            <!-- Game Over Modal Popup HTML Structure -->
            <div id="modal-backdrop" class="hidden">
                <div id="game-over-modal" class="modal-content">
                    <div class="modal-icon">😭</div>
                    <h2 class="modal-title">Game Over!</h2>
                    <p class="modal-text">You've run out of hearts. Better luck next time!</p>
                    <div class="modal-buttons">
                        <button id="try-again-btn" class="btn btn-check">Try Again</button>
                        <a href="courses" class="btn btn-skip">Return to Courses</a>
                    </div>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<script>
    if (document.querySelector(".quiz-page")) {
        // === STATE MANAGEMENT ===
        const contextPath = "${contextPath}"; // MỚI: Lấy context path từ JSP
        const allQuestions = <%= questionsJson %>;
        let currentQuestionIndex = 0;
        let hearts = 5;
        let score = 0;
        let selectedOption = null;
        let answerChecked = false;

        // === DOM ELEMENTS ===
        const progressBar = document.getElementById('progress-bar');
        const heartsCountEl = document.getElementById('hearts-count');
        const questionTextEl = document.getElementById('question-text-element');
        const optionsListEl = document.getElementById('options-list');
        const checkBtn = document.getElementById('check-btn');
        const skipBtn = document.getElementById('skip-btn');
        const questionIconEl = document.getElementById('question-icon');
        const audioPlayerContainerEl = document.getElementById('audio-player-container');
        const questionImageContainerEl = document.getElementById('question-image-container');
        const questionImageEl = document.getElementById('question-image');
        const modalBackdrop = document.getElementById('modal-backdrop');
        const tryAgainBtn = document.getElementById('try-again-btn');

        // === SVG ICONS ===
        const playIcon = `<svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"></path></svg>`;
        const pauseIcon = `<svg viewBox="0 0 24 24"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"></path></svg>`;

        /**
         * Loads and displays the current question.
         */
        function loadQuestion(index) {
            if (index >= allQuestions.length) {
                showFinalScore();
                return;
            }

            // Reset state
            answerChecked = false;
            selectedOption = null;
            optionsListEl.innerHTML = '';
            audioPlayerContainerEl.innerHTML = '';
            audioPlayerContainerEl.style.display = 'none';
            questionImageContainerEl.style.display = 'none';
            questionImageEl.src = '';
            questionImageContainerEl.classList.remove('animate-image');

            // Reset buttons
            checkBtn.disabled = true;
            checkBtn.textContent = 'Check';
            checkBtn.style.background = '';
            checkBtn.style.borderColor = '';
            skipBtn.disabled = false;

            const question = allQuestions[index];
            questionTextEl.textContent = question.questionText;

            if (question.imageUrl) {
                // MỚI: Nối contextPath vào trước URL tương đối để tạo đường dẫn chính xác
                questionImageEl.src = contextPath + question.imageUrl;
                questionImageContainerEl.style.display = 'inline-block';
                void questionImageContainerEl.offsetWidth;
                questionImageContainerEl.classList.add('animate-image');
            }

            if (question.audioUrl) {
                // MỚI: Nối contextPath vào trước URL tương đối để tạo đường dẫn chính xác
                createAudioPlayer(contextPath + question.audioUrl);
                audioPlayerContainerEl.style.display = 'flex';
            }

            const isFillBlankType = ['fill_blank', 'fill_blank_audio', 'listening'].includes(question.type);
            if (isFillBlankType) {
                questionIconEl.textContent = '✏️';
                createFillInBlankInput();
            } else {
                questionIconEl.textContent = '🤔';
                createMultipleChoiceOptions(question);
            }

            updateProgress();
            updateHearts();
        }

        function createAudioPlayer(audioUrl) {
            const audioEl = new Audio(audioUrl);
            audioEl.preload = 'metadata';

            const playerWrapper = document.createElement('div');
            playerWrapper.className = 'custom-audio-player';
            const playBtn = document.createElement('button');
            playBtn.className = 'play-pause-btn';
            playBtn.innerHTML = playIcon;
            playBtn.setAttribute('aria-label', 'Play audio');
            const progressContainer = document.createElement('div');
            progressContainer.className = 'audio-progress-container';
            const progressBar = document.createElement('div');
            progressBar.className = 'audio-progress-bar';

            progressContainer.appendChild(progressBar);
            playerWrapper.appendChild(playBtn);
            playerWrapper.appendChild(progressContainer);
            playerWrapper.appendChild(audioEl);
            audioPlayerContainerEl.appendChild(playerWrapper);

            playBtn.addEventListener('click', () => audioEl.paused ? audioEl.play() : audioEl.pause());
            audioEl.addEventListener('play', () => { playBtn.innerHTML = pauseIcon; });
            audioEl.addEventListener('pause', () => { playBtn.innerHTML = playIcon; });
            audioEl.addEventListener('ended', () => { playBtn.innerHTML = playIcon; });
            audioEl.addEventListener('timeupdate', () => {
                const { currentTime, duration } = audioEl;
                if (duration) progressBar.style.width = `${(currentTime / duration) * 100}%`;
            });
            progressContainer.addEventListener('click', (e) => {
                const { duration } = audioEl;
                if(duration) {
                    const rect = progressContainer.getBoundingClientRect();
                    audioEl.currentTime = ((e.clientX - rect.left) / rect.width) * duration;
                }
            });
        }

        function createFillInBlankInput() {
            const input = document.createElement('input');
            input.type = 'text';
            input.id = 'fill-in-blank-input-field';
            input.className = 'fill-in-blank-input';
            input.placeholder = 'Type your answer...';
            input.autocomplete = 'off';
            input.addEventListener('input', () => {
                checkBtn.disabled = input.value.trim() === '';
            });
            optionsListEl.appendChild(input);
        }

        function createMultipleChoiceOptions(question) {
            const options = [question.optionA, question.optionB, question.optionC, question.optionD].filter(opt => opt);
            options.forEach(optText => {
                const button = document.createElement('button');
                button.className = 'option-item';
                button.textContent = optText;
                button.dataset.answer = optText;
                optionsListEl.appendChild(button);
            });
        }

        function updateProgress() {
            const percent = ((currentQuestionIndex) / allQuestions.length) * 100;
            progressBar.style.width = percent + "%";
        }

        function updateHearts() {
            heartsCountEl.textContent = hearts;
            if (hearts <= 0) {
                setTimeout(showGameOverModal, 500);
            }
        }

        function showGameOverModal() {
            modalBackdrop.classList.remove('hidden');
        }

        function handleOptionSelect(event) {
            if (answerChecked) return;
            const clickedButton = event.target.closest('.option-item');
            if (!clickedButton) return;

            if (selectedOption) {
                selectedOption.classList.remove('selected');
            }
            selectedOption = clickedButton;
            selectedOption.classList.add('selected');
            checkBtn.disabled = false;
        }

        function checkAnswer() {
            if (answerChecked) return;
            answerChecked = true;
            skipBtn.disabled = true;

            const question = allQuestions[currentQuestionIndex];
            const correctAnswer = (question.correctAnswer || '').trim();
            let userAnswer, isCorrect;

            if (question.type === 'fill_blank' || question.type === 'listening') {
                const inputField = document.getElementById('fill-in-blank-input-field');
                userAnswer = inputField.value.trim();
                isCorrect = userAnswer.toLowerCase() === correctAnswer.toLowerCase();
            } else {
                if (!selectedOption) return;
                userAnswer = selectedOption.dataset.answer.trim();
                isCorrect = userAnswer === correctAnswer;
            }

            if (isCorrect) {
                score++;
                if (question.type === 'fill_blank' || question.type === 'listening') {
                    document.getElementById('fill-in-blank-input-field').classList.add('correct');
                } else {
                    selectedOption.classList.add('correct');
                }
            } else {
                hearts--;
                if (question.type === 'fill_blank' || question.type === 'listening') {
                    const inputField = document.getElementById('fill-in-blank-input-field');
                    inputField.classList.add('wrong');
                    const correctAnswerEl = document.createElement('div');
                    correctAnswerEl.className = 'correct-answer-display';
                    correctAnswerEl.appendChild(document.createTextNode('Đáp án đúng: '));
                    const strongTag = document.createElement('strong');
                    strongTag.textContent = correctAnswer;
                    correctAnswerEl.appendChild(strongTag);
                    optionsListEl.appendChild(correctAnswerEl);
                } else {
                    selectedOption.classList.add('wrong');
                    const correctButton = optionsListEl.querySelector(`[data-answer="${correctAnswer}"]`);
                    if (correctButton) {
                        correctButton.classList.add('correct');
                    }
                }
            }

            if (question.type !== 'fill_blank' && question.type !== 'listening') {
                document.querySelectorAll('.option-item').forEach(opt => {
                    opt.style.pointerEvents = 'none';
                });
            }

            updateHearts();

            if (isCorrect) {
                checkBtn.style.background = 'var(--green-correct)';
                checkBtn.style.borderColor = '#208c3a';
            } else {
                checkBtn.style.background = 'var(--red-wrong)';
                checkBtn.style.borderColor = '#b52b39';
            }

            if (hearts <= 0) {
                checkBtn.textContent = 'Game Over';
                checkBtn.disabled = true;
                return;
            }

            checkBtn.textContent = (currentQuestionIndex < allQuestions.length - 1) ? 'Next' : 'Finish';
            checkBtn.disabled = false;
        }

        function goToNextStep() {
            if (answerChecked) {
                currentQuestionIndex++;
                loadQuestion(currentQuestionIndex);
            } else {
                checkAnswer();
            }
        }

        /**
         * =========================================================================
         * ==  NEW & VIBRANT FINAL SCORE SCREEN (RELIABLE VERSION)
         * =========================================================================
         */
        function showFinalScore() {
            const quizBody = document.querySelector('.quiz-body');
            const quizFooter = document.querySelector('.quiz-footer');
            const quizHeader = document.querySelector('.quiz-header');

            quizHeader.style.display = 'none';

            const totalQuestions = allQuestions.length;
            const finalScore = totalQuestions > 0 ? Math.round((score / totalQuestions) * 100) : 0;

            let titleText, iconChar, messageText, titleColor, animationClass;

            if (finalScore > 75) {
                titleText = "Excellent!";
                iconChar = '🏆';
                messageText = "You've absolutely mastered this course. Congratulations!";
                titleColor = 'var(--green-correct)';
                animationClass = 'pulse-animation';
            } else if (finalScore > 50) {
                titleText = "Great Job!";
                iconChar = '🤩';
                messageText = "You're doing great. Keep up the amazing work!";
                titleColor = 'var(--primary-orange-dark)';
                animationClass = 'pulse-animation';
            } else {
                titleText = "Nice Try!";
                iconChar = '⭐';
                messageText = "Every attempt is a step forward. Don't give up!";
                titleColor = 'var(--gray-medium)';
                animationClass = 'nod-animation';
            }

            // Clear the quiz body completely
            quizBody.innerHTML = '';

            // Create elements one by one for reliability
            const container = document.createElement('div');
            container.className = 'final-score-container';

            const icon = document.createElement('div');
            icon.className = `result-icon ${animationClass}`;
            icon.textContent = iconChar;

            const title = document.createElement('h1');
            title.className = 'result-title';
            title.style.color = titleColor;
            title.textContent = titleText;

            const scoreLabel = document.createElement('p');
            scoreLabel.className = 'score-display';
            scoreLabel.textContent = 'YOUR SCORE';

            const scoreValue = document.createElement('div');
            scoreValue.className = 'score-value';
            scoreValue.textContent = finalScore;

            const message = document.createElement('p');
            message.className = 'result-message';
            message.textContent = messageText;

            // Append all new elements to the container
            container.appendChild(icon);
            container.appendChild(title);
            container.appendChild(scoreLabel);
            container.appendChild(scoreValue);
            container.appendChild(message);

            // Add confetti for high scores
            if (finalScore > 75) {
                const confettiContainer = document.createElement('div');
                confettiContainer.className = 'confetti-container';
                const confettiColors = ['#ff9800', '#f44336', '#2196f3', '#4caf50', '#9c27b0', '#ffeb3b'];
                let confettiHtmlString = '';
                for (let i = 0; i < 150; i++) {
                    const color = confettiColors[Math.floor(Math.random() * confettiColors.length)];
                    const left = Math.random() * 100;
                    const delay = Math.random() * 5;
                    const duration = 3 + Math.random() * 4;
                    confettiHtmlString += `<i class="confetti" style="background-color: ${color}; left: ${left}%; animation-delay: ${delay}s; animation-duration: ${duration}s;"></i>`;
                }
                confettiContainer.innerHTML = confettiHtmlString;
                container.prepend(confettiContainer); // Prepend so it's in the background
            }

            // Finally, add the fully built container to the quiz body
            quizBody.appendChild(container);

            // Update footer
            quizFooter.innerHTML = `<a href="courses" class="btn btn-return" style="width: 100%; text-align:center; border-radius: 18px;">Return to Courses</a>`;
            progressBar.style.width = "100%";
        }

        // === EVENT LISTENERS ===
        optionsListEl.addEventListener('click', handleOptionSelect);
        checkBtn.addEventListener('click', goToNextStep);
        skipBtn.addEventListener('click', () => {
            if (answerChecked || hearts <= 0) return;
            hearts--;
            updateHearts();
            if (hearts > 0) {
                currentQuestionIndex++;
                loadQuestion(currentQuestionIndex);
            }
        });

        tryAgainBtn.addEventListener('click', () => {
            location.reload();
        });

        // === INITIAL LOAD ===
        loadQuestion(currentQuestionIndex);
    }
</script>

</body>
</html>