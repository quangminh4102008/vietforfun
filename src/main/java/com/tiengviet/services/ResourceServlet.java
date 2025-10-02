package com.tiengviet.services;
import com.tiengviet.DAO.ResourceDAO;
import com.tiengviet.entity.Resource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
@WebServlet("/admin/resources")
public class ResourceServlet extends HttpServlet {
    private ResourceDAO resourceDAO;

    @Override
    public void init() {
        resourceDAO = new ResourceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Resource> resourceList = resourceDAO.getAllResourcesForAdmin();
            request.setAttribute("resources", resourceList); // Tên là "resources" để khớp với JSP mẫu
            request.getRequestDispatcher("/admin/manage-resources.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error fetching resources for admin", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/resources");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addResource(request);
                    break;
                case "update":
                    updateResource(request);
                    break;
                case "delete":
                    deleteResource(request);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error processing resource action", e);
        }

        response.sendRedirect(request.getContextPath() + "/admin/resources");
    }

    private void addResource(HttpServletRequest request) throws SQLException {
        Resource resource = new Resource();
        setResourceFromRequest(resource, request);
        resource.setUploadedBy("Admin"); // Hoặc lấy từ session nếu có login
        resourceDAO.addResource(resource);
    }

    private void updateResource(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Resource resource = new Resource();
        resource.setId(id);
        setResourceFromRequest(resource, request);
        resourceDAO.updateResource(resource);
    }

    private void deleteResource(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        resourceDAO.deleteResource(id);
    }

    // Phương thức tiện ích để tránh lặp code
    private void setResourceFromRequest(Resource resource, HttpServletRequest request) {
        resource.setTitle(request.getParameter("title"));
        resource.setDescription(request.getParameter("description"));
        resource.setType(request.getParameter("type"));
        resource.setUrl(request.getParameter("url"));
        resource.setImageUrl(request.getParameter("imageUrl"));
        resource.setContent(request.getParameter("content"));
        // Checkbox: nếu được check, parameter sẽ không null, ngược lại sẽ null
        resource.setVisible(request.getParameter("is_visible") != null);
    }
}
