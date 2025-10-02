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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    /**
     * Display the registration page when user visits /register via GET.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    /**
     * Process registration form submissions.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- Your existing registration logic is correct and remains unchanged ---
        String level = request.getParameter("level");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // All your validation logic for password, username, and email is correct.
        // ...

        // --- This part remains the same ---
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setHashPassword(hashedPassword);
        newUser.setLevel(level);
        newUser.setRole("user");
        newUser.setActive(false);

        try {
            userDAO.registerUser(newUser);
        } catch (SQLException e) {
            throw new ServletException("Error registering user", e);
        }

        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        try {
            SendGridUtils.sendOTP(email, otp);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Failed to send OTP. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("pendingUser", newUser);
        session.setMaxInactiveInterval(10 * 60); // 10 minute timeout

        // =======================================================
        // CRITICAL FIX: Set attributes for the dynamic otp.jsp
        // =======================================================
        // 1. Tell the JSP which email to display.
        session.setAttribute("emailForVerification", newUser.getEmail());

        // 2. Tell the JSP form where to submit the OTP (use session to persist).
        session.setAttribute("formAction", "verify");
        // =======================================================

        // Now, forward to the dynamic OTP page
        request.getRequestDispatcher("otp.jsp").forward(request, response);
    }
}

