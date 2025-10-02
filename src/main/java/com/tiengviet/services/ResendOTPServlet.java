package com.tiengviet.services;

import com.tiengviet.entity.User; // Đảm bảo import User entity
import com.tiengviet.utils.SendGridUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

@WebServlet("/resend-otp")
public class ResendOTPServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("emailForVerification");
        User pendingUser = (User) session.getAttribute("pendingUser");
        String formAction = (String) session.getAttribute("formAction"); // Lấy action từ SESSION

        if (email == null || email.isEmpty() || pendingUser == null || formAction == null) {
            System.err.println("ResendOTPServlet: Session data incomplete. Redirecting to login.");
            response.sendRedirect("login.jsp");
            return;
        }

        String newOtp = String.format("%06d", new Random().nextInt(999999));

        SendGridUtils.sendOTP(email, newOtp);
        // Cập nhật OTP MỚI vào session
        session.setAttribute("otp", newOtp);
        request.setAttribute("successMessage", "A new OTP has been sent successfully!");

        // Không cần request.setAttribute("formAction", action) vì nó đã có trong session rồi

        request.getRequestDispatcher("otp.jsp").forward(request, response);
    }
}