<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Zest | VietJoy Assistant</title>
  <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/favicon-16x16.png">
  <link rel="manifest" href="${pageContext.request.contextPath}/site.webmanifest">
  <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">

  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      zoom: 80%;
      /* Đảm bảo chiều cao tối thiểu 100vh để footer không bị tràn lên khi nội dung ngắn */
      min-height: 100vh;
      overflow-x: hidden;
      font-family: 'Fredoka', sans-serif;
      background-color: #FFF9F0;
    }
  </style>
</head>
<body class="flex items-center justify-center h-screen">

<!-- Back to Home Button -->
<a href="/" class="fixed top-6 left-6 bg-white text-red-500 px-6 py-2 rounded-full font-bold shadow-lg hover:bg-red-500 hover:text-white transition">
  <i class="fas fa-arrow-left mr-2"></i> Back to Home
</a>

<!-- Main Chat Container -->
<div id="chat-container" class="w-full max-w-2xl h-[85vh] bg-white rounded-2xl shadow-2xl flex flex-col">
  <!-- Header -->
  <div class="bg-red-500 text-white p-4 rounded-t-2xl flex items-center">
    <i class="fas fa-comment-dots text-2xl mr-3"></i>
    <div>
      <h3 class="font-bold text-lg">VietJoy Chat Assistant</h3>
      <p class="text-sm">Ask me anything about learning Vietnamese!</p>
    </div>
  </div>

  <!-- Messages Area -->
  <div id="chat-box" class="flex-grow p-4 overflow-y-auto bg-gray-50 flex flex-col space-y-3">
    <!-- Initial Welcome Message -->
    <div class="flex">
      <div class="bg-gray-200 text-gray-800 p-3 rounded-lg max-w-xs">
        Hello! How can I help you today?
      </div>
    </div>
  </div>

  <!-- Input Area -->
  <div class="p-4 border-t border-gray-200 bg-white rounded-b-2xl">
    <div class="flex items-center space-x-2">
      <input type="text" id="user-message-input" placeholder="Type your question here..." class="flex-grow w-full px-4 py-2 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-yellow-400">
      <button id="send-message-btn" class="bg-red-500 text-white w-12 h-10 rounded-full flex-shrink-0 flex items-center justify-center hover:bg-red-600 transition">
        <i class="fas fa-paper-plane"></i>
      </button>
    </div>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const chatBox = document.getElementById("chat-box");
    const userMessageInput = document.getElementById("user-message-input");
    const sendMessageBtn = document.getElementById("send-message-btn");
    const CHAT_HISTORY_KEY = "zest_chat_history";

    // =======================================================
    // ===== STEP 1: RESTORE CHAT HISTORY ON PAGE LOAD =======
    // =======================================================
    function loadChatHistory() {
      const history = JSON.parse(sessionStorage.getItem(CHAT_HISTORY_KEY));
      if (history && history.length > 0) {
        // Clear the default welcome message
        chatBox.innerHTML = '';
        history.forEach(message => {
          // The last 'true' flag indicates this is from a page reload
          appendMessage(message.text, message.sender, false, true);
        });
      }
    }

    // =======================================================
    // ===== STEP 2: SAVE NEW MESSAGES TO HISTORY ============
    // =======================================================
    function saveMessageToHistory(text, sender) {
      // Get the existing history
      let history = JSON.parse(sessionStorage.getItem(CHAT_HISTORY_KEY)) || [];
      // Add the new message
      history.push({ text: text, sender: sender });
      // Save it back to sessionStorage
      sessionStorage.setItem(CHAT_HISTORY_KEY, JSON.stringify(history));
    }


    sendMessageBtn.addEventListener("click", sendMessage);
    userMessageInput.addEventListener("keypress", function(e) {
      if (e.key === "Enter") {
        sendMessage();
      }
    });

    function sendMessage() {
      const messageText = userMessageInput.value.trim();
      if (messageText === "") return;

      appendMessage(messageText, "user");
      saveMessageToHistory(messageText, "user"); // <-- SAVE USER'S MESSAGE
      userMessageInput.value = "";

      // Show loading indicator
      appendMessage("...", "bot", true);

      fetch("chatbot", {
        method: "POST",
        headers: {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"},
        body: "message=" + encodeURIComponent(messageText)
      })
              .then(response => response.json())
              .then(data => {
                // Remove the loading indicator before appending the real reply
                const loadingIndicator = document.querySelector('.loading-indicator');
                if (loadingIndicator) {
                  loadingIndicator.parentElement.parentElement.remove();
                }

                appendMessage(data.reply, "bot");
                saveMessageToHistory(data.reply, "bot"); // <-- SAVE BOT'S REPLY
              })
              .catch(error => {
                console.error("Error:", error);
                const loadingIndicator = document.querySelector('.loading-indicator');
                if (loadingIndicator) {
                  loadingIndicator.parentElement.parentElement.remove();
                }

                const errorMessage = "Sorry, I'm having some connection issues right now. Please try again in a moment.";
                appendMessage(errorMessage, "bot");
                saveMessageToHistory(errorMessage, "bot"); // <-- SAVE THE ERROR MESSAGE AS WELL
              });
    }

    // The "isReloading" parameter prevents scrolling when restoring history
    function appendMessage(text, sender, isLoading = false, isReloading = false) {
      const messageWrapper = document.createElement("div");
      const messageDiv = document.createElement("div");
      let wrapperClasses = "flex";
      let messageClasses = "p-3 rounded-lg max-w-md";

      if (sender === "user") {
        wrapperClasses += " justify-end";
        messageClasses += " bg-red-400 text-white";
      } else {
        messageClasses += " bg-gray-200 text-gray-800";
      }

      if (isLoading) {
        messageDiv.innerHTML = `<div class="loading-indicator flex items-center space-x-1"><span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></span><span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s;"></span><span class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s;"></span></div>`;
      } else {
        messageDiv.textContent = text;
      }

      messageWrapper.className = wrapperClasses;
      messageDiv.className = messageClasses;
      messageWrapper.appendChild(messageDiv);
      chatBox.appendChild(messageWrapper);

      // Only scroll automatically for new messages, not on page reload
      if (!isReloading) {
        chatBox.scrollTop = chatBox.scrollHeight;
      }
    }

    // Call the function to restore history when the page is fully loaded
    loadChatHistory();
  });
</script>

</body>
</html>