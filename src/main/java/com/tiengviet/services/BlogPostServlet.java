package com.tiengviet.services;

import com.tiengviet.entity.BlogPost;
import com.tiengviet.utils.BlogData;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/blog/*") // Sử dụng wildcard để bắt tất cả các URL con của /blog/
public class BlogPostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo(); // Lấy phần sau "/blog", ví dụ: "/mastering-vietnamese-tones"

        if (pathInfo == null || pathInfo.equals("/")) {
            // Nếu không có slug, chuyển hướng về trang danh sách blog
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }

        String slug = pathInfo.substring(1); // Bỏ dấu "/" ở đầu để lấy slug
        BlogPost post = BlogData.findPostBySlug(slug);

        if (post != null) {
            // Nếu tìm thấy bài viết, gửi nó đến trang JSP chi tiết
            request.setAttribute("post", post);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/post-detail.jsp");
            dispatcher.forward(request, response);
        } else {
            // Nếu không tìm thấy, báo lỗi 404 Not Found
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}