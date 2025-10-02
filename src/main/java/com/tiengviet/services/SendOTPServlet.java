package com.tiengviet.services;

import com.tiengviet.utils.SendGridUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Random;

@WebServlet("/send-otp")
public class SendOTPServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        // Generate 6-digit OTP
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Save OTP in session for later verification
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);

        // Send email
        try {
            SendGridUtils.sendOTP(email, otp);
            request.setAttribute("message", "OTP has been sent to your email.");
            request.getRequestDispatcher("otp.jsp").forward(request, response);
        } catch (IOException e) {
            e.printStackTrace();
            response.getWriter().println("Failed to send email.");
        }
    }
}
