package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // List users
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("userList", users);
            request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Cannot retrieve users", e);
        }
    }

    // Add / update / soft-delete
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "add":
                    handleAdd(request);
                    break;
                case "update":
                    handleUpdate(request);
                    break;
                case "delete":
                    handleDelete(request);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Error processing " + action, e);
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void handleAdd(HttpServletRequest req) throws SQLException {
        String username = req.getParameter("username");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");
        boolean active  = "true".equals(req.getParameter("active"));
        String level    = req.getParameter("level");

        // Hash password
        String hash = BCrypt.hashpw(password, BCrypt.gensalt());

        User u = new User();
        u.setUsername(username);
        u.setEmail(email);
        u.setHashPassword(hash);
        u.setRole(role);
        u.setActive(active);
        u.setLevel(level);

        userDAO.registerUser(u);
    }

    private void handleUpdate(HttpServletRequest req) throws SQLException {
        int id = Integer.parseInt(req.getParameter("id"));
        User u = userDAO.getUserByUsername(req.getParameter("username"));
        // Or better: add getUserById in DAO; here assume username unique
        u.setEmail(req.getParameter("email"));
        // If password field non-empty, re-hash
        String pwd = req.getParameter("password");
        if (pwd != null && !pwd.isEmpty()) {
            u.setHashPassword(BCrypt.hashpw(pwd, BCrypt.gensalt()));
        }
        u.setRole(req.getParameter("role"));
        u.setActive("true".equals(req.getParameter("active")));
        u.setLevel(req.getParameter("level"));

        userDAO.updateUser(u);
    }

    private void handleDelete(HttpServletRequest req) throws SQLException {
        int id = Integer.parseInt(req.getParameter("id"));
        userDAO.softDeleteUser(id);
    }
}
