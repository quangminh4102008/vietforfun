package com.tiengviet.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter này bảo vệ các trang yêu cầu người dùng phải đăng nhập.
 * Nó kiểm tra xem session có tồn tại thuộc tính 'user' hay không.
 */
// QUAN TRỌNG: Bảo vệ các URL của trang quiz và các trang nội dung khóa học khác
@WebFilter({"/quiz", "/lesson"}) // <-- THÊM CÁC URL CẦN BẢO VỆ Ở ĐÂY
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // Không tạo session mới

        // Kiểm tra xem session có tồn tại và có chứa đối tượng 'user' không
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // Người dùng đã đăng nhập, cho phép tiếp tục truy cập
            chain.doFilter(request, response);
        } else {
            // Người dùng chưa đăng nhập, chuyển hướng về trang đăng nhập
            // Chúng ta cũng có thể lưu lại URL mà họ đang cố gắng truy cập để chuyển hướng lại sau khi đăng nhập
            String requestURI = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            if (queryString != null) {
                requestURI += "?" + queryString;
            }
            session = httpRequest.getSession(); // Tạo session mới để lưu redirectURL
            session.setAttribute("redirectURL", requestURI);

            // Đặt một thông báo lỗi để hiển thị trên trang login
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục!");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp"); // <-- ĐỔI THÀNH URL LOGIN CỦA BẠN
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}