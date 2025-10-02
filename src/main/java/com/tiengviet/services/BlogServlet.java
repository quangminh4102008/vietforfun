package com.tiengviet.services;

import com.tiengviet.entity.BlogPost;
import com.tiengviet.utils.BlogData; // Chúng ta sẽ tạo file này ngay sau đây

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/blog")
public class BlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy danh sách bài viết từ một nguồn dữ liệu chung
        List<BlogPost> posts = BlogData.getPosts();

        request.setAttribute("blogPosts", posts);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/blog.jsp");
        dispatcher.forward(request, response);
    }
}