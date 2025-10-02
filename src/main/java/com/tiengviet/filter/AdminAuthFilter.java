package com.tiengviet.filter;

import com.tiengviet.entity.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * This filter protects all pages under the /admin/ path.
 * It checks if a user is logged in and if that user has the 'admin' role.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if any.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false); // Do not create a new session if one doesn't exist

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isAdmin = false;

        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            if ("admin".equals(user.getRole())) {
                isAdmin = true;
            }
        }

        if (isAdmin) {
            // User is admin, allow access to the requested page
            chain.doFilter(request, response);
        } else {
            // User is not an admin or not logged in
            // Redirect to the login page with an error message
            httpRequest.setAttribute("errorMessage", "Bạn không có quyền truy cập vào trang này!");
            // You can also redirect to a specific error page e.g. /error-403.jsp
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code, if any.
    }
}