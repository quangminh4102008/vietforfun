package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;
import com.tiengviet.utils.SendGridUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();

        try {
            User user = userDAO.getUserByEmail(email);

            if (user == null) {
                request.setAttribute("errorMessage", "Email address not found in our system.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            String otp = String.format("%06d", new java.util.Random().nextInt(999999));
            SendGridUtils.sendOTP(email, otp);

            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("emailForPasswordReset", email);
            session.setMaxInactiveInterval(10 * 60);

            // =======================================================
            // CRITICAL FIX: Set attributes for the dynamic otp.jsp
            // =======================================================
            // 1. Tell the JSP which email to display (using the same attribute name for consistency).
            session.setAttribute("emailForVerification", email);

            session.setAttribute("formAction", "validate-otp-forgot");
            // =======================================================

            request.getRequestDispatcher("/otp.jsp").forward(request, response);

        } catch (SQLException | IOException e) {
            // ... your exception handling
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again later.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to the JSP page for GET requests
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }
}