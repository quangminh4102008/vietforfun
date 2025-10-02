package com.tiengviet.services;

import com.tiengviet.DAO.UserDAO;
import org.mindrot.jbcrypt.BCrypt; // <-- BƯỚC 1: THÊM IMPORT NÀY

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String email = (String) session.getAttribute("emailForPasswordReset");
        Boolean isOtpVerified = (Boolean) session.getAttribute("isOtpVerifiedForReset");

        // Kiểm tra an ninh: Đảm bảo người dùng đã đi đúng luồng
        if (email == null || isOtpVerified == null || !isOtpVerified) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Xác thực đầu vào
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra độ phức tạp của mật khẩu (giống như trang đăng ký)
        if (!newPassword.matches("(?=.*\\d).{8,}")) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters and include a number.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();

            // === BƯỚC 2: HASH MẬT KHẨU GIỐNG HỆT REGISTER SERVLET ===
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            boolean isUpdated = userDAO.updatePasswordByEmail(email, hashedPassword);

            if (isUpdated) {
                // Dọn dẹp session
                session.removeAttribute("emailForPasswordReset");
                session.removeAttribute("isOtpVerifiedForReset");

                // Đặt thông báo thành công và chuyển về trang đăng nhập
                session.setAttribute("successMessage", "Your password has been reset successfully! Please log in.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                request.setAttribute("errorMessage", "Could not update the password. Please try again.");
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}