package com.tiengviet.utils;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;

import java.io.IOException;

public class SendGridUtils {

    // SỬA ĐỔI 1: Lấy API Key từ biến môi trường của Render.
    private static final String SEND_API_KEY = System.getenv("SEND_API_KEY");

    // SỬA ĐỔI 2 (QUAN TRỌNG NHẤT): Thay đổi email người gửi thành tên miền đã xác thực.
    private static final String FROM_EMAIL = "noreply@vietforyou.com";

    // SỬA ĐỔI 3: Thêm tên người gửi để email trông chuyên nghiệp.
    private static final String FROM_NAME = "VietForYou";

    /**
     * Phương thức chính để gửi email, hỗ trợ cả nội dung HTML và Text.
     * @param toEmail Địa chỉ email người nhận.
     * @param subject Tiêu đề email.
     * @param htmlContent Nội dung email định dạng HTML.
     * @param plainTextContent Nội dung email dạng văn bản thuần (dự phòng).
     * @throws IOException Ném ra lỗi nếu không thể gửi email.
     */
    public static void sendEmail(String toEmail, String subject, String htmlContent, String plainTextContent) throws IOException {
        // Kiểm tra xem API key có tồn tại không để tránh lỗi
        if (SEND_API_KEY == null || SEND_API_KEY.isEmpty()) {
            System.err.println("LỖI: Biến môi trường SEND_API_KEY chưa được thiết lập!");
            throw new IOException("API Key của SendGrid không tồn tại.");
        }

        // Sử dụng email và tên đã định nghĩa ở trên
        Email from = new Email(FROM_EMAIL, FROM_NAME);
        Email to = new Email(toEmail);

        // SỬA ĐỔI 4: Tạo cả hai phiên bản nội dung (HTML và Text)
        Content plainContent = new Content("text/plain", plainTextContent);
        Content html = new Content("text/html", htmlContent);

        // Tạo đối tượng Mail và thêm cả 2 loại nội dung.
        // SendGrid sẽ tự động hiển thị HTML nếu client hỗ trợ, nếu không sẽ hiển thị Text.
        Mail mail = new Mail(from, subject, to, plainContent);
        mail.addContent(html);

        SendGrid sg = new SendGrid(SEND_API_KEY);
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());
            Response response = sg.api(request);

            // In ra log để kiểm tra
            System.out.println("Gửi email đến " + toEmail + ". Trạng thái: " + response.getStatusCode());

            // Nếu trạng thái không thành công (không phải 2xx), ném ra lỗi để Servlet có thể xử lý
            if (response.getStatusCode() < 200 || response.getStatusCode() >= 300) {
                throw new IOException("SendGrid trả về lỗi: " + response.getBody());
            }

        } catch (IOException ex) {
            System.err.println("Lỗi khi gửi email: " + ex.getMessage());
            throw ex; // Ném lại lỗi để lớp gọi nó (RegisterServlet) có thể bắt và xử lý
        }
    }

    /**
     * Phương thức chuyên dụng để tạo và gửi email chứa mã OTP.
     * @param toEmail Địa chỉ email người nhận.
     * @param otp Mã OTP cần gửi.
     * @throws IOException Ném ra lỗi nếu không thể gửi email.
     */
    public static void sendOTP(String toEmail, String otp) throws IOException {
        String subject = "Mã xác thực VietForYou của bạn";

        // SỬA ĐỔI 5: Tạo nội dung email HTML chuyên nghiệp để tránh bộ lọc Spam.
        String htmlContent = "<div style='font-family: Arial, sans-serif; text-align: center; color: #333;'>"
                + "<h1 style='color: #FFC107;'>VietForYou</h1>"
                + "<h2>Mã xác thực của bạn</h2>"
                + "<p>Vui lòng sử dụng mã dưới đây để hoàn tất việc đăng ký:</p>"
                + "<div style='font-size: 24px; font-weight: bold; background-color: #f2f2f2; padding: 10px 20px; border-radius: 5px; display: inline-block; letter-spacing: 5px;'>"
                + otp
                + "</div>"
                + "<p style='color: #888; font-size: 12px;'>Mã này có hiệu lực trong 10 phút.</p>"
                + "<p style='color: #888; font-size: 12px;'>Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email này.</p>"
                + "</div>";

        String plainTextContent = "Mã xác thực VietForYou của bạn là: " + otp + ". Mã này có hiệu lực trong 10 phút.";

        // Gọi phương thức gửi email chính
        sendEmail(toEmail, subject, htmlContent, plainTextContent);
    }
}