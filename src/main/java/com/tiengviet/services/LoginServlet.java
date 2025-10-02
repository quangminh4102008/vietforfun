package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;
import com.tiengviet.utils.SendGridUtils;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = userDAO.getUserByUsername(username);

            // Check if user exists and password is correct
            if (user != null && BCrypt.checkpw(password, user.getHashPassword())) {
                // Credentials correct, now check if active
                if (user.isActive()) {
                    // CASE 1: ACTIVE ACCOUNT (Login success)
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/home");
                } else {
                    // CASE 2: INACTIVE ACCOUNT (Start OTP verification)
                    String email = user.getEmail();
                    String otp = String.format("%06d", new Random().nextInt(999999));

                    SendGridUtils.sendOTP(email, otp);

                    // Save necessary data to session
                    HttpSession session = request.getSession();
                    session.setAttribute("otp", otp);
                    session.setAttribute("pendingUser", user); // This is needed by VerifyOTPServlet

                    // =======================================================
                    // CRITICAL FIX: Set attributes for the dynamic otp.jsp
                    // =======================================================
                    // 1. Tell the JSP which email to display.
                    session.setAttribute("emailForVerification", email);
                    session.setAttribute("formAction", "verify");
                    // =======================================================

                    // Forward to the OTP page with an info message
                    request.setAttribute("errorMessage", "Account is not active. A new verification code has been sent.");
                    request.getRequestDispatcher("otp.jsp").forward(request, response);
                }
            } else {
                // CASE 3: WRONG CREDENTIALS
                request.setAttribute("errorMessage", "Invalid username or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException | IOException e) {
            e.printStackTrace();
            throw new ServletException("Error during login", e);
        }
    }
}