package com.tiengviet.utils;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;

import java.io.IOException;

public class SendGridUtils {

    // DÒNG CODE MỚI (ĐÚNG)
    private static final String SEND_API_KEY = System.getenv("SEND_API_KEY");
    private static final String FROM_EMAIL = "vietjoy0@gmail.com";

    public static boolean sendEmail(String toEmail, String subject, String contentText) {
        Email from = new Email(FROM_EMAIL);
        Email to = new Email(toEmail);
        Content content = new Content("text/plain", contentText);
        Mail mail = new Mail(from, subject, to, content);

        SendGrid sg = new SendGrid(SEND_API_KEY);
        Request request = new Request();
        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);
            System.out.println("SendGrid Response: " + response.getStatusCode());
            return response.getStatusCode() >= 200 && response.getStatusCode() < 300;
        } catch (IOException ex) {
            ex.printStackTrace();
            return false;
        }
    }
    public static void sendOTP(String toEmail, String otp) throws IOException {
        // --- THÊM ĐOẠN CODE DEBUG NÀY VÀO ---
        String apiKey = System.getenv("SEND_API_KEY");
        if (apiKey != null && !apiKey.isEmpty() && apiKey.length() > 12) {
            System.out.println("DEBUG: Key loaded. Starts with: " + apiKey.substring(0, 8) + ", Ends with: " + apiKey.substring(apiKey.length() - 4));
        } else {
            System.out.println("DEBUG: API Key is NULL or too short to be valid!");
        }
        // --- KẾT THÚC ĐOẠN CODE DEBUG ---

        Email from = new Email(FROM_EMAIL);
        String subject = "Your OTP Code";
        Email to = new Email(toEmail);
        String contentText = "Your OTP code is: " + otp;
        Content content = new Content("text/plain", contentText);

        Mail mail = new Mail(from, subject, to, content);
        // Chú ý: Đảm bảo bạn sử dụng biến `apiKey` ở đây, thay vì `SEND_API_KEY` trực tiếp
        SendGrid sg = new SendGrid(apiKey);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);
            System.out.println("Email sent! Status code: " + response.getStatusCode());
        } catch (IOException ex) {
            throw ex;
        }
    }
}
