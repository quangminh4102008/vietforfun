package com.tiengviet.services;

import com.tiengviet.DAO.CourseDAO;
import com.tiengviet.entity.Course;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/course")
public class CourseServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String search = req.getParameter("search");
        String level = req.getParameter("level");
        String status = req.getParameter("status");
        String sort     = req.getParameter("sort");
        CourseDAO dao = new CourseDAO();
        try {
//            List<Course> courses = dao.filterCourses(search, level, status, sort);
            List<Course> courses = dao.getAllActiveCourses();
            req.setAttribute("courses", courses);

            String editIdStr = req.getParameter("editId");
            if (editIdStr != null) {
                int editId = Integer.parseInt(editIdStr);
                Course editCourse = dao.getCourseById(editId);
                req.setAttribute("editCourse", editCourse);
            }

            req.getRequestDispatcher("/admin/manage-courses.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi load trang quản lý.");
        }
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        CourseDAO dao = new CourseDAO();

        try {
            if ("add".equals(action)) {
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String level = req.getParameter("level");
                boolean published = req.getParameter("is_published") != null;
                String thumbnail = req.getParameter("thumbnailUrl");

                Course course = new Course(0, title, description, level, published, thumbnail, "active");
                dao.addCourse(course);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String title = req.getParameter("title");
                String description = req.getParameter("description");
                String level = req.getParameter("level");
                boolean published = req.getParameter("is_published") != null;
                String thumbnail = req.getParameter("thumbnailUrl");

                Course course = new Course(id, title, description, level, published, thumbnail, "active");
                dao.updateCourse(course);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.softDeleteCourse(id);
            }

            resp.sendRedirect("/admin/course");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
