package com.tiengviet.utils;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;

import java.io.IOException;

public class SendGridUtils {

    // DÒNG CODE MỚI (ĐÚNG)
    private static final String API_KEY = System.getenv("API_KEY");
    private static final String FROM_EMAIL = "vietjoy0@gmail.com";

    public static boolean sendEmail(String toEmail, String subject, String contentText) {
        Email from = new Email(FROM_EMAIL);
        Email to = new Email(toEmail);
        Content content = new Content("text/plain", contentText);
        Mail mail = new Mail(from, subject, to, content);

        SendGrid sg = new SendGrid(API_KEY);
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
        Email from = new Email(FROM_EMAIL);
        String subject = "Your OTP Code";
        Email to = new Email(toEmail);
        String contentText = "Your OTP code is: " + otp;
        Content content = new Content("text/plain", contentText);

        Mail mail = new Mail(from, subject, to, content);
        SendGrid sg = new SendGrid(API_KEY);
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
