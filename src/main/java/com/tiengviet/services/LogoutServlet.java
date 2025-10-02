package com.tiengviet.services;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Processes GET requests to log the user out.
     * Invalidates the current session (if any) and redirects to the home page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve existing session, do not create a new one if it doesn't exist
        HttpSession session = request.getSession(false);

        // If a session exists, invalidate it to clear all stored attributes
        if (session != null) {
            session.invalidate();
        }

        // Redirect the user to the home page after logout
        response.sendRedirect(request.getContextPath() + "/");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
