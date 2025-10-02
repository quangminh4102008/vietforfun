package com.tiengviet.services;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * This servlet is dedicated to validating the OTP for the password reset flow.
 * It ensures a clear separation of concerns from the new user verification flow.
 */
@WebServlet("/validate-otp-forgot")
public class ValidateOtpForgotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // Use false to not create a new session
        String userOtp = request.getParameter("otp");

        // --- SECURITY CHECK: Ensure a session exists and has the required attributes ---
        if (session == null || session.getAttribute("otp") == null || session.getAttribute("emailForPasswordReset") == null) {
            request.setAttribute("errorMessage", "Your session has expired or is invalid. Please start the password reset process again.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        String sessionOtp = (String) session.getAttribute("otp");

        // --- OTP VALIDATION ---
        if (userOtp != null && userOtp.equals(sessionOtp)) {
            // SUCCESS: The OTP is correct.

            // 1. Set a security flag in the session to grant access to the password reset page.
            session.setAttribute("isOtpVerifiedForReset", true);

            // 2. Remove the OTP from the session to prevent it from being used again.
            session.removeAttribute("otp");

            // 3. Redirect the user to the page to enter their new password.
            response.sendRedirect(request.getContextPath() + "/reset-password.jsp");

        } else {
            // FAILURE: The OTP is incorrect.

            // 1. Set an appropriate error message.
            request.setAttribute("errorMessage", "Invalid OTP code. Please check the code and try again.");

            // 2. We must set the formAction attribute again for the OTP page, so it knows
            //    where to re-submit the form. This is crucial.
            request.setAttribute("formAction", "validate-otp-forgot");

            // 3. Forward the request back to the OTP entry page for the user to retry.
            RequestDispatcher dispatcher = request.getRequestDispatcher("/otp.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Prevent direct GET access to this servlet for security reasons.
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}