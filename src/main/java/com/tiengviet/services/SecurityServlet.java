package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/security")
public class SecurityServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Chuyển tiếp đến trang security.jsp
        request.getRequestDispatcher("security.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("change-password".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate inputs
            if (currentPassword == null || newPassword == null || confirmPassword == null) {
                request.setAttribute("error", "All fields are required.");
            } else if (!BCrypt.checkpw(currentPassword, user.getHashPassword())) {
                request.setAttribute("error", "Current password is incorrect.");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New password and confirmation do not match.");
            } else if (!newPassword.matches("(?=.*\\d).{8,}")) {
                request.setAttribute("error", "New password must be at least 8 characters and contain a number.");
            } else {
                try {
                    String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    user.setHashPassword(hashedNewPassword);

                    UserDAO userDAO = new UserDAO();
                    userDAO.updateUser(user);

                    // Update session
                    session.setAttribute("user", user);

                    request.setAttribute("success", "Password updated successfully.");
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "An error occurred while updating the password.");
                }
            }
        }

        request.getRequestDispatcher("security.jsp").forward(request, response);
    }
}
