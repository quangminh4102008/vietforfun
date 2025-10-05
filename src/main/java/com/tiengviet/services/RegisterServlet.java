package com.tiengviet.services;
import com.tiengviet.DAO.UserDAO;
import com.tiengviet.entity.User;
import com.tiengviet.utils.SendGridUtils;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String level = request.getParameter("level");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Giữ lại tất cả logic kiểm tra mật khẩu, email... của bạn ở đây
        // ...

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setHashPassword(hashedPassword);
        newUser.setLevel(level);
        newUser.setRole("user");
        newUser.setActive(false);

        // --- BẮT ĐẦU: PHẦN SỬA ĐỔI XỬ LÝ LỖI ---
        try {
            userDAO.registerUser(newUser);

        } catch (SQLException e) {
            // PostgreSQL trả về mã '23505' cho lỗi vi phạm ràng buộc duy nhất (unique constraint violation)
            if ("23505".equals(e.getSQLState())) {
                String errorMessage;
                // Kiểm tra thông báo lỗi để biết lỗi trùng lặp ở cột nào
                if (e.getMessage().contains("users_username_key")) {
                    errorMessage = "Tên người dùng '" + username + "' đã tồn tại. Vui lòng chọn tên khác.";
                } else if (e.getMessage().contains("users_email_key")) { // Giả sử bạn có constraint cho email
                    errorMessage = "Email '" + email + "' đã được đăng ký. Vui lòng đăng nhập.";
                } else {
                    errorMessage = "Tên người dùng hoặc email đã tồn tại.";
                }

                // 1. Đặt thông báo lỗi vào request
                request.setAttribute("errorMessage", errorMessage);

                // 2. Chuyển hướng người dùng trở lại trang đăng ký để hiển thị lỗi
                request.getRequestDispatcher("register.jsp").forward(request, response);

                // 3. Dừng thực thi phương thức này
                return;
            } else {
                // Nếu là một lỗi SQL khác (vd: mất kết nối DB), thì mới ném ra lỗi server
                throw new ServletException("Lỗi cơ sở dữ liệu khi đăng ký người dùng.", e);
            }
        }
        // --- KẾT THÚC: PHẦN SỬA ĐỔI XỬ LÝ LỖI ---

        // Nếu không có lỗi, code sẽ tiếp tục chạy từ đây
        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        try {
            SendGridUtils.sendOTP(email, otp);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Không thể gửi mã OTP. Vui lòng thử lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("pendingUser", newUser);
        session.setMaxInactiveInterval(10 * 60);

        session.setAttribute("emailForVerification", newUser.getEmail());
        session.setAttribute("formAction", "verify");

        request.getRequestDispatcher("otp.jsp").forward(request, response);
    }
}