package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/verify")
public class VerifyOTPServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Get existing session, don't create a new one
        String userOtp = request.getParameter("otp");

        // --- VALIDATION 1: CHECK FOR EXPIRED SESSION ---
        // If the session has expired, the user needs to start over.
        if (session == null || session.getAttribute("otp") == null) {
            request.setAttribute("errorMessage", "Your session has expired. Please log in again to reactivate your account.");
            request.getRequestDispatcher("login.jsp").forward(request, response); // Chuyển về login
            return;
        }

        String realOtp = (String) session.getAttribute("otp");
        User pendingUser = (User) session.getAttribute("pendingUser");

// === BỔ SUNG QUAN TRỌNG: Kiểm tra riêng pendingUser ===
        if (pendingUser == null || pendingUser.getEmail() == null || pendingUser.getEmail().isEmpty()) {
            System.err.println("ERROR: VerifyOTPServlet - pendingUser is null or incomplete in session. Redirecting to login.");
            request.setAttribute("errorMessage", "Session data for activation is missing or invalid. Please log in again to reactivate.");
            request.getRequestDispatcher("login.jsp").forward(request, response); // Chuyển về login
            return;
        }
        // --- VALIDATION 2: CHECK THE OTP ---
        if (userOtp != null && userOtp.equals(realOtp)) {
            // SUCCESS: OTP is correct. Activate the account.
            try {
                UserDAO.activateUserByEmail(pendingUser.getEmail());

                // IMPORTANT: Clean up the session after success
                session.removeAttribute("otp");
                session.removeAttribute("pendingUser");
                session.removeAttribute("emailForVerification");

                // Set a success message and redirect to the login page
                session.setAttribute("successMessage", "Your account has been successfully activated! Please log in.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Database error during account activation.");
                request.getRequestDispatcher("otp.jsp").forward(request, response);
            }
        } else {
            // FAILURE: OTP is incorrect. Send the user back to the OTP page.

            // Set the error message to display
            request.setAttribute("errorMessage", "Invalid OTP code. Please try again.");

            // CRITICAL: We must set 'formAction' again for the retry attempt
            session.setAttribute("formAction", "verify"); // Giữ nó trong session
            session.setAttribute("emailForVerification", pendingUser.getEmail());
            // Forward back to the OTP page
            RequestDispatcher dispatcher = request.getRequestDispatcher("otp.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect GET requests to prevent errors and direct access
        response.sendRedirect(request.getContextPath() + "/login.jsp"); // Chuyển về login
    }
}