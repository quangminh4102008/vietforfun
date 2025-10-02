package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;
// Thêm thư viện Gson để xử lý JSON
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Thiết lập kiểu nội dung trả về là JSON và encoding UTF-8
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 2. Sử dụng Map để xây dựng đối tượng sẽ được chuyển thành JSON
        Map<String, Object> jsonResponse = new HashMap<>();
        Gson gson = new Gson();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // Lỗi 401: Chưa đăng nhập
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "User not logged in. Please log in again.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String newUsername = request.getParameter("username");
        String newLevel = request.getParameter("level");

        if (newUsername == null || newUsername.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Lỗi 400: Dữ liệu gửi lên không hợp lệ
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Username cannot be empty.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        // Cập nhật thông tin vào đối tượng user
        currentUser.setUsername(newUsername);
        currentUser.setLevel(newLevel);

        try {
            UserDAO userDAO = new UserDAO();
            // Giả sử userDAO.updateUser(user) sẽ trả về true nếu thành công
            boolean updateSuccess = userDAO.updateUser(currentUser);

            if (updateSuccess) {
                // Cập nhật lại user trong session
                session.setAttribute("user", currentUser);

                // Chuẩn bị phản hồi thành công
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Profile updated successfully!");
                jsonResponse.put("updatedUser", currentUser); // Gửi cả thông tin user mới về
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Could not update profile in the database.");
            }
            // 3. Ghi chuỗi JSON vào response để gửi về cho JavaScript
            response.getWriter().write(gson.toJson(jsonResponse));

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Lỗi 500: Lỗi server
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "A database error occurred: " + e.getMessage());
            response.getWriter().write(gson.toJson(jsonResponse));
        }
    }
}