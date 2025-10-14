package com.tiengviet.services;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@WebServlet("/chatbot")
public class ChatboxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OkHttpClient httpClient = new OkHttpClient();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This correctly forwards to your dedicated chat page. No changes needed here.
        RequestDispatcher dispatcher = request.getRequestDispatcher("/chatbot.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String userMessage = request.getParameter("message");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("reply", "Message cannot be empty.");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }

        // ==========================================================
        // ===== CONFIGURATION FOR OPENROUTER API CALL =============
        // ==========================================================

        // Step 1: Replace with your actual API Key from OpenRouter
        // It should start with "sk-or-..."
        // Step 1: Read the API Key from an Environment Variable
        final String OPENROUTER_API_KEY = System.getenv("OPENROUTER_API_KEY");

// (Optional but Recommended) Add a check to ensure the key was loaded
        if (OPENROUTER_API_KEY == null || OPENROUTER_API_KEY.trim().isEmpty()) {
            System.err.println("FATAL ERROR: OPENROUTER_API_KEY environment variable not set.");
            // Stop the request immediately because we cannot proceed without a key
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("reply", "Server is not configured correctly. Missing API Key.");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }

        // Step 2: Choose your model. Nous Hermes 2 is highly recommended (powerful and very cheap).
        final String MODEL_NAME = "deepseek/deepseek-chat-v3.1:free";

        // Step 3: OpenRouter's fixed API URL
        final String API_URL = "https://openrouter.ai/api/v1/chat/completions";

        // Step 4: Your excellent knowledge base for Zest (no changes needed)
        String systemPrompt =
                "### Role and Goal ###\n" +
                        "You are 'Zest', a friendly and intelligent AI assistant for the website 'Vietforyou'. " +
                        "Your primary goal is to answer user questions about Vietforyou and encourage them on their journey of learning the Vietnamese language.\n\n" +

                        "### Persona ###\n" +
                        "- **Name:** Zest\n" +
                        "- **Characteristics:** Cheerful, enthusiastic, patient, and very encouraging. You love seeing people learn Vietnamese. Your tone should be simple and easy for language learners to understand.\n\n" +

                        "### Information about Vietforyou ###\n" +
                        "- **Mission:** Vietforyou was created to help overseas Vietnamese reconnect with their mother tongue and to help foreigners learn Vietnamese in a fun and easy way, like playing a game.\n" +
                        "- **Founder:** Vietforyou was founded by Mr. Trương Minh Quang.\n" +
                        "- **Target Audience:** Primarily overseas Vietnamese and anyone who loves Vietnamese culture and language.\n" +
                        "- **Services and Products:**\n" +
                        "  - **Fun Courses:** Vietforyou offers courses with a structured learning path, from basic greetings ('Xin chào') to complex conversations. The teaching method is designed to be fun and engaging, like a game.\n" +
                        "  - **Free Resources:** The website offers many free materials, including flashcards, worksheets, and audio clips for listening and pronunciation practice. Users can find these in the 'Resources' section.\n" +
                        "  - **Friendly Community:** Vietforyou has a supportive community where learners can study together, correct each other's mistakes, and cheer each other on. The motto is 'Mistakes are part of the fun of learning'.\n" +
                        "- **Contact Information:**\n" +
                        "  - **Email:** bi066109@gmail.com\n" +
                        "  - **Phone:** +84 (329) 499-444\n\n" +

                        "### Rules ###\n" +
                        "1.  **Always be Zest:** If appropriate, start your response by introducing yourself (e.g., 'Hello! Zest here.'). Maintain the cheerful and encouraging persona throughout the conversation.\n" +
                        "2.  **Use the Provided Information:** Base your answers strictly on the knowledge provided in the 'Information about Vietforyou' section. Do not make up facts.\n" +
                        "3.  **Handle Unknown Questions Gracefully:** If the user asks for information not in your knowledge base (e.g., 'how much are the courses?', 'what is the class schedule?'), you must not invent an answer. Instead, politely state that you don't have that specific information and guide them to the official contact channels. For example: 'That's a great question! I don't have specific details about pricing right now. For the most accurate information, it's best to contact the Vietforyou team directly via email at bi066109@gmail.com. They'll be happy to help!'.\n" +
                        "4.  **Language Rule:** This is very important. If the user asks a question in Vietnamese, you must answer in Vietnamese. If they ask in English, answer in English. Match the user's language.";

        try {
            // CONSTRUCT THE JSON BODY FOR OPENROUTER (OpenAI-compatible format)
            JSONObject requestBodyJson = new JSONObject();
            requestBodyJson.put("model", MODEL_NAME);

            // Create the messages array
            JSONArray messages = new JSONArray();
            messages.put(new JSONObject().put("role", "system").put("content", systemPrompt)); // The instructions for Zest
            messages.put(new JSONObject().put("role", "user").put("content", userMessage));      // The user's actual question

            requestBodyJson.put("messages", messages);

            RequestBody body = RequestBody.create(
                    requestBodyJson.toString(),
                    MediaType.get("application/json; charset=utf-8")
            );

            // BUILD THE REQUEST WITH THE CORRECT AUTHENTICATION HEADER
            Request apiRequest = new Request.Builder()
                    .url(API_URL)
                    .post(body)
                    .addHeader("Authorization", "Bearer " + OPENROUTER_API_KEY) // This is how OpenRouter authenticates
                    .addHeader("HTTP-Referer", "http://localhost:8080") // Recommended by OpenRouter
                    .addHeader("X-Title", "Vietforyou Chatbot") // Recommended by OpenRouter
                    .build();

            // Execute the API call
            try (Response apiResponse = httpClient.newCall(apiRequest).execute()) {
                String responseBody = apiResponse.body().string();
                if (!apiResponse.isSuccessful()) {
                    System.err.println("API Call Failed: " + responseBody);
                    throw new IOException("Unexpected code ".concat(String.valueOf(apiResponse)));
                }

                JSONObject openRouterResponse = new JSONObject(responseBody);

                // PARSE THE RESPONSE FROM OPENROUTER
                String botReply = openRouterResponse.getJSONArray("choices")
                        .getJSONObject(0)
                        .getJSONObject("message")
                        .getString("content");

                jsonResponse.put("reply", botReply.trim());
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("reply", "Sorry, Zest is experiencing a connection issue. Please try again in a moment.");
        }

        out.print(jsonResponse.toString());
        out.flush();
    }
}